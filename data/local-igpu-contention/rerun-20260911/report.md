# Clean contention rerun — September 11, 2026

Fresh measurements on the same 24 GiB M5 Pro laptop. Previous campaigns remain separate. Every admitted trial is retained, including resource stops and output-quality failures.

## Cloud correction

The original one-shot combined condition was slower in two of three pairs; a ratio of group medians obscured that direction. Original agentic combined runs had 3,200 / 6,400 / 4,864 additional cached input tokens and different generated reasoning. Those observations did not establish a contention benefit.

The new cloud experiment uses six balanced quiet/combined pairs per task. The five-call agent trace fixes task prompts, screenshots and source history; fresh autonomous agents are a separate three-pair series. Fresh instruction markers reduce prefix reuse but do not guarantee an empty service cache. All calls retain reported token counts.

Input/cache counts match at every step in 10/12 cloud task pairs; generated output and reasoning counts also match in 0/12. Therefore cloud ratios remain descriptive application observations, not matched inference or a causal contention estimate.

## Measured task medians

Effective output throughput is generated tokens divided by full task time. Cloud excludes hidden reasoning from the numerator while retaining its latency cost. Local includes action and recovery tokens. Loading and warmup are excluded. Decode rates are separately recorded; tokenizers and answer quality differ.

| Series | Condition | Task | n | Seconds | Effective tokens/s | Median paired latency ratio |
|---|---|---|---:|---:|---:|---:|
| 35b | quiet | agentic | 3 | 419.28 | 0.57 | — |
| 35b | quiet | one_shot | 3 | 422.27 | 0.77 | — |
| 4b | browser | agentic | 3 | 13.60 | 34.64 | 1.083× |
| 4b | browser | one_shot | 3 | 4.66 | 55.97 | 1.103× |
| 4b | combined | agentic | 3 | 14.92 | 31.58 | 1.189× |
| 4b | combined | one_shot | 3 | 5.13 | 50.86 | 1.204× |
| 4b | fault | agentic | 3 | 13.43 | 35.08 | 1.064× |
| 4b | fault | one_shot | 3 | 4.97 | 52.54 | 1.143× |
| 4b | game | agentic | 3 | 14.53 | 32.40 | 1.152× |
| 4b | game | one_shot | 3 | 4.96 | 52.58 | 1.155× |
| 4b | gpu | agentic | 3 | 63.51 | 7.42 | 5.061× |
| 4b | gpu | one_shot | 3 | 24.60 | 10.61 | 5.799× |
| 4b | quiet | agentic | 3 | 12.55 | 37.53 | — |
| 4b | quiet | one_shot | 3 | 4.26 | 61.23 | — |
| 4b | video | agentic | 3 | 12.63 | 37.30 | 1.007× |
| 4b | video | one_shot | 3 | 4.31 | 60.61 | 1.010× |
| 9b | quiet | agentic | 3 | 13.27 | 19.83 | — |
| 9b | quiet | one_shot | 3 | 7.82 | 33.63 | — |
| cloud | combined | agentic | 6 | 41.81 | 10.01 | 0.966× |
| cloud | combined | one_shot | 6 | 20.17 | 17.93 | 1.101× |
| cloud | quiet | agentic | 6 | 42.09 | 9.85 | — |
| cloud | quiet | one_shot | 6 | 18.48 | 19.37 | — |
| cloud_agent | combined | agentic | 3 | 37.98 | 11.01 | 0.920× |
| cloud_agent | quiet | agentic | 3 | 41.95 | 9.92 | — |

Ratios are medians of within-repetition paired ratios, not ratios of independent group medians. Dots and observed ranges on the graphs expose the small sample size; these are not confidence intervals or p95 estimates.

## Work and answer checks

- cloud: 24 completed workloads; 18 meet 180–230 words; 24 pass the source-ID/read check. This is not a factual correctness score.
- cloud_agent: 6 completed workloads; 5 meet 180–230 words; 6 pass the source-ID/read check. This is not a factual correctness score.
- 4b: 42 completed workloads; 0 meet 180–230 words; 42 pass the source-ID/read check. This is not a factual correctness score.
  36/36 completed pairs match task prompts, generated token counts and final answer hash.
- 9b: 6 completed workloads; 0 meet 180–230 words; 3 pass the source-ID/read check. This is not a factual correctness score.
  Secondary audit flags unread source IDs: S5. The original runtime gate recognized brackets only and missed alternate citation formatting; its timed behavior is preserved.
- 35b: 6 completed workloads; 3 meet 180–230 words; 6 pass the source-ID/read check. This is not a factual correctness score.

## Larger-model execution and limits

The first completed 35B quiet agent answer omitted the requested frontier-policy comparison and contained only 127 words. Its execution completed, but that does not establish successful research or quality equivalence.

The 9B model is a pinned affine 4-bit MLX conversion. The 35B model is the official Holo 3.1 35B-A3B NVFP4 checkpoint through a custom scale-preserving Metal adapter, with BF16 dense matrices, all experts on disk, CPU routing/cache management and a 0.5 GB expert cache. This is not native NVIDIA NVFP4 execution. The earlier 2 GB-cache observations are not pooled. Sampled numerical checks and source hashes are retained under large/artifacts.

Quiet retains the existing user desktop plus the small benchmark browser reference. Combined adds 1080p60 video, eight active tabs and synthetic WebGL. 4B also tests each contender, heavy Metal GEMM and 4 GiB read-only file remapping. Read/remap faults alone do not demonstrate sustained SSD thrashing.

## Stops and cleanup

- 9b r1 combined: trial_swap_budget; 687,341,568 additional host swap-out page-equivalent bytes. Only task modes with a recorded workload-end event enter latency statistics.
- 35b r1 combined: trial_swap_budget; 583,532,544 additional host swap-out page-equivalent bytes. Only task modes with a recorded workload-end event enter latency statistics.

Removed 58.50 GB of new temporary weights/repacked experts and fixtures. Owned benchmark processes remaining: 0. Final recorded thermal state: 0 (0 = nominal). Evidence, scripts, original models and user applications are retained.

The guard samples approximately every 0.2 seconds: 512 MiB additional swap per process, 2 GiB per campaign, available-memory and thermal limits, AC power, and bounded duration. A sampled stop may overshoot its threshold. VM swap counters count page equivalents, not physical SSD bytes written. No OS protections, clocks, fans or system swap files are changed.

See PROTOCOL.md and artifacts/{runs,steps,pairs,summary,stops}.csv for controls and raw arithmetic. The page links the corrected data and preserves an archive of the first campaign.
