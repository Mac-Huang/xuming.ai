from __future__ import annotations

import mmap
import traceback
from typing import Any


def _next_backoff_size(current_size: int, page_size: int) -> int:
    reduced = int(current_size * 0.85)
    reduced -= reduced % page_size
    if reduced >= current_size:
        reduced = current_size - page_size
    return max(reduced, page_size)


def run_anon_worker(
    stop_event: Any,
    status_queue: Any,
    size_bytes: int,
) -> None:
    try:
        requested_size = int(size_bytes)
        if requested_size <= 0:
            raise ValueError("Anonymous pressure requires a positive allocation size.")

        page_size = mmap.PAGESIZE
        actual_size = requested_size - (requested_size % page_size)
        last_error: Exception | None = None
        attempts = 0

        while actual_size >= page_size:
            attempts += 1
            try:
                with mmap.mmap(-1, actual_size, access=mmap.ACCESS_WRITE) as region:
                    for offset in range(0, actual_size, page_size):
                        region[offset] = 1
                        if stop_event.is_set():
                            break

                    checksum = 0
                    value = 1
                    status_queue.put(
                        {
                            "status": "started",
                            "actual_size_bytes": actual_size,
                            "requested_size_bytes": requested_size,
                            "allocation_attempts": attempts,
                        }
                    )

                    while not stop_event.is_set():
                        for offset in range(0, actual_size, page_size):
                            region[offset] = value
                            checksum ^= region[offset]
                            if stop_event.is_set():
                                break
                        value = 0 if value else 1

                _ = checksum
                return
            except (BufferError, MemoryError, OSError) as exc:
                last_error = exc
                next_size = _next_backoff_size(actual_size, page_size)
                if next_size >= actual_size:
                    break
                actual_size = next_size

        raise RuntimeError(
            "Anonymous pressure could not reserve a workable allocation size. "
            f"Last error: {last_error}"
        )
    except (BufferError, MemoryError, OSError, ValueError, RuntimeError) as exc:
        status_queue.put(
            {
                "status": "error",
                "error": str(exc),
                "traceback": traceback.format_exc(),
            }
        )
