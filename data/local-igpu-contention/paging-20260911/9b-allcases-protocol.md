# Full 9B contention matrix

This extension responds to the request to show all 9B cases. It reruns three repetitions of all seven conditions: quiet, video, browser, game/WebGL, combined, heavy GPU, and 4 GiB file remapping. Each condition executes both one-shot and agentic workloads. It uses the same pinned 9B model, frozen source corpus, greedy decoding, token limits, 128-token prefill, 128 MiB cache and warmups as paging_rerun_20260911. Forward/reverse/forward condition order and alternating task order are retained.

Both custom thermal and swap-volume stop conditions remain removed. Existing AC-power, available-memory and six-minute condition duration checks remain. Model downloads are reused by a temporary symlink; no weights are downloaded during inference. The 4 GiB remapping file is created and flushed before the campaign starts. File remapping produces per-process faults; disk I/O and VM swapping are measured, not assumed.

The earlier 9B quiet/combined-only campaign remains preserved. Only this complete fresh matrix supplies the final 9B graphs. The 35B supervisor is paused between completed conditions while this matrix runs, then resumes. All campaign boundaries and remaining controls are disclosed.
