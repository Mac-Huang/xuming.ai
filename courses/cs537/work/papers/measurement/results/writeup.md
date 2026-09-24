# Short Write-Up

## Setup

- Machine: Windows
- Model: `qwen3:4b` through local Ollama
- Baseline: 3 trials, 20 requests per trial
- Pressure modes: `file_seq`, `mmap_random`, `anon`

## Main latency comparisons

- Baseline median latency was `1018.25 ms`.
- The highest median latency was `1189.34 ms` under `mmap_random__req_1.10x__actual_1.10x`, about `16.8%` above baseline.
- `file_seq` increased median latency fairly steadily as pressure size grew:
  - `0.25x`: `1122.80 ms`
  - `0.50x`: `1135.98 ms`
  - `0.90x`: `1154.56 ms`
  - `1.10x`: `1177.71 ms`
  - `1.50x`: `1180.49 ms`
- `mmap_random` was generally slightly worse than `file_seq` at the same size, especially from `0.25x` through `1.10x`:
  - `0.25x`: `1154.93 ms`
  - `0.50x`: `1166.76 ms`
  - `0.90x`: `1172.02 ms`
  - `1.10x`: `1189.34 ms`
  - `1.50x`: `1178.92 ms`

## Counter interpretation

- `file_seq` produced the largest read traffic. Median `managed_io_read_bytes_delta` ranged from roughly `93 GB` to `231 GB`, which matches the intended sequential scan pressure.
- `mmap_random` produced much higher total page-fault counts than `file_seq` while generating less direct process read traffic, which is consistent with irregular file-backed page access.
- `anon` produced the highest total page-fault counts overall, but not the heaviest read traffic, which is consistent with anonymous-memory residency pressure rather than raw file streaming.

## Windows-specific anon result

- On this machine, the original top-end `anon` conditions could not reserve the full planned `0.90x` RAM anonymous mapping reliably.
- The worker was patched to back off automatically, and the largest stable anonymous working size ended up at about `73.20 GiB`, approximately `0.76x` of RAM.
- Those backed-off runs completed successfully and are recorded as:
  - `anon__req_0.90x__actual_0.76x`
  - `anon__req_1.10x__actual_0.76x`
  - `anon__req_1.50x__actual_0.76x`
- These should not be interpreted as true above-RAM anonymous pressure. They are the largest anonymous pressure levels Windows would admit under this setup without failing allocation/startup.

## Practical conclusion

- The cleanest result in this dataset is that file-backed pressure slows inference measurably, and irregular file-backed access is usually a bit worse than sequential streaming.
- The strongest Windows-specific caveat is that anonymous pressure above about `0.76x` RAM was not directly realizable here, so the high-end `anon` results represent a backed-off feasible pressure level rather than the originally requested sizes.
