# NUC16 FP16 GPU placement sweep

- 78 measured cells, 54 correctness-qualified, 24 rejected.
- OpenVINO AUTO and iGPU → iGPU: valid for all six models from 1K through 8K.
- iGPU → NPU: valid for all six models at 1K; incorrect for all 18 model/window groups from 2K through 8K.
- NPU + iGPU subgraph combination: incorrect for all six models at the 1K capability gate.

## 8K diagnostic medians

| Model | Placement | TTFT (s) | TPOT (ms) | E2E (s) | PSys energy (J) | Status |
|---|---|---:|---:|---:|---:|---|
| Qwen2.5 0.5B | OpenVINO AUTO (actual iGPU) | 2.865 | 23.01 | 3.256 | 91.0 | valid |
| Qwen2.5 0.5B | iGPU → iGPU | 2.857 | 22.79 | 3.238 | 89.2 | valid |
| Qwen2.5 0.5B | iGPU → NPU | 2.218 | 23.38 | 2.668 | 84.5 | rejected: wrong tokens |
| Qwen2.5 1.5B | OpenVINO AUTO (actual iGPU) | 4.624 | 48.20 | 5.381 | 177.4 | valid |
| Qwen2.5 1.5B | iGPU → iGPU | 4.599 | 48.57 | 5.367 | 177.1 | valid |
| Qwen2.5 1.5B | iGPU → NPU | 4.548 | 55.67 | 5.515 | 185.4 | rejected: wrong tokens |
| Qwen2.5 3B | OpenVINO AUTO (actual iGPU) | 7.719 | 98.86 | 9.256 | 319.9 | valid |
| Qwen2.5 3B | iGPU → iGPU | 7.706 | 99.44 | 9.252 | 318.8 | valid |
| Qwen2.5 3B | iGPU → NPU | 38.634 | 108.35 | 40.470 | 1145.1 | rejected: wrong tokens |
| Qwen2.5 7B | OpenVINO AUTO (actual iGPU) | 13.528 | 196.33 | 16.521 | 622.4 | valid |
| Qwen2.5 7B | iGPU → iGPU | 13.534 | 196.93 | 16.528 | 616.6 | valid |
| Qwen2.5 7B | iGPU → NPU | 63.897 | 224.27 | 67.450 | 1959.6 | rejected: wrong tokens |
| Llama 3.2 1B | OpenVINO AUTO (actual iGPU) | 4.485 | 44.51 | 5.189 | 159.1 | valid |
| Llama 3.2 1B | iGPU → iGPU | 4.476 | 44.18 | 5.182 | 156.7 | valid |
| Llama 3.2 1B | iGPU → NPU | 5.260 | 47.48 | 6.134 | 178.5 | rejected: wrong tokens |
| Llama 3.2 3B | OpenVINO AUTO (actual iGPU) | 8.412 | 99.62 | 9.937 | 340.2 | valid |
| Llama 3.2 3B | iGPU → iGPU | 8.394 | 99.45 | 9.915 | 343.9 | valid |
| Llama 3.2 3B | iGPU → NPU | 10.034 | 123.32 | 12.252 | 380.4 | rejected: wrong tokens |
