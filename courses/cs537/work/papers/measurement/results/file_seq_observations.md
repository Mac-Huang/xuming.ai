# file_seq Observation Report

- Model: `qwen3:4b`
- Total RAM: `95.69 GiB`
- Scope: baseline plus sequential file-scanning pressure only
- Each condition used 3 trials and 20 inference requests per trial

## Main observations
- Baseline median latency was `1002.25 ms` and baseline p95 was `1058.09 ms`.
- The first added file_seq load at `0.10x` RAM already raised median latency to `1078.87 ms`, about `7.6%` above baseline.
- The highest median latency occurred at `1.50x` RAM with `1173.99 ms`, `17.1%` above baseline.
- At `1.00x` RAM pressure, median latency was `1146.93 ms` and p95 latency was `1286.80 ms`.
- The latency trend was mostly monotonic: once file_seq pressure started, latency rose quickly and then stayed elevated as the scanned file size increased.
- The median slowdown was much clearer than any page-fault trend.

## Page-fault observations
- Baseline total page-fault delta was only about `6`.
- Under file_seq, total page-fault deltas stayed in a narrow band of about `29444` to `29572`.
- That means page faults increased sharply when file_seq was introduced, but did not continue rising much as the file_seq percentage increased.
- On this Windows machine, the dominant growth with heavier file_seq was sustained file-backed read traffic and page-cache pressure, not an escalating fault storm.

## Read-traffic observations
- System disk read deltas ranged from roughly `0.00 B` to `85.93 GiB` across file_seq conditions.
- The larger file_seq conditions increasingly forced real storage reads instead of relying only on already-warm cached pages.

## Interpretation
- Heavier sequential file scanning kept the operating system busy streaming file-backed pages through the cache and storage stack.
- That competition raised end-to-end Ollama latency even though the model compute itself may still be GPU-heavy.
- The data supports a cache-and-I/O contention explanation more strongly than a page-fault-explosion explanation.
