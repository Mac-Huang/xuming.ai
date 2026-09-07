# E2E chart audit — September 7, 2026

## What was wrong

The two plots used different experiments under the same labels. Their arithmetic reproduced their inputs, but they were **not an apples-to-apples comparison**. The older NPU W2048 value was 1.1815 s; the newer was 0.8403 s. Both are traceable to their saved runs, but only the latter belongs to the adopted comparison protocol. The difference is not merely run-to-run noise.

| Setting | Older three-bar plot | Newer four-series plot |
|---|---|---|
| Runtime | OpenVINO 2026.0.0 | OpenVINO 2026.3.0 |
| Actual prompt | W | W |
| NPU compiled max prompt | next power of two above W+32: 256/1024/2048/4096 | 128/512/1024/2048 |
| Latency | median(prefill) + 32 × median(decode step), from separate stages | median of complete requests, then median across processes |
| Warm-up | Prefill only; first decode outlier largely suppressed by median | A complete prompt + decode request |
| Repetitions | 5 prefills; one 32-step decode sequence | 3 processes × 5 complete timed requests |
| Energy | Separate stage-energy sum; 8.428 W idle | Separate 5-request windows per process; 8.617 W idle |
| Seed | 0; stages use different prompts | 20260903; identical inputs across systems |

The old probe treated the maximum **prompt** limit like total prompt-plus-decode capacity. NPUW has separate response/cache provisioning. This unnecessarily doubled the prompt limit at all four power-of-two prompts. The new protocol actually completed all 32 decode calls and passed the saved final-logit checks, so the smaller prompt limit did not silently truncate the request.

## Controlled reproduction: 60 new timed requests

I held the model, seeded 2048-token prompt, 32 decode inputs, timing code and properties constant, changing only the runtime and compiled prompt limit. Each cell used 3 fresh processes × 5 timed requests after 1 whole-request warm-up. Order was reversed/interleaved; compilation excluded. Existing background processes were left untouched, including a CPU busy loop; these controls are not substituted into the earlier energy campaign.

| Runtime | Compiled prompt limit | Request median (s) | Range of process medians (s) | Prefill median (s) |
|---|---:|---:|---:|---:|
| 2026.0.0 | 2048 | 0.8813 | 0.8781–0.8845 | 0.3416 |
| 2026.0.0 | 4096 | 1.1811 | 1.1773–1.1841 | 0.6229 |
| 2026.3.0 | 2048 | 0.8352 | 0.8345–0.8365 | 0.2957 |
| 2026.3.0 | 4096 | 0.8423 | 0.8412–0.8480 | 0.2994 |

This reproduces both endpoints. With 2026.0, reducing capacity removes most of the gap. With 2026.3, both capacities run near 0.84 s. There is a runtime × capacity interaction, so the total difference cannot be assigned to capacity alone or to a generic “faster NPU.” The control establishes configuration sensitivity, not the exact internal compiler pass responsible. All 12 control outputs passed the final-logit agreement gate against the same-input September 4 GPU reference.

## Canonical corrected data

Both plots now consume **one September 4 dataset**, using the same values and axis scales. The September 7 control remains separate. 48 accepted processes / 240 timed requests / 240 separate energy requests were re-audited: raw sample statistics, request decomposition, identical token arrays, configs, RAPL arithmetic, aggregation, and all final-logit files. This includes the all-GPU NPUW diagnostic control, which is not an extra chart series.

| Prompt W | System | Request (s) | Processed-input tokens/s | Net system J/request |
|---:|---|---:|---:|---:|
| 128 | GPU e2e | 0.4832 | 331.1 | 13.61 |
| 128 | NPU e2e (native NPUW) | 0.5433 | 294.5 | 9.13 |
| 128 | NPUW hybrid (prefill MHA on NPU) | 1.2392 | 129.1 | 35.34 |
| 512 | GPU e2e | 0.5765 | 943.6 | 16.18 |
| 512 | NPU e2e (native NPUW) | 0.5898 | 922.3 | 10.25 |
| 512 | NPUW hybrid (prefill MHA on NPU) | 1.3549 | 401.5 | 37.07 |
| 1024 | GPU e2e | 0.6846 | 1542.5 | 19.89 |
| 1024 | NPU e2e (native NPUW) | 0.6667 | 1583.9 | 12.25 |
| 1024 | NPUW hybrid (prefill MHA on NPU) | 1.5539 | 679.6 | 43.59 |
| 2048 | GPU e2e | 0.9464 | 2197.8 | 27.71 |
| 2048 | NPU e2e (native NPUW) | 0.8403 | 2475.2 | 16.28 |
| 2048 | NPUW hybrid (prefill MHA on NPU) | 1.8547 | 1121.5 | 57.81 |

The retained NPU W2048 baseline is **0.8403 s, 2475.2 processed-input tokens/s, 16.28 net system J/request**. GPU is 0.9464 s / 27.71 J; measured hybrid is 1.8547 s / 57.81 J. The fresh controls corroborate the NPU latency but are not fresh energy measurements.

## Why the green values were withdrawn

1. The old 2.50× MHA affinity used an incorrect-output GPU graph. The later 2.153× “compute” ratio was still built from `gpu_kernel_detail.csv`, whose generator reads `raw/gpu/timeline`, not the corrected `raw/mha_gpu_barrier/timeline_w2048` trace. Corrected standalone MHA wall-time evidence (1.55×) does not repair that compute trace or validate an E2E estimate.
2. The oracle combined historical block shares, isolated GPU/NPU traces and a newer full-model GPU anchor via scalar normalization. That does not reproduce a fused model, establish optimal routing, or supply same-runtime compute measurements for every block/window. At W≤1024 it simply copied the GPU baseline rather than computing a fresh optimum.
3. Excluding launch/layout/DMA from a replacement ratio does **not** remove those costs from the full-GPU anchor. The previous global “compute-only lower bound” wording was false.
4. Oracle energy was historical stage-average power × modeled time with an additional normalization. It is neither measured energy nor a validated energy lower bound. Latency alone cannot determine energy, and a latency-optimal route need not minimize energy.

The oracle slot is now **N/A / withdrawn**, never zero. Historical values remain in a clearly superseded archive. A replacement requires correctness-gated, same-runtime, same-shape fused-subgraph profiles with explicit compute/transfer coverage; energy additionally requires a justified power model or measurement. No numeric replacement is asserted in this correction.

## Metric and correctness limits

- “E2E” here means model forward calls, not a full text-generation service: W fixed prompt inputs + 32 teacher-forced decode inputs. Tokenization, sampling, reset, compilation and warm-up are outside the latency timer.
- Work throughput = **(W+32)/request time**. It is not generated-output tokens/s, steady decode rate, concurrency throughput, or hardware peak throughput.
- RAPL `psys` measures system energy, not NPU-only energy. Each energy window includes state reset and CPU output summaries; the latency timer excludes them. This existing scope difference is disclosed, not silently corrected by subtraction. Idle subtraction and background conditions affect cross-date energy comparisons.
- Whiskers are min–max across 3 process medians (energy: 3 process means), not confidence intervals. The request median and energy mean come from different request sets.
- Final-step logits only: minimum cosine 0.999743, maximum relative L2 0.02283, matching top-1 and top-5 sets. This is not all-position validation, a CPU-reference guarantee, an autoregressive-quality benchmark, or proof of true INT8.
- “FP16” identifies the model IR and the NPU precision hint; the GPU used its default inference-precision policy. It is not a claim that every internal operation ran FP16.
- Native “NPU e2e” already uses NPUW internally. The red bar differs by GPU-priority submodel routing and the prefill-MHA override, not by NPUW being absent/present. Outer `execution_devices=[NPU]` cannot prove inner placement. The W2048 explicit-mapping diagnostic supports that route; smaller-window logs do not independently pin every generate partition.

## Files and reproducibility

- `processed/e2e_four_way_fp16.csv`: single canonical comparison source; missing oracle fields intentional.
- `processed/e2e_three_way_fp16.csv`: exact subset, not another benchmark.
- `processed/validated_measurements.csv`, `correctness_audit.csv`, `audit_manifest.json`: accepted cells, gates, configs, source hashes.
- `processed/historical_vs_current.csv`: differences for all 8 shared GPU/NPU bars.
- `processed/capacity_runtime_control.csv`, `capacity_runtime_correctness.csv`, `capacity_runtime_provenance.json`: new factorial control.
- `controls/`: immutable copied control raw files, source, and system snapshots; original remote run is `2026-09-07_08-25-24_wuklab-NUC16_e2e-chart-audit`.

Scope: this audit corrects the two FP16 E2E comparisons. Other old operator, W8A16 and concurrency charts remain explicitly historical, not newly validated by this audit. Original raw data were not modified.
