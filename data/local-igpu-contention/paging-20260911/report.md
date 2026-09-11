# Completed 9B rerun — September 11, 2026

Interim publication: all three 9B quiet/combined pairs are complete. The 35B rerun is still in progress and is excluded from this interim comparison. Model-file cleanup is deferred until the remaining 35B measurements finish.
The custom thermal and swap-volume stop conditions were removed at the user’s request. macOS thermal pressure and swap volume remain observations. Native macOS protections, AC-power, minimum-available-memory and duration checks remain. This does not equate swap activity with temperature or a hardware damage threshold.

Fresh quiet/combined pairs use the same pinned models, corpus, prompts, greedy decoding, 128-token prefill, 128 MiB allocator cache and identical warmups. The 35B custom Metal adapter retains the 0.5 GB expert cache and all model experts. The earlier aborted attempts are archived, not pooled.

## Fresh measurements

| Model | Condition | Task | n | Median seconds | Effective output tokens/s | Median paired latency ratio |
|---|---|---|---:|---:|---:|---:|
| 9b | combined | agentic | 3 | 13.04 | 20.17 | 1.163× |
| 9b | combined | one_shot | 3 | 8.47 | 31.07 | 1.270× |
| 9b | quiet | agentic | 3 | 11.16 | 23.56 | — |
| 9b | quiet | one_shot | 3 | 6.55 | 40.16 | — |

Effective throughput counts every generated action/recovery token and includes full task time, including prefill and source calls. Decode throughput is separately retained in the CSV. Loading and warmup are excluded from task latency. Ratios are paired within repetition; ranges are observed sample spread, not p95 or confidence intervals.

## Work and output quality

- 9b: 12 completed workloads; 6/6 pairs match task prompts, generated-token counts and final answer. 0/12 meet the 180–230-word target; 6/12 pass the format-tolerant source-ID/read check.
  Unread source IDs in final answers: S5. The original bracket-only runtime gate missed alternate citation formatting; timed behavior is preserved and failures are reported.


Mechanical completion, word count and citation checks are not factual-quality validation. The 35B runtime is a custom paged Metal path, not native NVIDIA NVFP4 or proof of full-model backend parity.

## Resource observations

The following host counters cover loading, warmup and both tasks for each condition; they are not per-task attribution. Swap/page-in units are VM page equivalents, not physical SSD byte traces. Thermal state is macOS pressure status (0 nominal, 1 fair, 2 serious, 3 critical), not degrees Celsius.

| Model | Rep | Condition | Swap-outs MiB | Minimum available GiB | Maximum thermal state | Completed |
|---|---:|---|---:|---:|---:|---|
| 9b | 1 | combined | 1876.4 | 2.75 | 0 | True |
| 9b | 1 | quiet | 0.0 | 2.79 | 0 | True |
| 9b | 2 | combined | 18.3 | 3.12 | 0 | True |
| 9b | 2 | quiet | 0.0 | 4.10 | 0 | True |
| 9b | 3 | combined | 270.2 | 3.36 | 0 | True |
| 9b | 3 | quiet | 0.0 | 4.06 | 0 | True |

## Retained cloud and 4B data

The page retains the preceding cloud and 4B campaigns unchanged, with an explicit campaign field in combined downloads. Cloud cache/reasoning variation remains a confound; controlled trace replay and fresh autonomous agents remain separate. No earlier 9B/35B sample enters a new larger-model median.

## Cleanup

Cleanup pending while measurements are active.

See PROTOCOL.md and artifacts/{runs,steps,pairs,summary,resources}.csv for the fresh campaign, and artifacts/publication-analysis.json for the explicitly tagged combined publication dataset.
