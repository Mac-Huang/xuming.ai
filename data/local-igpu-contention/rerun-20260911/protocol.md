# Clean rerun — 2026-09-11

This new campaign preserves prior results; it does not overwrite or pool them. The initial cloud plot mixed medians and hid cached-input and reasoning variation. The correction reports individual pairs and observed work explicitly.

## Cloud

Model remains GPT-6 Astra, high reasoning, through the signed-in installed Codex CLI. Six quiet/combined pairs; fixed condition order Q/C, C/Q, C/Q, Q/C, Q/C, C/Q; task order alternates. Same frozen robotics corpus as the original run. A new short closed-corpus system instruction replaces the default coding-agent instruction. A random 32-digit spaced marker has fixed token structure and precedes that instruction; the actual reported cache count is authoritative. The pilot showed a shared internal prefix can still be cached.

One-shot reuses the original one-shot prompt. The controlled agent experiment replays the five exact prompts and associated images from original cloud r0 quiet, so task-prompt bodies, images, source history and call count cannot change between conditions. The random instruction marker deliberately differs; full request bytes are not identical. Generated intermediate outputs are recorded but do not rewrite later prompts. Label this **agent trace replay**, not a fresh autonomous-agent trajectory or an equal-quality task-success comparison. The trace comes from an actual earlier agent trajectory. Service-side reasoning and output still vary; they are measured, not assumed fixed.

Record input, cached input, output, reasoning output, visible output (=output minus reasoning), elapsed time, prompt hash, tool-use violations, and exit status per call. No raw API TTFT/decode-speed claim. Effective visible-token throughput is sum visible output tokens divided by full task time, including client/service overhead, reasoning, prefill and sequential calls. Report reasoning separately. A cache-matched pair requires identical per-step input and cached-input counts; an exact generated-work pair additionally requires equal per-step output and reasoning counts. All complete pairs remain visible, with match flags, regardless of speed direction. No post-hoc replacement of inconvenient pairs. No ratio of independent group medians as the paired effect.

A supplementary fresh autonomous-agent series has three quiet/combined pairs (Q/C, C/Q, Q/C), using the original dynamic source-choice loop and the same cloud controls. Its output/path variation is reported separately from trace replay.

No model download, local inference, synthetic stress outside the assigned contender, or heavy page rendering occurs during measured cloud runs. Quiet retains user applications and a benchmark browser reference window; no personal application is closed. Contenders start before timing and remain alive throughout. Eight-second inter-trial idle, five seconds after first contender telemetry; nominal thermal preflight. This is a working laptop, not a guaranteed idle laboratory host.

## Local

Fresh one-shot and actual bounded agent runs use the original corpus, eight-call gate and output parser. Three repetitions per condition, forward/reverse/forward condition order; task order alternates. 4B covers quiet, video, browser, game proxy, combined, heavy Metal compute and 4 GiB read-only file remapping. Unless expanded by the user, 9B and 35B cover quiet and combined desktop load. Larger-model resource failures are retained as stopped trials and plotted as missing/censored inference, never zero throughput.

All models use native Metal with greedy decoding, seed 42, 128-token prefill chunks, 128 MiB allocator cache and two identical vision warmups with a 32-token cap before timing. Model loading and contender startup are separate phases. Fresh process per condition. This differs from the earlier 4B 512-token prefill setup; only new paired controls define new slowdowns. 4B/9B use pinned affine 4-bit MLX conversions. 35B uses the pinned official NVFP4 checkpoint, prior scale-preserving custom adapter, BF16 dense matrices, all experts on disk and a 0.5 GB expert cache. It is not native NVIDIA execution.

Local effective generated-token throughput = sum generated tokens / full task time, including source actions, prefill and recovery. Also report aggregate decode throughput as sum generated tokens / sum(tokens / per-call reported decode rate), not the unweighted mean of call rates. Prompt/output/path hashes and quality checks determine whether each local pair actually performed identical work.

The OS file cache is not forcibly cleared. Fresh processes and identical warmups control model initialization, but do not guarantee identical system-wide file-cache state. In particular, the paged 35B measurements include expert access and cache management; they cannot isolate pure GPU compute or SSD bandwidth alone.

## Resource bounds and cleanup

A new campaign has an explicitly recorded start counter; the previous completed campaign's counters are retained separately. Bound this rerun to 2 GiB cumulative additional host swap writes and 512 MiB per guarded process. Sample about every 0.2 seconds; stop below 768 MiB available, below 1.5 GiB for one second, serious/critical thermal state, AC loss, or wall-clock ceiling. Thresholds can overshoot between samples. Require nominal thermal state and at least 3 GiB estimated available before starting; wait at most five minutes for cooling. No OS protection/clock/fan changes or clearing system swap/cache.

Stop an unsafe configuration instead of repeating it to fill a graph. Retry only after a concrete change resolves the observed failure; preserve the failed attempt and keep changed configurations separate. Remove only new downloaded/repacked weights and disposable fixtures after verification; retain evidence and the original 4B environment.

Preparation note: 9B and 35B downloads overlap each other only after all cloud timing ends. Local timing is held until both downloads and hash checks finish. A child-free held local supervisor was restarted before its first inference to load improved descendant-process cleanup. This discarded no measured workload. Downloaded files are explicitly synced; the file-remapping fixture is synced before local trials.

Pre-35B admission decision: the first new 4B combined trial recorded 455,344,128 host swap-out bytes (434.25 MiB), below the 512 MiB stop trigger. Before any 35B trial, its planned expert cache was reduced from 2 to 0.5 GB for every condition. Prefill/warmup and all model experts remain unchanged. This is a new cache configuration; the earlier 2 GB-cache 35B timings are not pooled with it.

Pinned models: 4B MLX `7c3327a5765ab21cefe2d91e953d1038b1d3ef3e`; 9B MLX `0e53bd10ed5a8c048c38ff4883d74f008b63834e`; official 35B NVFP4 `76ebefd59b500fe55e1afa45995aa8553198ee6e`. Local actions have a 768-token cap. Codex CLI does not expose the same fixed generation limit here; the requested word range does not guarantee equal output or reasoning work.

Secondary answer audit: normalize standalone source IDs across brackets, parentheses and plain text. The original runtime gate recognizes only `[S#]`, so alternate citation syntax can evade its unread-source check. Preserve the original timed behavior and report secondary citation/word-count failures instead of retroactively calling these successful research answers. After a combined-load admission failure, safe quiet baselines may still be completed; the failed configuration is not repeatedly stressed.

Contender audit: local and fresh autonomous tasks retain explicit wall-clock task boundaries. The controlled cloud replay runner retains monotonic task durations but did not log those wall-clock boundaries; its contender check instead verifies advancing frame/callback counts in every consecutive sample throughout each trial. All such cloud intervals advanced. This sampling check is not a presentation-FPS measurement.
