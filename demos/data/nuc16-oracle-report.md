# NUC16 four-case overhead-free phase oracle

## Definition

- Whole iGPU and whole NPU are real, stateful end-to-end measurements.
- NPU prefill + iGPU decode is `whole-NPU prefill + whole-iGPU decode`.
- iGPU prefill + NPU decode is `whole-iGPU prefill + whole-NPU decode`.
- Transfer, synchronization, recompilation, KV-cache/state conversion, and all other boundary overhead are fixed to zero.
- The two split routes are therefore analytical upper bounds, not executable token-producing paths.

The report contains 192 model/window/precision/route cells, 288 measured source trials, and 288 composed trial rows.
Source failures: 0. Unavailable composed rows: 0.

## Optimal-route frequency across 24 model/window cells per precision

| Precision | Route | Fastest E2E cells | Lowest-energy cells |
|---|---|---:|---:|
| INT8 | Whole iGPU | 17 | 12 |
| INT8 | Whole NPU | 4 | 12 |
| INT8 | NPU prefill + iGPU decode · oracle | 0 | 0 |
| INT8 | iGPU prefill + NPU decode · oracle | 3 | 0 |
| FP16 | Whole iGPU | 19 | 0 |
| FP16 | Whole NPU | 1 | 21 |
| FP16 | NPU prefill + iGPU decode · oracle | 3 | 0 |
| FP16 | iGPU prefill + NPU decode · oracle | 1 | 3 |

## 8K oracle optimum

| Precision | Model | Fastest route | E2E (s) | Speedup vs iGPU | Lowest-energy route | Energy (J) | Reduction vs iGPU |
|---|---|---|---:|---:|---|---:|---:|
| FP16 | Llama 3.2 1B | Whole iGPU | 5.182 | 1.00× | Whole NPU | 124.7 | +20.4% |
| FP16 | Llama 3.2 3B | Whole iGPU | 9.915 | 1.00× | Whole NPU | 296.4 | +13.8% |
| FP16 | Qwen2.5 0.5B | Whole iGPU | 3.238 | 1.00× | Whole NPU | 64.3 | +28.0% |
| FP16 | Qwen2.5 1.5B | Whole iGPU | 5.367 | 1.00× | Whole NPU | 145.3 | +18.0% |
| FP16 | Qwen2.5 3B | Whole iGPU | 9.252 | 1.00× | Whole NPU | 276.9 | +13.1% |
| FP16 | Qwen2.5 7B | Whole iGPU | 16.528 | 1.00× | iGPU prefill + NPU decode · oracle | 587.2 | +4.8% |
| INT8 | Llama 3.2 1B | Whole iGPU | 4.121 | 1.00× | Whole iGPU | 119.5 | +0.0% |
| INT8 | Llama 3.2 3B | Whole iGPU | 8.142 | 1.00× | Whole iGPU | 269.4 | +0.0% |
| INT8 | Qwen2.5 0.5B | iGPU prefill + NPU decode · oracle | 4.696 | 1.18× | Whole NPU | 93.6 | +40.0% |
| INT8 | Qwen2.5 1.5B | iGPU prefill + NPU decode · oracle | 14.435 | 1.17× | Whole NPU | 268.2 | +42.9% |
| INT8 | Qwen2.5 3B | Whole NPU | 39.001 | 5.38× | Whole NPU | 625.4 | +85.9% |
| INT8 | Qwen2.5 7B | Whole iGPU | 12.362 | 1.00× | Whole iGPU | 438.6 | +0.0% |
