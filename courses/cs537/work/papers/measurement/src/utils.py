from __future__ import annotations

import csv
import logging
import socket
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, Iterable, Set


def project_root() -> Path:
    return Path(__file__).resolve().parent.parent


def ensure_directory(path: Path) -> Path:
    path.mkdir(parents=True, exist_ok=True)
    return path


def ensure_project_directories(root: Path) -> Dict[str, Path]:
    data_dir = ensure_directory(root / "data")
    results_dir = ensure_directory(root / "results")
    raw_dir = ensure_directory(results_dir / "raw")
    plots_dir = ensure_directory(results_dir / "plots")
    logs_dir = ensure_directory(results_dir / "logs")
    return {
        "root": root,
        "data_dir": data_dir,
        "results_dir": results_dir,
        "raw_dir": raw_dir,
        "plots_dir": plots_dir,
        "logs_dir": logs_dir,
        "pressure_data_file": data_dir / "pressure_data.bin",
    }


def configure_logging(log_dir: Path) -> Path:
    ensure_directory(log_dir)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_path = log_dir / f"run_{timestamp}.log"

    logger = logging.getLogger()
    logger.handlers.clear()
    logger.setLevel(logging.INFO)

    formatter = logging.Formatter(
        fmt="%(asctime)s | %(levelname)s | %(name)s | %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )

    file_handler = logging.FileHandler(log_path, encoding="utf-8")
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    stream_handler = logging.StreamHandler(sys.stdout)
    stream_handler.setFormatter(formatter)
    logger.addHandler(stream_handler)

    return log_path


def utc_now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def append_csv_row(path: Path, fieldnames: Iterable[str], row: Dict[str, Any]) -> None:
    ensure_directory(path.parent)
    file_exists = path.exists()
    with path.open("a", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(fieldnames), extrasaction="ignore")
        if not file_exists:
            writer.writeheader()
        writer.writerow(row)


def read_completed_run_ids(path: Path) -> Set[str]:
    if not path.exists():
        return set()

    completed: Set[str] = set()
    with path.open("r", newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        for row in reader:
            run_id = row.get("run_id")
            status = (row.get("status") or "").strip().lower()
            if run_id and status.startswith("completed"):
                completed.add(run_id)
    return completed


def hostname() -> str:
    return socket.gethostname()


def bytes_to_gib(value: int | float | None) -> float | None:
    if value is None:
        return None
    return float(value) / float(1024**3)


def format_bytes(value: int | float | None) -> str:
    if value is None:
        return "n/a"

    units = ["B", "KiB", "MiB", "GiB", "TiB"]
    scaled = float(value)
    unit = units[0]
    for unit in units:
        if abs(scaled) < 1024.0 or unit == units[-1]:
            break
        scaled /= 1024.0
    return f"{scaled:.2f} {unit}"


def round_down_to(value: int, alignment: int) -> int:
    if alignment <= 0:
        return value
    return value - (value % alignment)


def stable_run_id(
    pilot: bool,
    pressure_mode: str,
    requested_fraction: float,
    actual_size_bytes: int,
    trial_id: int,
) -> str:
    return (
        f"pilot={int(pilot)}|mode={pressure_mode}|requested={requested_fraction:.4f}"
        f"|actual_bytes={actual_size_bytes}|trial={trial_id}"
    )
