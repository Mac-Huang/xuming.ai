# FP16 MHA-to-NPU compute-only bound at W=2048

- Measured GPU E2E: **0.9464 s** for 2048 prefill tokens + 32 fixed decode calls.
- Fused GPU MHA compute across 24 layers: **81.703 ms**.
- NPU compute-only MHA across 24 layers: **102.937 ms** (4.289 ms/layer).
- Zero-switch compute bound: **0.9677 s**, **+2.24%** latency versus GPU.

This is not a measured hybrid. It excludes every device-boundary and data-movement cost. The isolated 2K MHA wall-time affinity does not survive after the GPU comparison is restricted to the MHA compute that remains inside the fused full model.
