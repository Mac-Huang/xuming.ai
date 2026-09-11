# Larger-model paging rerun — September 11, 2026

The custom thermal and swap-volume stop conditions were removed at the user’s request. macOS thermal pressure and swap volume remain observations. Native macOS protections, AC-power, minimum-available-memory and duration checks remain. This does not equate swap activity with temperature or a hardware damage threshold.

Fresh 9B conditions and 35B quiet/combined pairs use the same pinned models, corpus, prompts, greedy decoding, 128-token prefill, 128 MiB allocator cache and identical warmups. The 9B full matrix replaces its earlier quiet/combined-only dataset; campaign tags identify the source of each row. The 35B custom Metal adapter retains the 0.5 GB expert cache and all model experts. The earlier aborted attempts are archived, not pooled.

One additional completed 35B combined condition is retained in artifacts/extra-35b-trials.csv. Its quiet counterpart had not run before the user-requested full 9B campaign. Both conditions of that repetition were therefore repeated together; the extra unpaired condition is excluded from the main medians.

## Fresh measurements

| Model | Condition | Task | n | Median seconds | Effective output tokens/s | Median paired latency ratio |
|---|---|---|---:|---:|---:|---:|
| 35b | combined | agentic | 3 | 471.06 | 0.51 | 1.150× |
| 35b | combined | one_shot | 3 | 466.70 | 0.69 | 1.146× |
| 35b | quiet | agentic | 3 | 417.75 | 0.57 | — |
| 35b | quiet | one_shot | 3 | 416.22 | 0.78 | — |
| 9b | browser | agentic | 3 | 13.71 | 19.18 | 1.103× |
| 9b | browser | one_shot | 3 | 8.99 | 29.24 | 1.235× |
| 9b | combined | agentic | 3 | 13.39 | 19.64 | 1.078× |
| 9b | combined | one_shot | 3 | 8.26 | 31.84 | 1.152× |
| 9b | fault | agentic | 3 | 12.11 | 21.73 | 1.035× |
| 9b | fault | one_shot | 3 | 7.13 | 36.88 | 1.073× |
| 9b | game | agentic | 3 | 12.49 | 21.05 | 1.069× |
| 9b | game | one_shot | 3 | 8.24 | 31.91 | 1.066× |
| 9b | gpu | agentic | 3 | 49.35 | 5.33 | 4.327× |
| 9b | gpu | one_shot | 3 | 32.89 | 8.00 | 4.648× |
| 9b | quiet | agentic | 3 | 12.43 | 21.16 | — |
| 9b | quiet | one_shot | 3 | 7.28 | 36.11 | — |
| 9b | video | agentic | 3 | 11.77 | 22.35 | 1.032× |
| 9b | video | one_shot | 3 | 7.16 | 36.74 | 0.982× |

Effective throughput counts every generated action/recovery token and includes full task time, including prefill and source calls. Decode throughput is separately retained in the CSV. Loading and warmup are excluded from task latency. Ratios are paired within repetition; ranges are observed sample spread, not p95 or confidence intervals.

## Work and output quality

- 9b: 42 completed workloads; 36/36 pairs match task prompts, generated-token counts and final answer. 0/42 meet the 180–230-word target; 21/42 pass the format-tolerant source-ID/read check.
  Unread source IDs in final answers: S5. The original bracket-only runtime gate missed alternate citation formatting; timed behavior is preserved and failures are reported.
- 35b: 12 completed workloads; 6/6 pairs match task prompts, generated-token counts and final answer. 6/12 meet the 180–230-word target; 12/12 pass the format-tolerant source-ID/read check.

Manual review of the first fresh 35B quiet agent answer: it omits the requested frontier-policy comparison and contains only 127 words. Its timing is retained as completed inference, not successful completion of the research request.

Mechanical completion, word count and citation checks are not factual-quality validation. The 35B runtime is a custom paged Metal path, not native NVIDIA NVFP4 or proof of full-model backend parity.

## Resource observations

The following host counters cover loading, warmup and both tasks for each condition; they are not per-task attribution. Swap/page-in units are VM page equivalents, not physical SSD byte traces. Thermal state is macOS pressure status (0 nominal, 1 fair, 2 serious, 3 critical), not degrees Celsius.

| Model | Rep | Condition | Swap-outs MiB | Minimum available GiB | Maximum thermal state | Completed |
|---|---:|---|---:|---:|---:|---|
| 9b | 1 | browser | 1164.5 | 2.25 | 0 | True |
| 9b | 1 | combined | 1150.1 | 2.51 | 0 | True |
| 9b | 1 | fault | 0.0 | 2.99 | 1 | True |
| 9b | 1 | game | 0.0 | 3.15 | 0 | True |
| 9b | 1 | gpu | 0.0 | 2.41 | 1 | True |
| 9b | 1 | quiet | 0.0 | 2.69 | 0 | True |
| 9b | 1 | video | 0.0 | 2.62 | 0 | True |
| 9b | 2 | browser | 887.3 | 3.05 | 1 | True |
| 9b | 2 | combined | 848.2 | 2.90 | 1 | True |
| 9b | 2 | fault | 0.0 | 3.09 | 1 | True |
| 9b | 2 | game | 0.0 | 3.63 | 1 | True |
| 9b | 2 | gpu | 0.0 | 3.23 | 1 | True |
| 9b | 2 | quiet | 0.0 | 3.64 | 1 | True |
| 9b | 2 | video | 0.0 | 3.32 | 1 | True |
| 9b | 3 | browser | 473.6 | 2.96 | 1 | True |
| 9b | 3 | combined | 537.1 | 3.39 | 1 | True |
| 9b | 3 | fault | 0.0 | 3.66 | 1 | True |
| 9b | 3 | game | 0.0 | 3.23 | 1 | True |
| 9b | 3 | gpu | 0.0 | 4.10 | 1 | True |
| 9b | 3 | quiet | 0.0 | 3.40 | 1 | True |
| 9b | 3 | video | 0.0 | 3.11 | 1 | True |
| 35b | 1 | combined | 0.0 | 3.08 | 0 | True |
| 35b | 1 | quiet | 0.0 | 4.46 | 0 | True |
| 35b | 2 | combined | 61.2 | 2.73 | 0 | True |
| 35b | 2 | quiet | 0.0 | 4.23 | 0 | True |
| 35b | 3 | combined | 691.0 | 2.97 | 0 | True |
| 35b | 3 | quiet | 0.0 | 3.24 | 0 | True |

## Retained cloud and 4B data

The page retains the preceding cloud and 4B campaigns unchanged, with an explicit campaign field in combined downloads. Cloud cache/reasoning variation remains a confound; controlled trace replay and fresh autonomous agents remain separate. No earlier 9B/35B sample enters a new larger-model median.

## Cleanup

Inter-condition pause: User requested publishing 9B first; pause between 35B conditions to avoid rendering during timed inference. Duration: 144.26458096504211 seconds. No timed workload was suspended.
Inter-condition pause: User requested all seven 9B cases; pause between 35B conditions for a fresh complete 9B matrix. Duration: 1239.4354531764984 seconds. No timed workload was suspended.
Removed 58.50 GB of newly downloaded/repacked models and temporary files. Owned benchmark workers remaining: 0. Final recorded thermal state: 0. Raw evidence and the reusable original environment remain.

See PROTOCOL.md and artifacts/{runs,steps,pairs,summary,resources}.csv for the fresh campaign, and artifacts/publication-analysis.json for the explicitly tagged combined publication dataset.
