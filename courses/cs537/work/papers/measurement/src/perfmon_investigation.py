"""
perfmon_investigation.py

Uses Windows typeperf (perfmon CLI) to monitor system counters while running
repeated Ollama inference requests. Correlates latency growth with memory,
paging, and disk I/O metrics collected at 1-second intervals.

Run from the project root:
    python src/perfmon_investigation.py
"""

from __future__ import annotations

import csv
import io
import json
import logging
import os
import subprocess
import sys
import tempfile
import threading
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import List, Optional

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import numpy as np
import requests

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

OLLAMA_URL = "http://127.0.0.1:11434/api/generate"
OLLAMA_MODEL = "qwen3:4b"
PROMPT = "Describe the concept of virtual memory in one sentence."
MAX_TOKENS = 64
NUM_REQUESTS = 30          # enough to reveal a trend if one exists
REQUEST_TIMEOUT_S = 60

RESULTS_DIR = Path(__file__).parent.parent / "results"
PERFMON_RAW_CSV = RESULTS_DIR / "raw" / "perfmon_counters.csv"
PERFMON_PLOT = RESULTS_DIR / "plots" / "perfmon_latency_investigation.png"

# Windows Performance Monitor counters to track
# typeperf uses backslash paths; we pick memory, paging, disk, and CPU.
COUNTERS = [
    r"\Memory\Available MBytes",
    r"\Memory\Pages/sec",
    r"\Memory\Page Faults/sec",
    r"\Memory\Cache Bytes",
    r"\PhysicalDisk(_Total)\Disk Read Bytes/sec",
    r"\PhysicalDisk(_Total)\Disk Write Bytes/sec",
    r"\PhysicalDisk(_Total)\% Disk Time",
    r"\Processor(_Total)\% Processor Time",
]

SAMPLE_INTERVAL_S = 1   # typeperf sample interval

logging.basicConfig(level=logging.INFO, format="%(asctime)s  %(levelname)s  %(message)s")
log = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Data containers
# ---------------------------------------------------------------------------

@dataclass
class InferenceRecord:
    index: int
    started_at: float        # wall-clock seconds since epoch
    latency_ms: float
    success: bool
    tokens_per_second: Optional[float] = None
    error: Optional[str] = None


@dataclass
class PerfmonState:
    """Mutable container shared between the monitor thread and main thread."""
    rows: List[dict] = field(default_factory=list)
    stop_event: threading.Event = field(default_factory=threading.Event)
    proc: Optional[subprocess.Popen] = None


# ---------------------------------------------------------------------------
# typeperf monitor thread
# ---------------------------------------------------------------------------

def _build_typeperf_command(counters: List[str], interval: int) -> List[str]:
    cmd = ["typeperf"] + counters + ["-si", str(interval), "-o", str(PERFMON_RAW_CSV), "-f", "CSV"]
    return cmd


def run_typeperf_thread(state: PerfmonState) -> None:
    """Spawn typeperf, read its CSV output, store rows in state.rows."""
    cmd = _build_typeperf_command(COUNTERS, SAMPLE_INTERVAL_S)
    log.info("Starting typeperf: %s", " ".join(cmd))
    # We write to a file and read back — typeperf on Windows appends rows to CSV.
    # We'll poll the file for new lines until stop_event is set.
    PERFMON_RAW_CSV.parent.mkdir(parents=True, exist_ok=True)
    if PERFMON_RAW_CSV.exists():
        PERFMON_RAW_CSV.unlink()

    try:
        proc = subprocess.Popen(
            cmd,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
            creationflags=subprocess.CREATE_NO_WINDOW if hasattr(subprocess, "CREATE_NO_WINDOW") else 0,
        )
        state.proc = proc
        # Wait until file appears
        deadline = time.monotonic() + 10
        while not PERFMON_RAW_CSV.exists() and time.monotonic() < deadline:
            time.sleep(0.2)

        header: Optional[List[str]] = None
        seen_lines = 0

        while not state.stop_event.is_set():
            if not PERFMON_RAW_CSV.exists():
                time.sleep(0.5)
                continue
            lines = PERFMON_RAW_CSV.read_text(encoding="utf-8", errors="replace").splitlines()
            for line in lines[seen_lines:]:
                line = line.strip()
                if not line:
                    continue
                try:
                    parsed = next(csv.reader([line]))
                except Exception:
                    continue
                if header is None:
                    header = parsed
                    continue
                if len(parsed) != len(header):
                    continue
                # First column is timestamp string, rest are counter values
                row: dict = {}
                ts_str = parsed[0].strip('"')
                try:
                    row["timestamp"] = time.mktime(time.strptime(ts_str, "%m/%d/%Y %H:%M:%S.%f"))
                except ValueError:
                    try:
                        row["timestamp"] = time.mktime(time.strptime(ts_str, "%m/%d/%Y %H:%M:%S"))
                    except ValueError:
                        row["timestamp"] = time.time()
                for h, v in zip(header[1:], parsed[1:]):
                    key = h.strip('"').strip()
                    try:
                        row[key] = float(v.strip('"').strip())
                    except ValueError:
                        row[key] = None
                state.rows.append(row)
                seen_lines += 1
            seen_lines = len(lines)
            time.sleep(0.3)

        proc.terminate()
        try:
            proc.wait(timeout=5)
        except subprocess.TimeoutExpired:
            proc.kill()
    except Exception as exc:
        log.error("typeperf thread error: %s", exc)


# ---------------------------------------------------------------------------
# Inference runner
# ---------------------------------------------------------------------------

def run_inference_requests(num_requests: int) -> List[InferenceRecord]:
    session = requests.Session()
    results: List[InferenceRecord] = []
    payload = {
        "model": OLLAMA_MODEL,
        "prompt": PROMPT,
        "stream": False,
        "options": {"temperature": 0.0, "num_predict": MAX_TOKENS},
    }

    # Warmup
    log.info("Warming up Ollama...")
    try:
        session.post(OLLAMA_URL, json=payload, timeout=REQUEST_TIMEOUT_S)
    except Exception:
        pass
    time.sleep(1)

    log.info("Running %d inference requests...", num_requests)
    for i in range(num_requests):
        t0 = time.perf_counter()
        started_at = time.time()
        try:
            resp = session.post(OLLAMA_URL, json=payload, timeout=REQUEST_TIMEOUT_S)
            latency_ms = (time.perf_counter() - t0) * 1000.0
            resp.raise_for_status()
            data = resp.json()
            ec = data.get("eval_count")
            ed = data.get("eval_duration")
            tps = float(ec) / (float(ed) / 1e9) if ec and ed else None
            rec = InferenceRecord(index=i, started_at=started_at,
                                  latency_ms=latency_ms, success=True,
                                  tokens_per_second=tps)
        except Exception as exc:
            latency_ms = (time.perf_counter() - t0) * 1000.0
            rec = InferenceRecord(index=i, started_at=started_at,
                                  latency_ms=latency_ms, success=False,
                                  error=str(exc))
        results.append(rec)
        status = f"{latency_ms:.0f} ms"
        if rec.tokens_per_second:
            status += f"  {rec.tokens_per_second:.1f} tok/s"
        log.info("  req %02d/%02d  %s", i + 1, num_requests, status)
    return results


# ---------------------------------------------------------------------------
# Visualization
# ---------------------------------------------------------------------------

def _smooth(values: List[float], window: int = 3) -> np.ndarray:
    arr = np.array(values, dtype=float)
    if len(arr) < window:
        return arr
    kernel = np.ones(window) / window
    return np.convolve(arr, kernel, mode="same")


def _find_counter(rows: List[dict], substring: str) -> List[Optional[float]]:
    """Return the time-series for the first counter key containing `substring`."""
    if not rows:
        return []
    key = next((k for k in rows[0].keys() if substring.lower() in k.lower()), None)
    if key is None:
        return [None] * len(rows)
    return [r.get(key) for r in rows]


def build_visualization(
    inference_records: List[InferenceRecord],
    perfmon_rows: List[dict],
) -> Path:
    PERFMON_PLOT.parent.mkdir(parents=True, exist_ok=True)

    # ---- align timestamps ----
    if not inference_records:
        raise RuntimeError("No inference records to plot.")

    t0 = inference_records[0].started_at  # wall-clock reference

    req_x = [r.started_at - t0 for r in inference_records]
    req_y = [r.latency_ms for r in inference_records]
    req_ok = [r.success for r in inference_records]

    pm_x: List[float] = []
    if perfmon_rows:
        pm_x = [r["timestamp"] - t0 for r in perfmon_rows]

    # ---- extract counter series ----
    avail_mb   = _find_counter(perfmon_rows, "Available MBytes")
    pages_sec  = _find_counter(perfmon_rows, "Pages/sec")
    faults_sec = _find_counter(perfmon_rows, "Page Faults/sec")
    disk_read  = _find_counter(perfmon_rows, "Disk Read Bytes/sec")
    disk_write = _find_counter(perfmon_rows, "Disk Write Bytes/sec")
    disk_pct   = _find_counter(perfmon_rows, "% Disk Time")
    cpu_pct    = _find_counter(perfmon_rows, "% Processor Time")
    cache_b    = _find_counter(perfmon_rows, "Cache Bytes")

    def _clean(series):
        return [v if (v is not None and np.isfinite(v) and v >= 0) else np.nan for v in series]

    avail_mb   = _clean(avail_mb)
    pages_sec  = _clean(pages_sec)
    faults_sec = _clean(faults_sec)
    disk_read  = _clean(disk_read)
    disk_write = _clean(disk_write)
    disk_pct   = _clean(disk_pct)
    cpu_pct    = _clean(cpu_pct)
    cache_b    = [v / 1024**2 if not np.isnan(v) else np.nan for v in _clean(cache_b)]  # MB

    # MB -> GB for disk bandwidth
    disk_read_mb  = [v / 1024**2 if not np.isnan(v) else np.nan for v in disk_read]
    disk_write_mb = [v / 1024**2 if not np.isnan(v) else np.nan for v in disk_write]

    # ---- figure layout ----
    fig = plt.figure(figsize=(14, 18))
    fig.patch.set_facecolor("#fafaf8")
    gs = gridspec.GridSpec(5, 1, figure=fig, hspace=0.55)

    PANEL_BG   = "#fffdf8"
    LATENCY_C  = "#1f77b4"
    MEMORY_C   = "#2f855a"
    PAGES_C    = "#d97706"
    FAULTS_C   = "#e53e3e"
    DISK_RD_C  = "#6b46c1"
    DISK_WR_C  = "#dd6b20"
    CPU_C      = "#2b6cb0"
    GRID_STYLE = dict(axis="y", linestyle="--", linewidth=0.7, alpha=0.35, color="#7f8c8d")

    def _style(ax):
        ax.set_facecolor(PANEL_BG)
        ax.grid(**GRID_STYLE)
        ax.spines["top"].set_visible(False)
        ax.spines["right"].set_visible(False)

    def _vspans(ax, records):
        """Shade each inference request window."""
        for r in records:
            x = r.started_at - t0
            color = LATENCY_C if r.success else "#e53e3e"
            ax.axvline(x, color=color, linewidth=0.5, alpha=0.25)

    # --------------------------------------------------------
    # Panel 0: Inference latency + rolling average
    # --------------------------------------------------------
    ax0 = fig.add_subplot(gs[0])
    _style(ax0)
    ok_x = [req_x[i] for i in range(len(inference_records)) if req_ok[i]]
    ok_y = [req_y[i] for i in range(len(inference_records)) if req_ok[i]]
    fail_x = [req_x[i] for i in range(len(inference_records)) if not req_ok[i]]
    fail_y = [req_y[i] for i in range(len(inference_records)) if not req_ok[i]]

    ax0.scatter(ok_x, ok_y, color=LATENCY_C, s=50, zorder=5, label="Latency (ms)")
    if fail_x:
        ax0.scatter(fail_x, fail_y, color="#e53e3e", s=50, marker="x", zorder=5, label="Failed")
    if len(ok_y) >= 3:
        roll = _smooth(ok_y, window=5)
        ax0.plot(ok_x, roll, color=LATENCY_C, linewidth=2, alpha=0.7, label="Rolling avg (w=5)")

    # Linear trend
    if len(ok_x) >= 4:
        coeff = np.polyfit(ok_x, ok_y, 1)
        trend = np.poly1d(coeff)
        ax0.plot(ok_x, trend(np.array(ok_x)), color="#e53e3e", linewidth=1.8,
                 linestyle="--", alpha=0.85, label=f"Trend ({coeff[0]:+.2f} ms/s)")

    ax0.set_ylabel("Latency (ms)")
    ax0.set_title("Inference Latency Over Time", fontsize=12, fontweight="bold", pad=8)
    ax0.legend(frameon=False, fontsize=9, ncol=4)

    # --------------------------------------------------------
    # Panel 1: Memory — Available MB + Cache MB
    # --------------------------------------------------------
    ax1 = fig.add_subplot(gs[1], sharex=ax0)
    _style(ax1)
    if pm_x and any(not np.isnan(v) for v in avail_mb):
        ax1.plot(pm_x, avail_mb, color=MEMORY_C, linewidth=1.8, label="Available RAM (MB)")
    ax1_r = ax1.twinx()
    if pm_x and any(not np.isnan(v) for v in cache_b):
        ax1_r.plot(pm_x, cache_b, color="#718096", linewidth=1.5, linestyle=":",
                   label="Cache (MB)")
        ax1_r.set_ylabel("Cache (MB)", color="#718096", fontsize=9)
        ax1_r.tick_params(axis="y", colors="#718096")
    _vspans(ax1, inference_records)
    ax1.set_ylabel("Available RAM (MB)")
    ax1.set_title("Memory Availability", fontsize=12, fontweight="bold", pad=8)
    lines1, labels1 = ax1.get_legend_handles_labels()
    lines1r, labels1r = ax1_r.get_legend_handles_labels()
    ax1.legend(lines1 + lines1r, labels1 + labels1r, frameon=False, fontsize=9)

    # --------------------------------------------------------
    # Panel 2: Paging — Pages/sec + Page Faults/sec
    # --------------------------------------------------------
    ax2 = fig.add_subplot(gs[2], sharex=ax0)
    _style(ax2)
    if pm_x and any(not np.isnan(v) for v in pages_sec):
        ax2.plot(pm_x, pages_sec, color=PAGES_C, linewidth=1.8, label="Pages/sec")
    ax2_r = ax2.twinx()
    if pm_x and any(not np.isnan(v) for v in faults_sec):
        ax2_r.plot(pm_x, faults_sec, color=FAULTS_C, linewidth=1.5, linestyle=":",
                   label="Page Faults/sec")
        ax2_r.set_ylabel("Page Faults/sec", color=FAULTS_C, fontsize=9)
        ax2_r.tick_params(axis="y", colors=FAULTS_C)
    _vspans(ax2, inference_records)
    ax2.set_ylabel("Pages/sec")
    ax2.set_title("VM Paging Activity", fontsize=12, fontweight="bold", pad=8)
    lines2, labels2 = ax2.get_legend_handles_labels()
    lines2r, labels2r = ax2_r.get_legend_handles_labels()
    ax2.legend(lines2 + lines2r, labels2 + labels2r, frameon=False, fontsize=9)

    # --------------------------------------------------------
    # Panel 3: Disk I/O bandwidth
    # --------------------------------------------------------
    ax3 = fig.add_subplot(gs[3], sharex=ax0)
    _style(ax3)
    if pm_x and any(not np.isnan(v) for v in disk_read_mb):
        ax3.plot(pm_x, disk_read_mb, color=DISK_RD_C, linewidth=1.8, label="Disk Read (MB/s)")
    if pm_x and any(not np.isnan(v) for v in disk_write_mb):
        ax3.plot(pm_x, disk_write_mb, color=DISK_WR_C, linewidth=1.5, linestyle="-.",
                 label="Disk Write (MB/s)")
    _vspans(ax3, inference_records)
    ax3.set_ylabel("Bandwidth (MB/s)")
    ax3.set_title("Disk I/O Bandwidth", fontsize=12, fontweight="bold", pad=8)
    ax3.legend(frameon=False, fontsize=9)

    # --------------------------------------------------------
    # Panel 4: CPU + Disk %
    # --------------------------------------------------------
    ax4 = fig.add_subplot(gs[4], sharex=ax0)
    _style(ax4)
    if pm_x and any(not np.isnan(v) for v in cpu_pct):
        ax4.plot(pm_x, cpu_pct, color=CPU_C, linewidth=1.8, label="CPU %")
    ax4_r = ax4.twinx()
    if pm_x and any(not np.isnan(v) for v in disk_pct):
        ax4_r.plot(pm_x, disk_pct, color=DISK_RD_C, linewidth=1.5, linestyle=":",
                   label="Disk Time %")
        ax4_r.set_ylabel("Disk Time %", color=DISK_RD_C, fontsize=9)
        ax4_r.tick_params(axis="y", colors=DISK_RD_C)
    _vspans(ax4, inference_records)
    ax4.set_ylabel("CPU %")
    ax4.set_xlabel("Elapsed Time (seconds)")
    ax4.set_title("CPU Utilization & Disk Busy Time", fontsize=12, fontweight="bold", pad=8)
    lines4, labels4 = ax4.get_legend_handles_labels()
    lines4r, labels4r = ax4_r.get_legend_handles_labels()
    ax4.legend(lines4 + lines4r, labels4 + labels4r, frameon=False, fontsize=9)

    # --------------------------------------------------------
    # Super-title + caption
    # --------------------------------------------------------
    fig.suptitle(
        "Perfmon Investigation: Why Does Inference Latency Grow?",
        fontsize=15, fontweight="bold", y=0.995, x=0.06, ha="left",
    )
    fig.text(
        0.06, 0.975,
        f"Model: {OLLAMA_MODEL}  |  {NUM_REQUESTS} sequential requests  |  "
        "Thin vertical lines = request start times  |  Dashed red = latency trend",
        fontsize=9, color="#4a5568", ha="left",
    )

    # --------------------------------------------------------
    # Conclusion annotation on latency panel
    # --------------------------------------------------------
    if len(ok_x) >= 4:
        coeff = np.polyfit(ok_x, ok_y, 1)
        direction = "increasing" if coeff[0] > 0.5 else ("decreasing" if coeff[0] < -0.5 else "stable")
        note = (
            f"Latency trend: {direction}\n"
            f"Slope: {coeff[0]:+.2f} ms/s over {ok_x[-1] - ok_x[0]:.0f}s"
        )
        ax0.text(
            0.98, 0.97, note,
            transform=ax0.transAxes, ha="right", va="top",
            fontsize=9, color="#1a202c",
            bbox=dict(boxstyle="round,pad=0.4", fc="#edf4ff", ec="#1f77b4", alpha=0.9),
        )

    fig.tight_layout(rect=(0, 0, 1, 0.97))
    fig.savefig(PERFMON_PLOT, dpi=160, bbox_inches="tight")
    plt.close(fig)
    log.info("Plot saved to %s", PERFMON_PLOT)
    return PERFMON_PLOT


# ---------------------------------------------------------------------------
# Diagnosis helper
# ---------------------------------------------------------------------------

def diagnose(inference_records: List[InferenceRecord], perfmon_rows: List[dict]) -> str:
    """Return a short plain-text diagnosis of the latency trend cause."""
    ok = [r for r in inference_records if r.success]
    if len(ok) < 4:
        return "Insufficient successful requests for diagnosis."

    x = np.array([r.started_at - ok[0].started_at for r in ok])
    y = np.array([r.latency_ms for r in ok])
    slope, intercept = np.polyfit(x, y, 1)

    lines = [
        "=== Perfmon Diagnosis ===",
        f"  Requests completed:  {len(ok)}/{len(inference_records)}",
        f"  Latency range:       {y.min():.0f} – {y.max():.0f} ms",
        f"  Median latency:      {np.median(y):.0f} ms",
        f"  Trend slope:         {slope:+.3f} ms / second",
        f"  Total drift:         {slope * (x[-1] - x[0]):+.0f} ms over {x[-1] - x[0]:.0f} s",
    ]

    if perfmon_rows:
        def _series(sub):
            vals = [r.get(next((k for k in r if sub.lower() in k.lower()), ""), None)
                    for r in perfmon_rows]
            return [v for v in vals if v is not None and np.isfinite(v)]

        avail = _series("Available MBytes")
        pages = _series("Pages/sec")
        faults = _series("Page Faults/sec")
        disk_rd = _series("Disk Read Bytes")

        if avail:
            lines.append(f"  RAM available:       {avail[0]:.0f} MB → {avail[-1]:.0f} MB  "
                         f"(Δ {avail[-1]-avail[0]:+.0f} MB)")
        if pages:
            lines.append(f"  Pages/sec peak:      {max(pages):.0f}")
        if faults:
            lines.append(f"  Page faults/sec avg: {np.mean(faults):.1f}")
        if disk_rd:
            peak_mb = max(disk_rd) / 1024**2
            lines.append(f"  Disk read peak:      {peak_mb:.1f} MB/s")

    lines.append("")
    if abs(slope) < 0.5:
        lines.append("VERDICT: Latency is STABLE. No significant growth detected during this run.")
        lines.append("The benchmark dataset shows pressure-induced slowdowns, not a temporal drift.")
    elif slope > 0:
        lines.append("VERDICT: Latency is GROWING.")
        # Look for correlated counters
        clues = []
        avail_s = [r.get(next((k for k in r if "Available MBytes" in k), ""), None)
                   for r in perfmon_rows]
        avail_s = [v for v in avail_s if v is not None]
        if len(avail_s) >= 4 and avail_s[-1] < avail_s[0] * 0.92:
            clues.append("Available RAM is declining — memory pressure from model KV cache growth or OS activity.")
        pg = [r.get(next((k for k in r if "Pages/sec" in k), ""), None) for r in perfmon_rows]
        pg = [v for v in pg if v is not None and np.isfinite(v)]
        if pg and np.mean(pg[-max(1,len(pg)//4):]) > np.mean(pg[:max(1,len(pg)//4)]) * 1.5:
            clues.append("Pages/sec is rising over time — the OS is increasingly paging, competing with inference.")
        dr = [r.get(next((k for k in r if "Disk Read Bytes" in k), ""), None) for r in perfmon_rows]
        dr = [v for v in dr if v is not None and np.isfinite(v) and v >= 0]
        if dr and np.mean(dr[-max(1,len(dr)//4):]) > np.mean(dr[:max(1,len(dr)//4)]) * 2:
            clues.append("Disk reads are accelerating — the file-system cache is being evicted, forcing storage reads.")
        if not clues:
            clues.append("No single dominant counter found — may be thermal throttling, OS scheduling noise, or GPU memory pressure.")
        for c in clues:
            lines.append(f"  • {c}")
    else:
        lines.append("VERDICT: Latency is DECREASING (warm-up effect).")

    return "\n".join(lines)


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main() -> None:
    log.info("=== Perfmon Latency Investigation ===")
    log.info("Model: %s  |  Requests: %d", OLLAMA_MODEL, NUM_REQUESTS)

    # Start typeperf monitor in background thread
    state = PerfmonState()
    monitor_thread = threading.Thread(target=run_typeperf_thread, args=(state,), daemon=True)
    monitor_thread.start()
    time.sleep(2)  # let typeperf initialize

    # Run inference
    records = run_inference_requests(NUM_REQUESTS)

    # Stop monitor
    log.info("Stopping typeperf monitor...")
    state.stop_event.set()
    if state.proc:
        try:
            state.proc.terminate()
        except Exception:
            pass
    monitor_thread.join(timeout=8)
    time.sleep(1)  # final CSV flush

    log.info("Collected %d perfmon samples, %d inference records.",
             len(state.rows), len(records))

    # Print diagnosis
    diagnosis = diagnose(records, state.rows)
    print("\n" + diagnosis + "\n")

    # Build visualization
    try:
        plot_path = build_visualization(records, state.rows)
        print(f"Visualization saved: {plot_path}")
    except Exception as exc:
        log.error("Visualization failed: %s", exc)
        raise

    # Save diagnosis alongside plot
    diag_path = RESULTS_DIR / "raw" / "perfmon_diagnosis.txt"
    diag_path.write_text(diagnosis, encoding="utf-8")
    print(f"Diagnosis text saved: {diag_path}")


if __name__ == "__main__":
    main()
