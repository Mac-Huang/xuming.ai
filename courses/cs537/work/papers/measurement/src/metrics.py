from __future__ import annotations

import ctypes
import logging
import os
import platform
from ctypes import wintypes
from pathlib import Path
from typing import Dict, Iterable, Optional

import psutil

try:
    import resource
except ImportError:  # pragma: no cover - Windows
    resource = None


LOGGER = logging.getLogger(__name__)

SYSTEM_METRIC_FIELDS = [
    "system_memory_total_bytes",
    "system_memory_available_bytes",
    "system_memory_used_bytes",
    "system_swap_used_bytes",
    "system_disk_read_bytes",
    "system_disk_write_bytes",
    "system_disk_read_count",
    "system_disk_write_count",
]

MANAGED_METRIC_FIELDS = [
    "managed_process_count",
    "managed_rss_bytes",
    "managed_vms_bytes",
    "managed_cpu_user_seconds",
    "managed_cpu_system_seconds",
    "managed_io_read_bytes",
    "managed_io_write_bytes",
    "managed_minor_faults",
    "managed_major_faults",
    "managed_page_faults_total",
]


def get_total_memory_bytes() -> int:
    return int(psutil.virtual_memory().total)


def get_disk_free_bytes(path: Path) -> int:
    return int(psutil.disk_usage(str(path)).free)


def page_fault_measurement_note() -> str:
    system = platform.system()
    if system == "Linux":
        return "Per-process minor and major faults are collected from /proc/<pid>/stat."
    if system == "Windows":
        return (
            "Windows exposes total process page-fault counts via GetProcessMemoryInfo; "
            "minor and major faults are unavailable."
        )
    return (
        "This OS does not expose portable per-process page-fault counters here; "
        "null values may appear for detailed fault metrics."
    )


def _linux_faults_for_pid(pid: int) -> Dict[str, Optional[int]]:
    stat_path = Path(f"/proc/{pid}/stat")
    if not stat_path.exists():
        return {"minor_faults": None, "major_faults": None}

    content = stat_path.read_text(encoding="utf-8")
    rest = content[content.rfind(")") + 2 :].split()
    if len(rest) < 11:
        return {"minor_faults": None, "major_faults": None}

    return {
        "minor_faults": int(rest[7]),
        "major_faults": int(rest[9]),
    }


def _windows_total_faults_for_pid(pid: int) -> Optional[int]:
    psapi = ctypes.WinDLL("Psapi.dll")
    kernel32 = ctypes.WinDLL("Kernel32.dll")

    class PROCESS_MEMORY_COUNTERS_EX(ctypes.Structure):
        _fields_ = [
            ("cb", wintypes.DWORD),
            ("PageFaultCount", wintypes.DWORD),
            ("PeakWorkingSetSize", ctypes.c_size_t),
            ("WorkingSetSize", ctypes.c_size_t),
            ("QuotaPeakPagedPoolUsage", ctypes.c_size_t),
            ("QuotaPagedPoolUsage", ctypes.c_size_t),
            ("QuotaPeakNonPagedPoolUsage", ctypes.c_size_t),
            ("QuotaNonPagedPoolUsage", ctypes.c_size_t),
            ("PagefileUsage", ctypes.c_size_t),
            ("PeakPagefileUsage", ctypes.c_size_t),
            ("PrivateUsage", ctypes.c_size_t),
        ]

    PROCESS_QUERY_INFORMATION = 0x0400
    PROCESS_VM_READ = 0x0010

    open_process = kernel32.OpenProcess
    close_handle = kernel32.CloseHandle
    get_process_memory_info = psapi.GetProcessMemoryInfo

    handle = open_process(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, False, pid)
    if not handle:
        return None

    try:
        counters = PROCESS_MEMORY_COUNTERS_EX()
        counters.cb = ctypes.sizeof(PROCESS_MEMORY_COUNTERS_EX)
        success = get_process_memory_info(handle, ctypes.byref(counters), counters.cb)
        if not success:
            return None
        return int(counters.PageFaultCount)
    finally:
        close_handle(handle)


def _fault_metrics_for_pid(pid: int) -> Dict[str, Optional[int]]:
    system = platform.system()
    if system == "Linux":
        faults = _linux_faults_for_pid(pid)
        return {
            "minor_faults": faults["minor_faults"],
            "major_faults": faults["major_faults"],
            "page_faults_total": None,
        }
    if system == "Windows":
        total = _windows_total_faults_for_pid(pid)
        return {
            "minor_faults": None,
            "major_faults": None,
            "page_faults_total": total,
        }

    if pid == os.getpid() and resource is not None:
        usage = resource.getrusage(resource.RUSAGE_SELF)
        return {
            "minor_faults": int(getattr(usage, "ru_minflt", 0)),
            "major_faults": int(getattr(usage, "ru_majflt", 0)),
            "page_faults_total": None,
        }

    return {
        "minor_faults": None,
        "major_faults": None,
        "page_faults_total": None,
    }


def _process_metrics(pid: int) -> Dict[str, Optional[float]]:
    try:
        proc = psutil.Process(pid)
        memory = proc.memory_info()
        cpu_times = proc.cpu_times()
        io_counters = proc.io_counters() if hasattr(proc, "io_counters") else None
        faults = _fault_metrics_for_pid(pid)
        return {
            "rss_bytes": float(getattr(memory, "rss", 0)),
            "vms_bytes": float(getattr(memory, "vms", 0)),
            "cpu_user_seconds": float(getattr(cpu_times, "user", 0.0)),
            "cpu_system_seconds": float(getattr(cpu_times, "system", 0.0)),
            "io_read_bytes": float(getattr(io_counters, "read_bytes", 0.0))
            if io_counters
            else None,
            "io_write_bytes": float(getattr(io_counters, "write_bytes", 0.0))
            if io_counters
            else None,
            "minor_faults": float(faults["minor_faults"]) if faults["minor_faults"] is not None else None,
            "major_faults": float(faults["major_faults"]) if faults["major_faults"] is not None else None,
            "page_faults_total": float(faults["page_faults_total"])
            if faults["page_faults_total"] is not None
            else None,
        }
    except (psutil.Error, FileNotFoundError, PermissionError) as exc:
        LOGGER.debug("Skipping process metrics for pid=%s: %s", pid, exc)
        return {
            "rss_bytes": None,
            "vms_bytes": None,
            "cpu_user_seconds": None,
            "cpu_system_seconds": None,
            "io_read_bytes": None,
            "io_write_bytes": None,
            "minor_faults": None,
            "major_faults": None,
            "page_faults_total": None,
        }


def capture_snapshot(extra_pids: Optional[Iterable[int]] = None) -> Dict[str, Optional[float]]:
    snapshot: Dict[str, Optional[float]] = {field: None for field in SYSTEM_METRIC_FIELDS}
    snapshot.update({field: None for field in MANAGED_METRIC_FIELDS})

    virtual_memory = psutil.virtual_memory()
    swap = psutil.swap_memory()
    disk_io = psutil.disk_io_counters()

    snapshot["system_memory_total_bytes"] = float(virtual_memory.total)
    snapshot["system_memory_available_bytes"] = float(virtual_memory.available)
    snapshot["system_memory_used_bytes"] = float(virtual_memory.used)
    snapshot["system_swap_used_bytes"] = float(swap.used)
    if disk_io is not None:
        snapshot["system_disk_read_bytes"] = float(disk_io.read_bytes)
        snapshot["system_disk_write_bytes"] = float(disk_io.write_bytes)
        snapshot["system_disk_read_count"] = float(disk_io.read_count)
        snapshot["system_disk_write_count"] = float(disk_io.write_count)

    tracked_pids = {os.getpid()}
    if extra_pids:
        tracked_pids.update(pid for pid in extra_pids if pid is not None)

    aggregate = {
        "managed_process_count": 0.0,
        "managed_rss_bytes": 0.0,
        "managed_vms_bytes": 0.0,
        "managed_cpu_user_seconds": 0.0,
        "managed_cpu_system_seconds": 0.0,
        "managed_io_read_bytes": 0.0,
        "managed_io_write_bytes": 0.0,
        "managed_minor_faults": 0.0,
        "managed_major_faults": 0.0,
        "managed_page_faults_total": 0.0,
    }
    availability = {key: False for key in aggregate if key != "managed_process_count"}

    for pid in tracked_pids:
        metrics = _process_metrics(pid)
        aggregate["managed_process_count"] += 1.0
        field_map = {
            "rss_bytes": "managed_rss_bytes",
            "vms_bytes": "managed_vms_bytes",
            "cpu_user_seconds": "managed_cpu_user_seconds",
            "cpu_system_seconds": "managed_cpu_system_seconds",
            "io_read_bytes": "managed_io_read_bytes",
            "io_write_bytes": "managed_io_write_bytes",
            "minor_faults": "managed_minor_faults",
            "major_faults": "managed_major_faults",
            "page_faults_total": "managed_page_faults_total",
        }
        for source_key, dest_key in field_map.items():
            value = metrics[source_key]
            if value is not None:
                aggregate[dest_key] += float(value)
                availability[dest_key] = True

    for key, value in aggregate.items():
        if key == "managed_process_count" or availability.get(key, False):
            snapshot[key] = value

    return snapshot


def _delta(before: Optional[float], after: Optional[float]) -> Optional[float]:
    if before is None or after is None:
        return None
    return after - before


def build_counter_columns() -> list[str]:
    columns = []
    for field in SYSTEM_METRIC_FIELDS:
        columns.extend([f"{field}_before", f"{field}_after", f"{field}_delta"])
    for field in MANAGED_METRIC_FIELDS:
        columns.extend([f"{field}_before", f"{field}_during", f"{field}_delta"])
    return columns


def build_counter_row(
    before: Dict[str, Optional[float]],
    during: Dict[str, Optional[float]],
    after: Dict[str, Optional[float]],
) -> Dict[str, Optional[float]]:
    row: Dict[str, Optional[float]] = {}
    for field in SYSTEM_METRIC_FIELDS:
        row[f"{field}_before"] = before.get(field)
        row[f"{field}_after"] = after.get(field)
        row[f"{field}_delta"] = _delta(before.get(field), after.get(field))
    for field in MANAGED_METRIC_FIELDS:
        row[f"{field}_before"] = before.get(field)
        row[f"{field}_during"] = during.get(field)
        row[f"{field}_delta"] = _delta(before.get(field), during.get(field))
    return row
