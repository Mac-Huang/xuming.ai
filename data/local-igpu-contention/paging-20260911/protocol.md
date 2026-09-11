# Paging rerun — September 11, 2026

The user explicitly requested removal of both custom temperature and swap-volume stops, followed by rerunning and publishing. This campaign does not overwrite the earlier guarded trials.

## What changes

- Remove the custom thermal-state abort, thermal admission check and thermal preflight wait.
- Remove both per-trial and cumulative swap-volume aborts. Swap activity is measured, not capped.
- macOS's built-in thermal and memory protections remain unchanged.
- Retain AC-power checks and available-memory admission/stop checks: at least 3 GiB available before launch; stop below 768 MiB, or below 1.5 GiB for one second. These are responsiveness safeguards, not temperature measures.
- Bound each 9B condition to six minutes and each 35B condition to sixty minutes, including setup. The 35B ceiling is extended from the previous thirty minutes to admit slower paged execution.

## Matched work

Fresh quiet/combined pairs for Holo 3.1 9B and 35B-A3B NVFP4, three repetitions each, condition orders Q/C, C/Q, Q/C. Alternate one-shot/agentic order by repetition. A new process and two identical vision warmups (32-token cap) precede each condition. Retain the original frozen robotics corpus, screenshots, eight-call agent loop, 768-token action limit, greedy decoding, seed 42, 128-token prefill chunks and 128 MiB allocator cache. Record every attempt and compare per-step prompt hashes, generated-token counts and final answers. Do not pool failed or differently configured trials into a latency median.

9B remains the affine 4-bit MLX conversion pinned at `0e53bd10ed5a8c048c38ff4883d74f008b63834e`. 35B remains the official checkpoint pinned at `76ebefd59b500fe55e1afa45995aa8553198ee6e`, through the same scale-preserving Metal adapter, BF16 dense matrices, disk-backed experts and 0.5 GB expert cache. All 40 layers and 256 experts per layer are retained. It is not native NVIDIA NVFP4 execution or proof of full-model backend quality parity. Download hashes and the sampled numeric check are verified again.

Quiet retains existing user applications plus the small reference browser window. Combined adds local 1080p60 video, eight active DOM/scrolling tabs and synthetic WebGL. No downloads, model preparation or page rendering overlap timed inference. OS file caches are not forcibly cleared. Paged-model latency includes expert access and CPU cache management, and cannot isolate pure GPU compute or SSD bandwidth.

## Metrics and interpretation

Report per-run latency, median and observed range, effective output tokens/s (all generated action/recovery tokens divided by full task duration), and separately aggregated decode tokens/s. Report paired ratios, not ratios of group medians. Include swap counters, thermal readings and available memory as observations. VM swap counters are page equivalents, not physical SSD bytes written. Record stop reasons accurately if another limit is reached; do not label missing data as zero.

The original runtime citation gate recognizes only bracketed source IDs. Preserve timed behavior and use a separate format-tolerant citation audit; answer length and citations alone are not factual-quality validation. The earlier 9B unread-source failure and 35B incomplete answer are not silently treated as successful research.

The already-published cloud and 4B measurements remain separate, unchanged campaigns. Their sample sizes, controls and cloud cache/reasoning confounds remain visible. Only new 9B/35B pairs define the new larger-model comparisons.

## Cleanup and publishing

Stop owned workers and remove newly downloaded/repacked model files after measurements. Preserve raw results, numeric checks, source hashes and reports. Publish the new comparisons to the existing xuming.ai page, with links to the previous guarded campaign and its recorded setup aborts.
