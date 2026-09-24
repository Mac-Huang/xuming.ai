from __future__ import annotations

import logging
import mmap
import os
import platform
import sys
import time
from dataclasses import dataclass
from typing import Dict, List, Optional

from config import AppConfig
from inference_client import OllamaClient
from metrics import (
    build_counter_columns,
    build_counter_row,
    capture_snapshot,
    get_disk_free_bytes,
    get_total_memory_bytes,
    page_fault_measurement_note,
)
from pressure_manager import PressureHandle, PressureManager
from utils import (
    append_csv_row,
    format_bytes,
    hostname,
    read_completed_run_ids,
    round_down_to,
    stable_run_id,
    utc_now_iso,
)


LOGGER = logging.getLogger(__name__)

INFERENCE_FIELDNAMES = [
    "run_id",
    "status",
    "error",
    "timestamp_utc",
    "pilot_mode",
    "condition_name",
    "pressure_mode",
    "requested_fraction_of_ram",
    "actual_fraction_of_ram",
    "requested_size_bytes",
    "actual_size_bytes",
    "trial_id",
    "request_index",
    "model_name",
    "prompt_id",
    "max_tokens",
    "temperature",
    "latency_ms",
    "response_chars",
    "response_digest",
    "eval_count",
    "eval_duration_ns",
    "prompt_eval_count",
    "prompt_eval_duration_ns",
    "total_duration_ns",
    "load_duration_ns",
    "tokens_per_second",
]

SYSTEM_FIELDNAMES = [
    "run_id",
    "status",
    "error",
    "started_at_utc",
    "ended_at_utc",
    "pilot_mode",
    "condition_name",
    "pressure_mode",
    "requested_fraction_of_ram",
    "actual_fraction_of_ram",
    "requested_size_bytes",
    "actual_size_bytes",
    "trial_id",
    "num_requests",
    "successful_requests",
    "error_requests",
    "stabilization_seconds",
    "wall_time_s",
    "inference_batch_time_s",
    "pressure_worker_pid",
    "size_capped",
    "host_name",
    "platform_system",
    "platform_release",
    "python_version",
    "model_name",
    "prompt_id",
    "page_fault_support",
]
SYSTEM_FIELDNAMES.extend(build_counter_columns())


@dataclass(frozen=True)
class Condition:
    pressure_mode: str
    requested_fraction: float
    requested_size_bytes: int
    planned_size_bytes: int
    trial_id: int
    condition_name: str
    run_id: str


class ExperimentRunner:
    def __init__(
        self,
        config: AppConfig,
        *,
        pilot: bool,
        force: bool,
        modes_override: Optional[List[str]] = None,
        fractions_override: Optional[List[float]] = None,
    ) -> None:
        self.config = config
        self.pilot = pilot
        self.force = force
        self.modes_override = modes_override
        self.fractions_override = fractions_override
        self.total_memory_bytes = get_total_memory_bytes()
        self.page_size = mmap.PAGESIZE
        self.client = OllamaClient(config.ollama)
        self.pressure_manager = PressureManager(
            startup_timeout_s=config.pressure.startup_timeout_s,
            shutdown_timeout_s=config.pressure.shutdown_timeout_s,
        )
        self.completed_run_ids = set() if force else read_completed_run_ids(config.paths.system_csv)

    def run(self) -> Dict[str, object]:
        LOGGER.info("Detected total RAM: %s", format_bytes(self.total_memory_bytes))
        LOGGER.info("Using config file: %s", self.config.config_path)

        conditions = self._build_conditions()
        self._prepare_pressure_file(conditions)
        self._validate_ollama()

        executed_conditions = 0
        skipped_conditions = 0
        for condition in conditions:
            if not self.force and condition.run_id in self.completed_run_ids:
                skipped_conditions += 1
                LOGGER.info("Skipping completed run %s", condition.run_id)
                continue
            self._run_condition(condition)
            executed_conditions += 1

        return {
            "pilot_mode": self.pilot,
            "config_path": str(self.config.config_path),
            "model_name": self.config.ollama.model,
            "total_memory_bytes": self.total_memory_bytes,
            "condition_count": len(conditions),
            "executed_conditions": executed_conditions,
            "skipped_conditions": skipped_conditions,
            "page_fault_support": page_fault_measurement_note(),
            "selected_modes": self._active_modes(),
            "selected_requested_fractions": self._active_fractions(),
        }

    def _condition_name(self, mode: str, requested_fraction: float, actual_size_bytes: int) -> str:
        if mode == "none":
            return "none_baseline"
        actual_fraction = (
            0.0 if self.total_memory_bytes == 0 else actual_size_bytes / self.total_memory_bytes
        )
        return f"{mode}__req_{requested_fraction:.2f}x__actual_{actual_fraction:.2f}x"

    def _build_conditions(self) -> List[Condition]:
        fractions = self._active_fractions()
        trials = self.config.experiment.active_trials(self.pilot)
        file_cap = self._max_file_backed_bytes()
        anon_cap = round_down_to(
            int(self.total_memory_bytes * self.config.pressure.anon_safe_max_fraction_of_ram),
            self.page_size,
        )

        conditions: List[Condition] = []
        for mode in self._active_modes():
            requested_fractions = [0.0] if mode == "none" else fractions
            for requested_fraction in requested_fractions:
                requested_size = (
                    0
                    if mode == "none"
                    else round_down_to(int(self.total_memory_bytes * requested_fraction), self.page_size)
                )
                if mode == "none":
                    planned_size = 0
                elif mode in {"file_seq", "mmap_random"}:
                    planned_size = min(requested_size, file_cap)
                else:
                    planned_size = min(requested_size, anon_cap)

                condition_name = self._condition_name(mode, requested_fraction, planned_size)

                for trial_id in range(1, trials + 1):
                    conditions.append(
                        Condition(
                            pressure_mode=mode,
                            requested_fraction=requested_fraction,
                            requested_size_bytes=requested_size,
                            planned_size_bytes=planned_size,
                            trial_id=trial_id,
                            condition_name=condition_name,
                            run_id=stable_run_id(
                                self.pilot,
                                mode,
                                requested_fraction,
                                planned_size,
                                trial_id,
                            ),
                        )
                    )

        LOGGER.info("Planned %s conditions", len(conditions))
        return conditions

    def _active_modes(self) -> List[str]:
        return self.modes_override or ["none", "file_seq", "mmap_random", "anon"]

    def _active_fractions(self) -> List[float]:
        if self.fractions_override:
            return self.fractions_override
        return self.config.experiment.active_pressure_fractions(self.pilot)

    def _max_file_backed_bytes(self) -> int:
        pressure_file = self.config.paths.pressure_data_file
        existing_bytes = pressure_file.stat().st_size if pressure_file.exists() else 0
        disk_free_bytes = get_disk_free_bytes(self.config.paths.data_dir)
        allowed_growth = int(disk_free_bytes * self.config.pressure.disk_free_utilization_limit)
        max_file_bytes = round_down_to(existing_bytes + allowed_growth, self.page_size)
        LOGGER.info(
            "File-backed pressure cap is %s based on existing file=%s and allowed disk growth=%s",
            format_bytes(max_file_bytes),
            format_bytes(existing_bytes),
            format_bytes(allowed_growth),
        )
        return max_file_bytes

    def _prepare_pressure_file(self, conditions: List[Condition]) -> None:
        target_bytes = max(
            (
                condition.planned_size_bytes
                for condition in conditions
                if condition.pressure_mode in {"file_seq", "mmap_random"}
            ),
            default=0,
        )
        if target_bytes <= 0:
            return

        path = self.config.paths.pressure_data_file
        current_size = path.stat().st_size if path.exists() else 0
        if current_size >= target_bytes:
            LOGGER.info("Reusing pressure data file %s (%s)", path, format_bytes(current_size))
            return

        LOGGER.info(
            "Extending pressure data file %s from %s to %s",
            path,
            format_bytes(current_size),
            format_bytes(target_bytes),
        )

        chunk_size = self.config.pressure.file_fill_chunk_bytes
        pattern = bytes(range(256))
        chunk = (pattern * ((chunk_size // len(pattern)) + 1))[:chunk_size]

        with path.open("ab") as handle:
            remaining = target_bytes - current_size
            while remaining > 0:
                write_size = min(chunk_size, remaining)
                handle.write(chunk[:write_size])
                remaining -= write_size
            handle.flush()
            os.fsync(handle.fileno())

    def _validate_ollama(self) -> None:
        warmup = self.client.warmup(self.config.experiment.prompt)
        if not warmup.success:
            raise RuntimeError(
                "Ollama warmup failed. Ensure Ollama is running locally and the configured model is available. "
                f"Last error: {warmup.error}"
            )
        LOGGER.info("Warmup completed in %.2f ms", warmup.latency_ms)

    def _run_condition(self, condition: Condition) -> None:
        LOGGER.info(
            "Running condition=%s trial=%s requested=%s planned=%s",
            condition.pressure_mode,
            condition.trial_id,
            format_bytes(condition.requested_size_bytes),
            format_bytes(condition.planned_size_bytes),
        )

        if condition.pressure_mode != "none" and condition.planned_size_bytes <= 0:
            LOGGER.warning(
                "Skipping condition %s because no safe backing size is available.",
                condition.condition_name,
            )
            append_csv_row(
                self.config.paths.system_csv,
                SYSTEM_FIELDNAMES,
                {
                    "run_id": condition.run_id,
                    "status": "skipped",
                    "error": "Planned pressure size was zero after safety or disk capping.",
                    "started_at_utc": utc_now_iso(),
                    "ended_at_utc": utc_now_iso(),
                    "pilot_mode": self.pilot,
                    "condition_name": self._condition_name(
                        condition.pressure_mode,
                        condition.requested_fraction,
                        0,
                    ),
                    "pressure_mode": condition.pressure_mode,
                    "requested_fraction_of_ram": condition.requested_fraction,
                    "actual_fraction_of_ram": 0.0,
                    "requested_size_bytes": condition.requested_size_bytes,
                    "actual_size_bytes": 0,
                    "trial_id": condition.trial_id,
                    "num_requests": self.config.experiment.active_num_requests(self.pilot),
                    "successful_requests": 0,
                    "error_requests": 0,
                    "stabilization_seconds": 0.0,
                    "wall_time_s": 0.0,
                    "inference_batch_time_s": 0.0,
                    "pressure_worker_pid": None,
                    "size_capped": True,
                    "host_name": hostname(),
                    "platform_system": platform.system(),
                    "platform_release": platform.release(),
                    "python_version": sys.version.split()[0],
                    "model_name": self.config.ollama.model,
                    "prompt_id": self.config.experiment.prompt_id,
                    "page_fault_support": page_fault_measurement_note(),
                },
            )
            return

        started_at = utc_now_iso()
        run_start = time.perf_counter()
        pressure_handle: Optional[PressureHandle] = None
        actual_size_bytes = condition.planned_size_bytes
        effective_condition_name = condition.condition_name
        status = "completed"
        error_message: Optional[str] = None
        successful_requests = 0
        error_requests = 0
        inference_batch_time_s = 0.0
        interrupted = False

        before_snapshot = capture_snapshot()
        during_snapshot = before_snapshot

        try:
            pressure_handle = self.pressure_manager.start(
                condition.pressure_mode,
                condition.planned_size_bytes,
                self.config.paths.pressure_data_file,
                self.config.pressure.file_chunk_size_bytes,
            )
            if pressure_handle is not None:
                actual_size_bytes = pressure_handle.actual_size_bytes
                effective_condition_name = self._condition_name(
                    condition.pressure_mode,
                    condition.requested_fraction,
                    actual_size_bytes,
                )
                time.sleep(self.config.experiment.stabilization_seconds)

            batch_start = time.perf_counter()
            for request_index in range(self.config.experiment.active_num_requests(self.pilot)):
                result = self.client.generate(
                    self.config.experiment.prompt,
                    max_tokens=self.config.ollama.max_tokens,
                    temperature=self.config.ollama.temperature,
                )

                if result.success:
                    successful_requests += 1
                    request_status = "ok"
                else:
                    error_requests += 1
                    request_status = "error"
                    status = "completed_with_errors"

                append_csv_row(
                    self.config.paths.inference_csv,
                    INFERENCE_FIELDNAMES,
                    {
                        "run_id": condition.run_id,
                        "status": request_status,
                        "error": result.error,
                        "timestamp_utc": result.timestamp_utc,
                        "pilot_mode": self.pilot,
                        "condition_name": effective_condition_name,
                        "pressure_mode": condition.pressure_mode,
                        "requested_fraction_of_ram": condition.requested_fraction,
                        "actual_fraction_of_ram": (
                            actual_size_bytes / self.total_memory_bytes if self.total_memory_bytes else 0.0
                        ),
                        "requested_size_bytes": condition.requested_size_bytes,
                        "actual_size_bytes": actual_size_bytes,
                        "trial_id": condition.trial_id,
                        "request_index": request_index,
                        "model_name": result.model_name,
                        "prompt_id": self.config.experiment.prompt_id,
                        "max_tokens": self.config.ollama.max_tokens,
                        "temperature": self.config.ollama.temperature,
                        "latency_ms": result.latency_ms,
                        "response_chars": result.response_chars,
                        "response_digest": result.response_digest,
                        "eval_count": result.eval_count,
                        "eval_duration_ns": result.eval_duration_ns,
                        "prompt_eval_count": result.prompt_eval_count,
                        "prompt_eval_duration_ns": result.prompt_eval_duration_ns,
                        "total_duration_ns": result.total_duration_ns,
                        "load_duration_ns": result.load_duration_ns,
                        "tokens_per_second": result.tokens_per_second,
                    },
                )

            inference_batch_time_s = time.perf_counter() - batch_start
            tracked_pids = [pressure_handle.pid] if pressure_handle is not None else None
            during_snapshot = capture_snapshot(extra_pids=tracked_pids)
        except KeyboardInterrupt:
            status = "interrupted"
            error_message = "Interrupted by user."
            interrupted = True
        except Exception as exc:
            status = "failed"
            error_message = str(exc)
            LOGGER.exception("Condition failed: %s", exc)
        finally:
            self.pressure_manager.stop(pressure_handle)

        ended_at = utc_now_iso()
        after_snapshot = capture_snapshot()
        wall_time_s = time.perf_counter() - run_start

        if pressure_handle is None and condition.pressure_mode == "none":
            during_snapshot = after_snapshot

        system_row = {
            "run_id": condition.run_id,
            "status": status,
            "error": error_message,
            "started_at_utc": started_at,
            "ended_at_utc": ended_at,
            "pilot_mode": self.pilot,
            "condition_name": effective_condition_name,
            "pressure_mode": condition.pressure_mode,
            "requested_fraction_of_ram": condition.requested_fraction,
            "actual_fraction_of_ram": (
                actual_size_bytes / self.total_memory_bytes if self.total_memory_bytes else 0.0
            ),
            "requested_size_bytes": condition.requested_size_bytes,
            "actual_size_bytes": actual_size_bytes,
            "trial_id": condition.trial_id,
            "num_requests": self.config.experiment.active_num_requests(self.pilot),
            "successful_requests": successful_requests,
            "error_requests": error_requests,
            "stabilization_seconds": (
                self.config.experiment.stabilization_seconds if condition.pressure_mode != "none" else 0.0
            ),
            "wall_time_s": wall_time_s,
            "inference_batch_time_s": inference_batch_time_s,
            "pressure_worker_pid": pressure_handle.pid if pressure_handle is not None else None,
            "size_capped": actual_size_bytes < condition.requested_size_bytes,
            "host_name": hostname(),
            "platform_system": platform.system(),
            "platform_release": platform.release(),
            "python_version": sys.version.split()[0],
            "model_name": self.config.ollama.model,
            "prompt_id": self.config.experiment.prompt_id,
            "page_fault_support": page_fault_measurement_note(),
        }
        system_row.update(build_counter_row(before_snapshot, during_snapshot, after_snapshot))
        append_csv_row(self.config.paths.system_csv, SYSTEM_FIELDNAMES, system_row)

        LOGGER.info(
            "Completed run_id=%s status=%s successes=%s errors=%s actual=%s",
            condition.run_id,
            status,
            successful_requests,
            error_requests,
            format_bytes(actual_size_bytes),
        )

        if interrupted:
            raise KeyboardInterrupt()
