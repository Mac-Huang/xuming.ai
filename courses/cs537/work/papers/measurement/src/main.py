from __future__ import annotations

import argparse
import logging
from pathlib import Path

from analysis import generate_analysis
from config import load_config
from runner import ExperimentRunner
from utils import configure_logging, project_root


LOGGER = logging.getLogger(__name__)


def parse_args() -> argparse.Namespace:
    root = project_root()
    parser = argparse.ArgumentParser(
        description="Measure how OS memory and filesystem pressure affect local Ollama inference latency."
    )
    parser.add_argument(
        "--config",
        type=Path,
        default=root / "config" / "default.yaml",
        help="Path to the YAML configuration file.",
    )
    parser.add_argument("--pilot", action="store_true", help="Run a smaller, faster pilot experiment.")
    parser.add_argument("--force", action="store_true", help="Re-run conditions even if they already completed.")
    parser.add_argument("--model", type=str, default=None, help="Override the configured Ollama model name.")
    parser.add_argument("--host", type=str, default=None, help="Override the configured Ollama host.")
    parser.add_argument("--port", type=int, default=None, help="Override the configured Ollama port.")
    parser.add_argument(
        "--modes",
        type=str,
        default=None,
        help="Comma-separated pressure modes to run, for example 'file_seq' or 'none,file_seq'.",
    )
    parser.add_argument(
        "--fractions",
        type=str,
        default=None,
        help="Comma-separated RAM fractions for non-baseline modes, for example '0.10,0.20,0.30'.",
    )
    return parser.parse_args()


def _parse_csv_list(value: str | None) -> list[str] | None:
    if not value:
        return None
    return [item.strip() for item in value.split(",") if item.strip()]


def _parse_float_csv(value: str | None) -> list[float] | None:
    items = _parse_csv_list(value)
    if items is None:
        return None
    return [float(item) for item in items]


def main() -> int:
    args = parse_args()
    config = load_config(
        config_path=args.config,
        model_override=args.model,
        host_override=args.host,
        port_override=args.port,
    )
    log_path = configure_logging(config.paths.logs_dir)
    LOGGER.info("Logging to %s", log_path)

    selected_modes = _parse_csv_list(args.modes)
    selected_fractions = _parse_float_csv(args.fractions)

    runner = ExperimentRunner(
        config,
        pilot=args.pilot,
        force=args.force,
        modes_override=selected_modes,
        fractions_override=selected_fractions,
    )
    run_context = {
        "pilot_mode": args.pilot,
        "model_name": config.ollama.model,
        "total_memory_bytes": 0,
        "page_fault_support": "No runs executed.",
        "selected_modes": selected_modes,
        "selected_requested_fractions": selected_fractions,
    }

    try:
        run_context = runner.run()
    except KeyboardInterrupt:
        LOGGER.warning("Interrupted by user. Generating analysis from partial results.")
    finally:
        generate_analysis(config, run_context)

    LOGGER.info("Benchmark finished. See %s for the summary report.", config.paths.summary_md)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
