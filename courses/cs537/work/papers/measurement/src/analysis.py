from __future__ import annotations

import logging
from pathlib import Path
from typing import Callable, Dict, Optional

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

from config import AppConfig
from utils import format_bytes


LOGGER = logging.getLogger(__name__)

MODE_ORDER = {"none": 0, "file_seq": 1, "mmap_random": 2, "anon": 3}
MODE_DISPLAY = {
    "none": "No Pressure",
    "file_seq": "Sequential File Scan",
    "mmap_random": "Random mmap Touches",
    "anon": "Anonymous Memory",
}
MODE_COLORS = {
    "none": "#4a5568",
    "file_seq": "#1f77b4",
    "mmap_random": "#d97706",
    "anon": "#2f855a",
}


def _filter_current_scope(df: pd.DataFrame, run_context: Dict[str, object]) -> pd.DataFrame:
    filtered = df.copy()
    if "pilot_mode" in filtered.columns and run_context.get("pilot_mode") is not None:
        filtered = filtered[filtered["pilot_mode"] == bool(run_context["pilot_mode"])]
    if "model_name" in filtered.columns and run_context.get("model_name"):
        filtered = filtered[filtered["model_name"] == run_context["model_name"]]
    selected_modes = run_context.get("selected_modes")
    if selected_modes and "pressure_mode" in filtered.columns:
        filtered = filtered[filtered["pressure_mode"].isin(selected_modes)]
    selected_fractions = run_context.get("selected_requested_fractions")
    if selected_fractions and "requested_fraction_of_ram" in filtered.columns:
        rounded_targets = {round(float(value), 4) for value in selected_fractions}
        filtered = filtered[
            filtered["requested_fraction_of_ram"].apply(
                lambda value: round(float(value), 4) in rounded_targets if pd.notna(value) else False
            )
            | (filtered["pressure_mode"] == "none")
        ]
    return filtered


def _dedupe_latest_system_rows(df: pd.DataFrame) -> pd.DataFrame:
    if df.empty or "run_id" not in df.columns:
        return df
    return df.reset_index(drop=False).drop_duplicates(subset=["run_id"], keep="last")


def _dedupe_latest_inference_rows(df: pd.DataFrame) -> pd.DataFrame:
    required = {"run_id", "request_index"}
    if df.empty or not required.issubset(df.columns):
        return df
    return df.reset_index(drop=False).drop_duplicates(
        subset=["run_id", "request_index"],
        keep="last",
    )


def _sort_frame(df: pd.DataFrame) -> pd.DataFrame:
    return df.sort_values(
        by=["pressure_mode", "requested_fraction_of_ram", "actual_fraction_of_ram"],
        key=lambda column: column.map(MODE_ORDER) if column.name == "pressure_mode" else column,
    )


def _aggregate_latency(successful: pd.DataFrame) -> pd.DataFrame:
    latency_table = (
        successful.groupby("condition_name")
        .agg(
            requests=("latency_ms", "count"),
            median_latency_ms=("latency_ms", "median"),
            p95_latency_ms=("latency_ms", lambda values: np.quantile(values, 0.95)),
            pressure_mode=("pressure_mode", "first"),
            requested_fraction_of_ram=("requested_fraction_of_ram", "first"),
            actual_fraction_of_ram=("actual_fraction_of_ram", "first"),
        )
        .reset_index()
    )
    return _sort_frame(latency_table)


def _aggregate_system(system_df: pd.DataFrame) -> pd.DataFrame:
    group_columns = {
        "pressure_mode": ("pressure_mode", "first"),
        "requested_fraction_of_ram": ("requested_fraction_of_ram", "first"),
        "actual_fraction_of_ram": ("actual_fraction_of_ram", "first"),
    }
    numeric_columns = [
        column
        for column in system_df.columns
        if column.endswith("_delta") and pd.api.types.is_numeric_dtype(system_df[column])
    ]
    for column in numeric_columns:
        group_columns[column] = (column, "median")

    summary = system_df.groupby("condition_name").agg(**group_columns).reset_index()
    return _sort_frame(summary)


def _style_axes(ax: plt.Axes) -> None:
    ax.set_facecolor("#fffdf8")
    ax.grid(axis="y", linestyle="--", linewidth=0.8, alpha=0.35, color="#7f8c8d")
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.spines["left"].set_color("#a0aec0")
    ax.spines["bottom"].set_color("#a0aec0")


def _apply_figure_style(fig: plt.Figure, title: str, subtitle: str) -> None:
    fig.patch.set_facecolor("#f7f3ea")
    fig.suptitle(title, fontsize=16, fontweight="bold", x=0.07, y=0.98, ha="left")
    fig.text(0.07, 0.94, subtitle, fontsize=10, color="#4a5568", ha="left")


def _format_fraction_ticks(ax: plt.Axes, values: list[float]) -> None:
    unique_values = sorted(set(round(value, 2) for value in values))
    ax.set_xticks(unique_values)
    ax.set_xticklabels([f"{value:.2f}x" for value in unique_values])


def _annotate_capped_points(ax: plt.Axes, frame: pd.DataFrame, y_column: str) -> None:
    for _, row in frame.iterrows():
        requested = float(row["requested_fraction_of_ram"])
        actual = float(row["actual_fraction_of_ram"])
        if abs(requested - actual) < 0.01:
            continue
        ax.annotate(
            f"used {actual:.2f}x",
            xy=(requested, row[y_column]),
            xytext=(0, 10),
            textcoords="offset points",
            ha="center",
            fontsize=8,
            color="#4a5568",
        )


def _plot_file_seq_presentation(
    latency_table: pd.DataFrame,
    system_summary: pd.DataFrame,
    output_path: Path,
) -> None:
    file_seq_latency = latency_table[latency_table["pressure_mode"] == "file_seq"].copy()
    baseline_latency = latency_table[latency_table["pressure_mode"] == "none"]
    if file_seq_latency.empty:
        return

    baseline_median = (
        float(baseline_latency["median_latency_ms"].iloc[0]) if not baseline_latency.empty else None
    )
    baseline_p95 = float(baseline_latency["p95_latency_ms"].iloc[0]) if not baseline_latency.empty else None

    file_seq_system = system_summary[system_summary["pressure_mode"] == "file_seq"].copy()
    baseline_system = system_summary[system_summary["pressure_mode"] == "none"]
    baseline_faults = (
        float(baseline_system["managed_page_faults_total_delta"].iloc[0])
        if not baseline_system.empty and "managed_page_faults_total_delta" in baseline_system.columns
        else None
    )

    x = file_seq_latency["requested_fraction_of_ram"].to_numpy()

    fig, axes = plt.subplots(2, 1, figsize=(10.5, 7.0), sharex=True)
    fig.patch.set_facecolor("white")

    for ax in axes:
        ax.set_facecolor("white")
        ax.grid(axis="y", linestyle="--", linewidth=0.8, alpha=0.3)
        ax.spines["top"].set_visible(False)
        ax.spines["right"].set_visible(False)

    axes[0].plot(
        x,
        file_seq_latency["median_latency_ms"],
        color="#1f77b4",
        marker="o",
        linewidth=2.2,
        label="Median latency",
    )
    axes[0].plot(
        x,
        file_seq_latency["p95_latency_ms"],
        color="#d97706",
        marker="s",
        linewidth=2.0,
        label="P95 latency",
    )
    if baseline_median is not None:
        axes[0].axhline(baseline_median, color="#4a5568", linestyle="--", linewidth=1.4, label="Baseline median")
    if baseline_p95 is not None:
        axes[0].axhline(baseline_p95, color="#7c3aed", linestyle=":", linewidth=1.4, label="Baseline p95")
    axes[0].set_ylim(bottom=0)
    axes[0].set_ylabel("Latency (ms)")
    axes[0].set_title("file_seq Inference Latency", fontsize=13, pad=10)
    axes[0].legend(frameon=False, ncol=2, fontsize=9)
    if baseline_median is not None:
        peak_index = file_seq_latency["median_latency_ms"].idxmax()
        peak_row = file_seq_latency.loc[peak_index]
        slowdown = (peak_row["median_latency_ms"] - baseline_median) / baseline_median * 100.0
        axes[0].annotate(
            f"{slowdown:.1f}% above baseline",
            xy=(peak_row["requested_fraction_of_ram"], peak_row["median_latency_ms"]),
            xytext=(-16, 14),
            textcoords="offset points",
            fontsize=9,
            color="#1f4e79",
            bbox={"boxstyle": "round,pad=0.2", "fc": "#edf4ff", "ec": "#1f77b4", "alpha": 0.9},
        )

    if not file_seq_system.empty and "managed_page_faults_total_delta" in file_seq_system.columns:
        axes[1].plot(
            x,
            file_seq_system["managed_page_faults_total_delta"],
            color="#2f855a",
            marker="o",
            linewidth=2.2,
            label="Total page faults",
        )
        if baseline_faults is not None:
            axes[1].axhline(
                baseline_faults,
                color="#4a5568",
                linestyle="--",
                linewidth=1.4,
                label="Baseline faults",
            )
        axes[1].legend(frameon=False, fontsize=9)

    axes[1].set_title("file_seq Total Page Faults", fontsize=13, pad=10)
    axes[1].set_ylabel("Page Fault Delta")
    axes[1].set_xlabel("Requested Pressure Size (% of RAM)")
    axes[1].set_xticks(x)
    axes[1].set_xticklabels([f"{int(round(value * 100))}%" for value in x])

    fig.text(0.08, 0.975, "Sequential File Pressure vs Ollama Latency", fontsize=15, fontweight="bold", ha="left")
    fig.text(
        0.08,
        0.947,
        "Windows page-fault values are total process fault deltas; no minor/major split is available.",
        fontsize=9,
        color="#4a5568",
        ha="left",
    )
    fig.tight_layout(rect=(0.03, 0.04, 0.98, 0.91))
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def _write_file_seq_observation_report(
    report_path: Path,
    latency_table: pd.DataFrame,
    system_summary: pd.DataFrame,
    run_context: Dict[str, object],
) -> None:
    file_seq_latency = latency_table[latency_table["pressure_mode"] == "file_seq"].copy()
    baseline_latency = latency_table[latency_table["pressure_mode"] == "none"]
    file_seq_system = system_summary[system_summary["pressure_mode"] == "file_seq"].copy()
    baseline_system = system_summary[system_summary["pressure_mode"] == "none"]
    if file_seq_latency.empty or baseline_latency.empty:
        return

    baseline_median = float(baseline_latency["median_latency_ms"].iloc[0])
    baseline_p95 = float(baseline_latency["p95_latency_ms"].iloc[0])
    worst = file_seq_latency.sort_values("median_latency_ms", ascending=False).iloc[0]
    first = file_seq_latency.sort_values("requested_fraction_of_ram").iloc[0]
    near_ram = file_seq_latency[file_seq_latency["requested_fraction_of_ram"] == 1.0]
    near_ram_row = near_ram.iloc[0] if not near_ram.empty else None

    baseline_faults = (
        float(baseline_system["managed_page_faults_total_delta"].iloc[0])
        if not baseline_system.empty and "managed_page_faults_total_delta" in baseline_system.columns
        else None
    )
    fault_band_low = None
    fault_band_high = None
    if "managed_page_faults_total_delta" in file_seq_system.columns and not file_seq_system.empty:
        fault_band_low = float(file_seq_system["managed_page_faults_total_delta"].min())
        fault_band_high = float(file_seq_system["managed_page_faults_total_delta"].max())

    lines = [
        "# file_seq Observation Report",
        "",
        f"- Model: `{run_context.get('model_name')}`",
        f"- Total RAM: `{format_bytes(int(run_context.get('total_memory_bytes', 0)))}`",
        "- Scope: baseline plus sequential file-scanning pressure only",
        "- Each condition used 3 trials and 20 inference requests per trial",
        "",
        "## Main observations",
        f"- Baseline median latency was `{baseline_median:.2f} ms` and baseline p95 was `{baseline_p95:.2f} ms`.",
        (
            f"- The first added file_seq load at `{first['requested_fraction_of_ram']:.2f}x` RAM "
            f"already raised median latency to `{first['median_latency_ms']:.2f} ms`, "
            f"about `{((first['median_latency_ms'] - baseline_median) / baseline_median) * 100:.1f}%` above baseline."
        ),
        (
            f"- The highest median latency occurred at `{worst['requested_fraction_of_ram']:.2f}x` RAM "
            f"with `{worst['median_latency_ms']:.2f} ms`, "
            f"`{((worst['median_latency_ms'] - baseline_median) / baseline_median) * 100:.1f}%` above baseline."
        ),
    ]

    if near_ram_row is not None:
        lines.append(
            f"- At `1.00x` RAM pressure, median latency was `{near_ram_row['median_latency_ms']:.2f} ms` and "
            f"p95 latency was `{near_ram_row['p95_latency_ms']:.2f} ms`."
        )

    lines.extend(
        [
            "- The latency trend was mostly monotonic: once file_seq pressure started, latency rose quickly and then stayed elevated as the scanned file size increased.",
            "- The median slowdown was much clearer than any page-fault trend.",
        ]
    )

    lines.extend(["", "## Page-fault observations"])
    if baseline_faults is not None:
        lines.append(f"- Baseline total page-fault delta was only about `{baseline_faults:.0f}`.")
    if fault_band_low is not None and fault_band_high is not None:
        lines.append(
            f"- Under file_seq, total page-fault deltas stayed in a narrow band of about `{fault_band_low:.0f}` to `{fault_band_high:.0f}`."
        )
    lines.extend(
        [
            "- That means page faults increased sharply when file_seq was introduced, but did not continue rising much as the file_seq percentage increased.",
            "- On this Windows machine, the dominant growth with heavier file_seq was sustained file-backed read traffic and page-cache pressure, not an escalating fault storm.",
        ]
    )

    if "system_disk_read_bytes_delta" in file_seq_system.columns and not file_seq_system.empty:
        low_read = float(file_seq_system["system_disk_read_bytes_delta"].min())
        high_read = float(file_seq_system["system_disk_read_bytes_delta"].max())
        lines.extend(
            [
                "",
                "## Read-traffic observations",
                f"- System disk read deltas ranged from roughly `{format_bytes(low_read)}` to `{format_bytes(high_read)}` across file_seq conditions.",
                "- The larger file_seq conditions increasingly forced real storage reads instead of relying only on already-warm cached pages.",
            ]
        )

    lines.extend(
        [
            "",
            "## Interpretation",
            "- Heavier sequential file scanning kept the operating system busy streaming file-backed pages through the cache and storage stack.",
            "- That competition raised end-to-end Ollama latency even though the model compute itself may still be GPU-heavy.",
            "- The data supports a cache-and-I/O contention explanation more strongly than a page-fault-explosion explanation.",
        ]
    )

    report_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _plot_latency_progression(
    latency_table: pd.DataFrame,
    y_column: str,
    title: str,
    ylabel: str,
    output_path: Path,
) -> None:
    baseline_row = latency_table[latency_table["pressure_mode"] == "none"]
    baseline_value = baseline_row[y_column].iloc[0] if not baseline_row.empty else None

    fig, axes = plt.subplots(1, 3, figsize=(15.5, 5.8), sharey=True)
    _apply_figure_style(
        fig,
        title,
        "Panels show requested pressure size as a fraction of RAM. The dashed line is the no-pressure baseline.",
    )

    mode_order = ["file_seq", "mmap_random", "anon"]
    x_values = latency_table["requested_fraction_of_ram"].tolist()
    if baseline_value is not None:
        x_values.append(0.0)

    for ax, mode in zip(axes, mode_order):
        _style_axes(ax)
        mode_frame = latency_table[latency_table["pressure_mode"] == mode].copy()
        if not mode_frame.empty:
            ax.plot(
                mode_frame["requested_fraction_of_ram"],
                mode_frame[y_column],
                color=MODE_COLORS[mode],
                linewidth=2.5,
                marker="o",
                markersize=7,
                solid_capstyle="round",
            )
            ax.fill_between(
                mode_frame["requested_fraction_of_ram"],
                mode_frame[y_column],
                baseline_value if baseline_value is not None else mode_frame[y_column].min(),
                color=MODE_COLORS[mode],
                alpha=0.08,
            )
            _annotate_capped_points(ax, mode_frame, y_column)

        if baseline_value is not None:
            ax.axhline(
                baseline_value,
                color=MODE_COLORS["none"],
                linestyle="--",
                linewidth=1.6,
                alpha=0.9,
            )
            ax.text(
                0.03,
                baseline_value,
                " baseline",
                color=MODE_COLORS["none"],
                fontsize=9,
                va="bottom",
            )

        ax.set_title(MODE_DISPLAY[mode], fontsize=12, fontweight="bold", pad=10)
        ax.set_xlabel("Requested Pressure Size (x of RAM)")
        _format_fraction_ticks(ax, x_values)

    axes[0].set_ylabel(ylabel)
    fig.tight_layout(rect=(0.04, 0.06, 1, 0.90))
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def _plot_metric_grid(
    summary_df: pd.DataFrame,
    metric_specs: list[tuple[str, str, str, Optional[Callable[[pd.Series], pd.Series]], bool]],
    title: str,
    subtitle: str,
    output_path: Path,
) -> None:
    mode_order = ["file_seq", "mmap_random", "anon"]
    rows = len(metric_specs)
    fig, axes = plt.subplots(rows, len(mode_order), figsize=(15.5, 4.5 * rows), sharex="col")
    if rows == 1:
        axes = np.array([axes])

    _apply_figure_style(fig, title, subtitle)

    x_values = summary_df["requested_fraction_of_ram"].tolist()
    x_values.append(0.0)

    for row_index, (column, ylabel, panel_title, transform, use_log_scale) in enumerate(metric_specs):
        baseline_row = summary_df[summary_df["pressure_mode"] == "none"]
        baseline_value = None
        if not baseline_row.empty and column in baseline_row.columns:
            baseline_value = baseline_row[column].iloc[0]
            if transform is not None and baseline_value is not None:
                baseline_value = transform(pd.Series([baseline_value])).iloc[0]

        for col_index, mode in enumerate(mode_order):
            ax = axes[row_index, col_index]
            _style_axes(ax)
            mode_frame = summary_df[summary_df["pressure_mode"] == mode].copy()
            if transform is not None and not mode_frame.empty:
                mode_frame[column] = transform(mode_frame[column])

            if not mode_frame.empty and column in mode_frame.columns:
                ax.plot(
                    mode_frame["requested_fraction_of_ram"],
                    mode_frame[column],
                    color=MODE_COLORS[mode],
                    linewidth=2.4,
                    marker="o",
                    markersize=6,
                )
                _annotate_capped_points(ax, mode_frame, column)

            if baseline_value is not None and np.isfinite(baseline_value):
                ax.axhline(
                    baseline_value,
                    color=MODE_COLORS["none"],
                    linestyle="--",
                    linewidth=1.4,
                    alpha=0.9,
                )

            if use_log_scale:
                ax.set_yscale("log")

            if row_index == 0:
                ax.set_title(MODE_DISPLAY[mode], fontsize=12, fontweight="bold", pad=10)
            if col_index == 0:
                ax.set_ylabel(ylabel)
            if row_index == rows - 1:
                ax.set_xlabel("Requested Pressure Size (x of RAM)")
                _format_fraction_ticks(ax, x_values)

            if col_index == len(mode_order) - 1:
                ax.text(
                    1.02,
                    0.5,
                    panel_title,
                    transform=ax.transAxes,
                    rotation=270,
                    va="center",
                    fontsize=10,
                    color="#4a5568",
                )

    fig.tight_layout(rect=(0.04, 0.06, 0.97, 0.90))
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def generate_analysis(config: AppConfig, run_context: Dict[str, object]) -> Dict[str, Optional[Path]]:
    outputs: Dict[str, Optional[Path]] = {
        "latency_plot": None,
        "p95_plot": None,
        "faults_plot": None,
        "io_plot": None,
        "presentation_plot": None,
        "observation_report": None,
        "summary": None,
    }

    if not config.paths.inference_csv.exists() or not config.paths.system_csv.exists():
        LOGGER.warning("Skipping analysis because raw CSV outputs are incomplete.")
        return outputs

    inference_df = pd.read_csv(config.paths.inference_csv)
    system_df = pd.read_csv(config.paths.system_csv)
    inference_df = _dedupe_latest_inference_rows(_filter_current_scope(inference_df, run_context))
    system_df = _dedupe_latest_system_rows(_filter_current_scope(system_df, run_context))
    if inference_df.empty or system_df.empty:
        LOGGER.warning("Skipping analysis because raw CSV outputs are empty.")
        return outputs

    successful = inference_df[inference_df["status"] == "ok"].copy()
    if successful.empty:
        LOGGER.warning("Skipping plots because no successful inference rows were found.")
        _write_summary(config.paths.summary_md, inference_df, system_df, config, run_context, outputs)
        outputs["summary"] = config.paths.summary_md
        return outputs

    latency_table = _aggregate_latency(successful)
    system_summary = _aggregate_system(system_df)

    latency_plot = config.paths.plots_dir / "latency_by_condition.png"
    _plot_latency_progression(
        latency_table,
        "median_latency_ms",
        "Median Inference Latency by Pressure Mode",
        "Median Latency (ms)",
        latency_plot,
    )
    outputs["latency_plot"] = latency_plot

    p95_plot = config.paths.plots_dir / "p95_latency_by_condition.png"
    _plot_latency_progression(
        latency_table,
        "p95_latency_ms",
        "P95 Inference Latency by Pressure Mode",
        "P95 Latency (ms)",
        p95_plot,
    )
    outputs["p95_plot"] = p95_plot

    faults_specs = []
    if "managed_minor_faults_delta" in system_summary.columns and system_summary["managed_minor_faults_delta"].notna().any():
        faults_specs.append(
            ("managed_minor_faults_delta", "Minor Fault Delta", "Minor Faults", None, False)
        )
    if "managed_major_faults_delta" in system_summary.columns and system_summary["managed_major_faults_delta"].notna().any():
        faults_specs.append(
            ("managed_major_faults_delta", "Major Fault Delta", "Major Faults", None, False)
        )
    if "managed_page_faults_total_delta" in system_summary.columns and system_summary["managed_page_faults_total_delta"].notna().any():
        faults_specs.append(
            ("managed_page_faults_total_delta", "Total Page Fault Delta", "Total Page Faults", None, False)
        )

    if config.analysis.generate_faults_plot and faults_specs:
        faults_plot = config.paths.plots_dir / "faults_by_condition.png"
        _plot_metric_grid(
            system_summary,
            faults_specs,
            "Fault Activity by Pressure Mode",
            "Windows reports total page faults for managed processes; Linux may expose additional splits.",
            faults_plot,
        )
        outputs["faults_plot"] = faults_plot

    io_specs = []
    if "system_disk_read_bytes_delta" in system_summary.columns and system_summary["system_disk_read_bytes_delta"].notna().any():
        io_specs.append(
            (
                "system_disk_read_bytes_delta",
                "System Read Delta (GiB)",
                "System-wide read traffic",
                lambda series: series / float(1024**3),
                True,
            )
        )
    if "managed_io_read_bytes_delta" in system_summary.columns and system_summary["managed_io_read_bytes_delta"].notna().any():
        io_specs.append(
            (
                "managed_io_read_bytes_delta",
                "Managed Read Delta (GiB)",
                "Reads issued by benchmark and pressure workers",
                lambda series: series / float(1024**3),
                True,
            )
        )

    if config.analysis.generate_io_plot and io_specs:
        io_plot = config.paths.plots_dir / "io_by_condition.png"
        _plot_metric_grid(
            system_summary,
            io_specs,
            "Read Activity by Pressure Mode",
            "Read-byte panels use a log scale because sequential scans are orders of magnitude heavier than the baseline.",
            io_plot,
        )
        outputs["io_plot"] = io_plot

    selected_modes = run_context.get("selected_modes") or []
    if set(selected_modes).issubset({"none", "file_seq"}) and "file_seq" in selected_modes:
        presentation_plot = config.paths.plots_dir / "file_seq_presentation.png"
        _plot_file_seq_presentation(latency_table, system_summary, presentation_plot)
        outputs["presentation_plot"] = presentation_plot
        observation_report = config.paths.results_dir / "file_seq_observations.md"
        _write_file_seq_observation_report(observation_report, latency_table, system_summary, run_context)
        outputs["observation_report"] = observation_report

    _write_summary(config.paths.summary_md, inference_df, system_df, config, run_context, outputs)
    outputs["summary"] = config.paths.summary_md
    return outputs


def _write_summary(
    summary_path: Path,
    inference_df: pd.DataFrame,
    system_df: pd.DataFrame,
    config: AppConfig,
    run_context: Dict[str, object],
    outputs: Dict[str, Optional[Path]],
) -> None:
    successful = inference_df[inference_df["status"] == "ok"].copy()
    if successful.empty:
        summary_path.write_text(
            "# Benchmark Summary\n\nNo successful inference rows were available for analysis.\n",
            encoding="utf-8",
        )
        return

    latency_table = _aggregate_latency(successful)
    capped_runs = system_df[system_df["size_capped"] == True]
    error_runs = system_df[~system_df["status"].astype(str).str.startswith("completed")]

    observations = []
    baseline = latency_table[latency_table["pressure_mode"] == "none"]
    if not baseline.empty:
        baseline_median = baseline["median_latency_ms"].iloc[0]
        worst = latency_table.sort_values("median_latency_ms", ascending=False).iloc[0]
        observations.append(
            f"Baseline median latency was {baseline_median:.2f} ms; "
            f"the highest observed median latency was {worst['median_latency_ms']:.2f} ms "
            f"under `{worst['condition_name']}`."
        )
    if capped_runs.shape[0] > 0:
        observations.append(
            f"{capped_runs.shape[0]} run(s) used a reduced actual pressure size because of safety or disk caps."
        )
    if error_runs.shape[0] > 0:
        observations.append(
            f"{error_runs.shape[0]} run(s) finished with errors or interruption status; inspect `results/raw/system_runs.csv`."
        )

    lines = [
        "# Benchmark Summary",
        "",
        "## Environment",
        f"- Config file: `{config.config_path}`",
        f"- Pilot mode: `{run_context.get('pilot_mode')}`",
        f"- Model: `{run_context.get('model_name')}`",
        f"- Total RAM: `{format_bytes(int(run_context.get('total_memory_bytes', 0)))}`",
        f"- Page-fault support: {run_context.get('page_fault_support')}",
        "",
        "## Outputs",
        f"- Inference CSV: `{config.paths.inference_csv}`",
        f"- System CSV: `{config.paths.system_csv}`",
        f"- Latency plot: `{outputs.get('latency_plot')}`",
        f"- P95 plot: `{outputs.get('p95_plot')}`",
        f"- Faults plot: `{outputs.get('faults_plot')}`",
        f"- I/O plot: `{outputs.get('io_plot')}`",
        f"- Presentation plot: `{outputs.get('presentation_plot')}`",
        f"- Observation report: `{outputs.get('observation_report')}`",
        "",
        "## Latency Summary",
        "",
        "| Condition | Requests | Median Latency (ms) | P95 Latency (ms) | Requested RAM x | Actual RAM x |",
        "| --- | ---: | ---: | ---: | ---: | ---: |",
    ]

    for _, row in latency_table.iterrows():
        lines.append(
            f"| {row['condition_name']} | {int(row['requests'])} | {row['median_latency_ms']:.2f} | "
            f"{row['p95_latency_ms']:.2f} | {row['requested_fraction_of_ram']:.2f} | "
            f"{row['actual_fraction_of_ram']:.2f} |"
        )

    lines.extend(["", "## Observations"])
    if observations:
        for observation in observations:
            lines.append(f"- {observation}")
    else:
        lines.append("- No high-level observations were available.")

    lines.extend(
        [
            "- The study infers VM and filesystem behavior from externally observable latency, fault counters, and I/O counters.",
            "- On platforms without full fault breakdown support, detailed fault plots may be absent or partially null.",
        ]
    )

    summary_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
