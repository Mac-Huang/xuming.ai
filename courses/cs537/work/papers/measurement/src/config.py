from __future__ import annotations

import ast
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, List, Optional

from utils import ensure_project_directories, project_root


@dataclass(frozen=True)
class ExperimentSettings:
    prompt: str
    prompt_id: str
    pressure_fractions: List[float]
    pilot_pressure_fractions: List[float]
    num_requests_per_run: int
    pilot_num_requests_per_run: int
    trials: int
    pilot_trials: int
    stabilization_seconds: float

    def active_pressure_fractions(self, pilot: bool) -> List[float]:
        return self.pilot_pressure_fractions if pilot else self.pressure_fractions

    def active_num_requests(self, pilot: bool) -> int:
        return self.pilot_num_requests_per_run if pilot else self.num_requests_per_run

    def active_trials(self, pilot: bool) -> int:
        return self.pilot_trials if pilot else self.trials


@dataclass(frozen=True)
class OllamaSettings:
    host: str
    port: int
    model: str
    request_timeout_s: float
    max_tokens: int
    temperature: float

    @property
    def base_url(self) -> str:
        return f"http://{self.host}:{self.port}"


@dataclass(frozen=True)
class PressureSettings:
    file_chunk_size_mb: int
    file_fill_chunk_mb: int
    startup_timeout_s: float
    shutdown_timeout_s: float
    anon_safe_max_fraction_of_ram: float
    disk_free_utilization_limit: float

    @property
    def file_chunk_size_bytes(self) -> int:
        return self.file_chunk_size_mb * 1024 * 1024

    @property
    def file_fill_chunk_bytes(self) -> int:
        return self.file_fill_chunk_mb * 1024 * 1024


@dataclass(frozen=True)
class AnalysisSettings:
    generate_faults_plot: bool
    generate_io_plot: bool


@dataclass(frozen=True)
class PathsSettings:
    root: Path
    data_dir: Path
    results_dir: Path
    raw_dir: Path
    plots_dir: Path
    logs_dir: Path
    pressure_data_file: Path
    inference_csv: Path
    system_csv: Path
    summary_md: Path


@dataclass(frozen=True)
class AppConfig:
    experiment: ExperimentSettings
    ollama: OllamaSettings
    pressure: PressureSettings
    analysis: AnalysisSettings
    paths: PathsSettings
    config_path: Path


def _parse_scalar(raw_value: str) -> Any:
    lowered = raw_value.strip().lower()
    if lowered in {"true", "false"}:
        return lowered == "true"
    if lowered in {"null", "none", "~"}:
        return None

    try:
        return ast.literal_eval(raw_value)
    except (SyntaxError, ValueError):
        return raw_value.strip().strip('"').strip("'")


def load_simple_yaml(path: Path) -> Dict[str, Any]:
    root: Dict[str, Any] = {}
    stack: List[tuple[int, Dict[str, Any]]] = [(-1, root)]

    for lineno, raw_line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        line = raw_line.split("#", 1)[0].rstrip()
        if not line.strip():
            continue

        indent = len(line) - len(line.lstrip(" "))
        stripped = line.strip()
        if stripped.startswith("- "):
            raise ValueError(f"Unsupported YAML list syntax at {path}:{lineno}")

        if ":" not in stripped:
            raise ValueError(f"Invalid YAML line at {path}:{lineno}: {raw_line}")

        key, _, value = stripped.partition(":")
        while indent <= stack[-1][0]:
            stack.pop()

        parent = stack[-1][1]
        value = value.strip()
        if value == "":
            child: Dict[str, Any] = {}
            parent[key] = child
            stack.append((indent, child))
        else:
            parent[key] = _parse_scalar(value)

    return root


def load_config(
    config_path: Optional[Path] = None,
    model_override: Optional[str] = None,
    host_override: Optional[str] = None,
    port_override: Optional[int] = None,
) -> AppConfig:
    root = project_root()
    resolved_config_path = config_path or (root / "config" / "default.yaml")
    raw = load_simple_yaml(resolved_config_path)
    directories = ensure_project_directories(root)

    experiment_raw = raw["experiment"]
    ollama_raw = raw["ollama"]
    pressure_raw = raw["pressure"]
    analysis_raw = raw["analysis"]

    experiment = ExperimentSettings(
        prompt=str(experiment_raw["prompt"]),
        prompt_id=str(experiment_raw["prompt_id"]),
        pressure_fractions=[float(value) for value in experiment_raw["pressure_fractions"]],
        pilot_pressure_fractions=[
            float(value) for value in experiment_raw["pilot_pressure_fractions"]
        ],
        num_requests_per_run=int(experiment_raw["num_requests_per_run"]),
        pilot_num_requests_per_run=int(experiment_raw["pilot_num_requests_per_run"]),
        trials=int(experiment_raw["trials"]),
        pilot_trials=int(experiment_raw["pilot_trials"]),
        stabilization_seconds=float(experiment_raw["stabilization_seconds"]),
    )

    ollama = OllamaSettings(
        host=str(host_override or ollama_raw["host"]),
        port=int(port_override or ollama_raw["port"]),
        model=str(model_override or ollama_raw["model"]),
        request_timeout_s=float(ollama_raw["request_timeout_s"]),
        max_tokens=int(ollama_raw["max_tokens"]),
        temperature=float(ollama_raw["temperature"]),
    )

    pressure = PressureSettings(
        file_chunk_size_mb=int(pressure_raw["file_chunk_size_mb"]),
        file_fill_chunk_mb=int(pressure_raw["file_fill_chunk_mb"]),
        startup_timeout_s=float(pressure_raw["startup_timeout_s"]),
        shutdown_timeout_s=float(pressure_raw["shutdown_timeout_s"]),
        anon_safe_max_fraction_of_ram=float(pressure_raw["anon_safe_max_fraction_of_ram"]),
        disk_free_utilization_limit=float(pressure_raw["disk_free_utilization_limit"]),
    )

    analysis = AnalysisSettings(
        generate_faults_plot=bool(analysis_raw["generate_faults_plot"]),
        generate_io_plot=bool(analysis_raw["generate_io_plot"]),
    )

    paths = PathsSettings(
        root=directories["root"],
        data_dir=directories["data_dir"],
        results_dir=directories["results_dir"],
        raw_dir=directories["raw_dir"],
        plots_dir=directories["plots_dir"],
        logs_dir=directories["logs_dir"],
        pressure_data_file=directories["pressure_data_file"],
        inference_csv=directories["raw_dir"] / "inference_runs.csv",
        system_csv=directories["raw_dir"] / "system_runs.csv",
        summary_md=directories["results_dir"] / "summary.md",
    )

    return AppConfig(
        experiment=experiment,
        ollama=ollama,
        pressure=pressure,
        analysis=analysis,
        paths=paths,
        config_path=resolved_config_path,
    )
