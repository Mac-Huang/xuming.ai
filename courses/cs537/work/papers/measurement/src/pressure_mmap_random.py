from __future__ import annotations

import mmap
import traceback
from pathlib import Path
from typing import Any


def run_mmap_random_worker(
    stop_event: Any,
    status_queue: Any,
    file_path: str,
    size_bytes: int,
) -> None:
    try:
        path = Path(file_path)
        file_size = path.stat().st_size
        actual_size = min(int(size_bytes), int(file_size))
        if actual_size <= 0:
            raise ValueError("mmap_random pressure requires a non-empty backing file.")

        page_size = mmap.PAGESIZE
        with path.open("rb") as handle, mmap.mmap(
            handle.fileno(),
            length=actual_size,
            access=mmap.ACCESS_READ,
        ) as mapped:
            page_count = max(1, (actual_size + page_size - 1) // page_size)
            state = 0xC0FFEE1234
            checksum = 0
            status_queue.put({"status": "started", "actual_size_bytes": actual_size})

            while not stop_event.is_set():
                state = (6364136223846793005 * state + 1442695040888963407) & 0xFFFFFFFFFFFFFFFF
                page_index = state % page_count
                offset = min(page_index * page_size, actual_size - 1)
                checksum ^= mapped[offset]

        _ = checksum
    except Exception as exc:
        status_queue.put(
            {
                "status": "error",
                "error": str(exc),
                "traceback": traceback.format_exc(),
            }
        )
