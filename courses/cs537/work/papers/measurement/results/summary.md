# Benchmark Summary

## Environment
- Config file: `D:\Develop\Transfer\UW-Madison\Courses\CS537\papers\measurement\config\default.yaml`
- Pilot mode: `False`
- Model: `qwen3:4b`
- Total RAM: `95.69 GiB`
- Page-fault support: Windows exposes total process page-fault counts via GetProcessMemoryInfo; minor and major faults are unavailable.

## Outputs
- Inference CSV: `D:\Develop\Transfer\UW-Madison\Courses\CS537\papers\measurement\results\raw\inference_runs.csv`
- System CSV: `D:\Develop\Transfer\UW-Madison\Courses\CS537\papers\measurement\results\raw\system_runs.csv`
- Latency plot: `D:\Develop\Transfer\UW-Madison\Courses\CS537\papers\measurement\results\plots\latency_by_condition.png`
- P95 plot: `D:\Develop\Transfer\UW-Madison\Courses\CS537\papers\measurement\results\plots\p95_latency_by_condition.png`
- Faults plot: `D:\Develop\Transfer\UW-Madison\Courses\CS537\papers\measurement\results\plots\faults_by_condition.png`
- I/O plot: `D:\Develop\Transfer\UW-Madison\Courses\CS537\papers\measurement\results\plots\io_by_condition.png`
- Presentation plot: `None`
- Observation report: `None`

## Latency Summary

| Condition | Requests | Median Latency (ms) | P95 Latency (ms) | Requested RAM x | Actual RAM x |
| --- | ---: | ---: | ---: | ---: | ---: |
| none_baseline | 60 | 945.04 | 1004.48 | 0.00 | 0.00 |
| file_seq__req_0.25x__actual_0.25x | 60 | 1039.78 | 1151.48 | 0.25 | 0.25 |
| file_seq__req_0.50x__actual_0.50x | 60 | 1050.16 | 1183.53 | 0.50 | 0.50 |
| file_seq__req_0.90x__actual_0.90x | 60 | 1073.44 | 1249.71 | 0.90 | 0.90 |
| file_seq__req_1.10x__actual_1.10x | 60 | 1103.34 | 1267.45 | 1.10 | 1.10 |
| file_seq__req_1.50x__actual_1.50x | 60 | 1077.85 | 1235.02 | 1.50 | 1.50 |
| mmap_random__req_0.25x__actual_0.25x | 60 | 1127.69 | 1318.21 | 0.25 | 0.25 |
| mmap_random__req_0.50x__actual_0.50x | 60 | 1171.61 | 1291.01 | 0.50 | 0.50 |
| mmap_random__req_0.90x__actual_0.90x | 60 | 1076.58 | 1243.36 | 0.90 | 0.90 |
| mmap_random__req_1.10x__actual_1.10x | 60 | 1122.85 | 1282.71 | 1.10 | 1.10 |
| mmap_random__req_1.50x__actual_1.50x | 60 | 1111.95 | 1242.71 | 1.50 | 1.50 |
| anon__req_0.25x__actual_0.25x | 60 | 1065.39 | 1203.20 | 0.25 | 0.25 |
| anon__req_0.50x__actual_0.42x | 60 | 1034.85 | 1132.47 | 0.50 | 0.42 |
| anon__req_0.90x__actual_0.76x | 60 | 960.82 | 1055.54 | 0.90 | 0.76 |
| anon__req_1.10x__actual_0.76x | 60 | 960.20 | 1008.23 | 1.10 | 0.76 |
| anon__req_1.50x__actual_0.76x | 60 | 963.54 | 1091.53 | 1.50 | 0.76 |

## Observations
- Baseline median latency was 945.04 ms; the highest observed median latency was 1171.61 ms under `mmap_random__req_0.50x__actual_0.50x`.
- 12 run(s) used a reduced actual pressure size because of safety or disk caps.
- The study infers VM and filesystem behavior from externally observable latency, fault counters, and I/O counters.
- On platforms without full fault breakdown support, detailed fault plots may be absent or partially null.
