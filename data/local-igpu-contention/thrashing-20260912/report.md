# Intentional file-backed memory thrashing on the M5 Pro

Fresh quiet, 2 GiB resident page-touch, and 32 GiB page-thrashing trials. Three repetitions per condition and model; the 32 GiB working set exceeds the laptop’s 24 GiB RAM. Same robotics research one-shot and agentic workloads. No experiment browser/video/game activity. User applications stayed open.

## Holo 3.1 4B

|Condition / task|Latency (s)|Effective tokens/s|Decode tokens/s|First-call TTFT (s)|Disk read (MiB/s)|Peak MLX (GB)|
|---|---:|---:|---:|---:|---:|---:|
|quiet / one_shot|3.878|67.303|83.010|0.728|17.2|4.873|
|quiet / agentic|12.064|39.042|78.827|0.224|20.0|5.533|
|resident / one_shot|4.821|54.142|72.591|0.779|39.3|4.873|
|resident / agentic|13.086|35.992|70.145|0.225|21.3|5.533|
|thrash / one_shot|4.526|57.661|73.045|1.296|1199.3|4.873|
|thrash / agentic|12.605|37.366|75.809|0.227|1718.7|5.533|

All entries above are medians of three trials. Effective throughput includes all tool-loop time and generated action JSON. Decode throughput is token-weighted from the model’s per-call decode rates. MLX allocation peak excludes OS page cache and untracked process memory; the table shows median trial peaks, not checkpoint size.

Exact matching: 12/12 paired comparisons had identical per-call prompt hashes, input/output token counts, and final answer hashes.

- resident one_shot: median paired latency ratio 1.145×.
- resident agentic: median paired latency ratio 1.066×.
- thrash one_shot: median paired latency ratio 1.167×.
- thrash agentic: median paired latency ratio 1.026×.

Quality is separate from timing: 18/18 tasks reached an accepted final; 18/18 passed format-tolerant source-ID/read checks; 0/18 met the requested 180–230-word length. Observed length range: 88–174 words. Full coverage flags and final answers remain in raw evidence.

- quiet: task-window disk reads 0.97 GiB total; VM page-in equivalents 1.79 GiB; swap-in/out equivalents 0.9/0.0 MiB. Minimum sampled available memory 3.73 GiB; maximum thermal state 0.
- resident: task-window disk reads 2.47 GiB total; VM page-in equivalents 2.36 GiB; swap-in/out equivalents 4.6/0.0 MiB. Minimum sampled available memory 3.12 GiB; maximum thermal state 0.
- thrash: task-window disk reads 78.98 GiB total; VM page-in equivalents 78.28 GiB; swap-in/out equivalents 5.0/0.0 MiB. Minimum sampled available memory 2.97 GiB; maximum thermal state 0.

Whole-trial swap-out equivalents (including model loading, warmup and stress setup): quiet: 0.00 GiB, resident: 0.00 GiB, thrash: 0.60 GiB.

## Holo 3.1 9B

|Condition / task|Latency (s)|Effective tokens/s|Decode tokens/s|First-call TTFT (s)|Disk read (MiB/s)|Peak MLX (GB)|
|---|---:|---:|---:|---:|---:|---:|
|quiet / one_shot|6.615|39.758|49.326|1.262|12.5|8.270|
|quiet / agentic|11.181|23.523|49.815|0.368|15.7|9.394|
|resident / one_shot|7.086|37.118|45.250|1.285|27.2|8.270|
|resident / agentic|11.834|22.223|45.545|0.387|59.6|9.394|
|thrash / one_shot|7.755|33.912|48.348|2.256|1231.3|8.270|
|thrash / agentic|11.436|22.997|48.666|0.373|1600.2|9.394|

All entries above are medians of three trials. Effective throughput includes all tool-loop time and generated action JSON. Decode throughput is token-weighted from the model’s per-call decode rates. MLX allocation peak excludes OS page cache and untracked process memory; the table shows median trial peaks, not checkpoint size.

Exact matching: 12/12 paired comparisons had identical per-call prompt hashes, input/output token counts, and final answer hashes.

- resident one_shot: median paired latency ratio 1.079×.
- resident agentic: median paired latency ratio 1.058×.
- thrash one_shot: median paired latency ratio 1.168×.
- thrash agentic: median paired latency ratio 1.024×.

Quality is separate from timing: 18/18 tasks reached an accepted final; 9/18 passed format-tolerant source-ID/read checks; 0/18 met the requested 180–230-word length. Observed length range: 162–176 words. Full coverage flags and final answers remain in raw evidence.

- quiet: task-window disk reads 0.74 GiB total; VM page-in equivalents 0.37 GiB; swap-in/out equivalents 33.6/0.0 MiB. Minimum sampled available memory 2.32 GiB; maximum thermal state 0.
- resident: task-window disk reads 2.73 GiB total; VM page-in equivalents 2.17 GiB; swap-in/out equivalents 10.3/476.0 MiB. Minimum sampled available memory 2.08 GiB; maximum thermal state 0.
- thrash: task-window disk reads 81.12 GiB total; VM page-in equivalents 79.92 GiB; swap-in/out equivalents 18.0/0.0 MiB. Minimum sampled available memory 2.93 GiB; maximum thermal state 0.

Whole-trial swap-out equivalents (including model loading, warmup and stress setup): quiet: 0.24 GiB, resident: 0.48 GiB, thrash: 1.96 GiB.

## Interpretation and limits

The script maintains a persistent read-only mapping and touches one word on every OS page, in shuffled 64 MiB block order. It does not force cache drops or repeatedly unmap memory. The 2 GiB condition uses the identical algorithm with a working set that fits; the 32 GiB condition forces file-cache turnover when combined with the running system. It is a file-backed paging experiment, not an anonymous dirty-memory or swap-write torture test. A larger mapping size is virtual address space, not an assertion of that much resident RAM.

Physical disk0 counters are host-wide, sampled near task boundaries, and include unrelated application I/O. VM page-in/swap counters are page equivalents, not physical SSD byte measurements. Sustained loop progress plus much larger measured disk reads supports storage-backed paging. CPU work, memory traffic, page-fault handling and disk traffic coexist; these measurements do not isolate one as the sole cause. Three trials show observed spread, not a confidence interval or population p95.

The prior cloud, 4B daily-use, 9B daily-use and 35B campaigns remain separate. No cloud or 35B synthetic-thrashing result is inferred from these runs. Existing OS thermal protections remain; there were no custom thermal or swap-volume cutoffs. AC, available-memory emergency checks and bounded trial runtime remained. Raw failed/pilot observations are retained separately.

## Cleanup

Removed 41.81 GB of temporary model/stress files. Remaining experiment workers: 0. Raw measured and pilot evidence, scripts, and the pre-existing 4B model are retained.
