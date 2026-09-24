from __future__ import annotations

import logging
import multiprocessing as mp
import queue
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

from pressure_anon import run_anon_worker
from pressure_file_seq import run_file_seq_worker
from pressure_mmap_random import run_mmap_random_worker


LOGGER = logging.getLogger(__name__)


@dataclass
class PressureHandle:
    mode: str
    requested_size_bytes: int
    actual_size_bytes: int
    process: mp.Process
    stop_event: object
    pid: int


class PressureManager:
    def __init__(self, startup_timeout_s: float, shutdown_timeout_s: float) -> None:
        self.startup_timeout_s = startup_timeout_s
        self.shutdown_timeout_s = shutdown_timeout_s
        self.context = mp.get_context("spawn")

    def start(
        self,
        mode: str,
        requested_size_bytes: int,
        data_file: Path,
        file_chunk_size_bytes: int,
    ) -> Optional[PressureHandle]:
        if mode == "none":
            return None

        stop_event = self.context.Event()
        status_queue = self.context.Queue()

        if mode == "file_seq":
            args = (stop_event, status_queue, str(data_file), requested_size_bytes, file_chunk_size_bytes)
            target = run_file_seq_worker
        elif mode == "mmap_random":
            args = (stop_event, status_queue, str(data_file), requested_size_bytes)
            target = run_mmap_random_worker
        elif mode == "anon":
            args = (stop_event, status_queue, requested_size_bytes)
            target = run_anon_worker
        else:
            raise ValueError(f"Unsupported pressure mode: {mode}")

        process = self.context.Process(target=target, args=args, daemon=True)
        process.start()

        startup_timeout = self.startup_timeout_s
        if mode == "anon":
            startup_timeout = max(startup_timeout, 180.0)

        try:
            status = status_queue.get(timeout=startup_timeout)
        except queue.Empty as exc:
            self._force_stop_process(process, stop_event)
            raise RuntimeError(f"Pressure worker startup timed out for mode={mode}") from exc

        if status.get("status") != "started":
            self._force_stop_process(process, stop_event)
            error = status.get("error", "unknown pressure worker startup error")
            raise RuntimeError(f"Pressure worker failed for mode={mode}: {error}")

        actual_size = int(status.get("actual_size_bytes", requested_size_bytes))
        LOGGER.info(
            "Started pressure worker mode=%s pid=%s requested=%s actual=%s",
            mode,
            process.pid,
            requested_size_bytes,
            actual_size,
        )
        return PressureHandle(
            mode=mode,
            requested_size_bytes=requested_size_bytes,
            actual_size_bytes=actual_size,
            process=process,
            stop_event=stop_event,
            pid=int(process.pid or -1),
        )

    def stop(self, handle: Optional[PressureHandle]) -> None:
        if handle is None:
            return
        self._force_stop_process(handle.process, handle.stop_event)

    def _force_stop_process(self, process: mp.Process, stop_event: object) -> None:
        if not process.is_alive():
            process.join(timeout=0.1)
            return

        stop_event.set()
        process.join(timeout=self.shutdown_timeout_s)
        if process.is_alive():
            LOGGER.warning("Pressure worker pid=%s did not stop cleanly; terminating", process.pid)
            process.terminate()
            process.join(timeout=5.0)
        if process.is_alive():
            LOGGER.warning("Pressure worker pid=%s still alive after terminate; killing", process.pid)
            process.kill()
            process.join(timeout=5.0)
