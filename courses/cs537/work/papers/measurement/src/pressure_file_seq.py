from __future__ import annotations

import traceback
from pathlib import Path
from typing import Any


def run_file_seq_worker(
    stop_event: Any,
    status_queue: Any,
    file_path: str,
    size_bytes: int,
    chunk_size_bytes: int,
) -> None:
    try:
        path = Path(file_path)
        file_size = path.stat().st_size
        actual_size = min(int(size_bytes), int(file_size))
        if actual_size <= 0:
            raise ValueError("Sequential file pressure requires a non-empty backing file.")

        buffer = bytearray(min(int(chunk_size_bytes), actual_size))
        view = memoryview(buffer)
        checksum = 0

        with path.open("rb", buffering=0) as handle:
            remaining = actual_size
            status_queue.put({"status": "started", "actual_size_bytes": actual_size})
            while not stop_event.is_set():
                if remaining <= 0:
                    handle.seek(0)
                    remaining = actual_size

                read_target = min(len(buffer), remaining)
                bytes_read = handle.readinto(view[:read_target])
                if bytes_read == 0:
                    handle.seek(0)
                    remaining = actual_size
                    continue

                checksum ^= buffer[0]
                remaining -= bytes_read

        _ = checksum
    except Exception as exc:
        status_queue.put(
            {
                "status": "error",
                "error": str(exc),
                "traceback": traceback.format_exc(),
            }
        )
