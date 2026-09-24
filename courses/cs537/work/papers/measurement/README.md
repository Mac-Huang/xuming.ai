# VM and Filesystem Pressure Benchmark

This project measures how controlled operating-system pressure affects local small-model inference latency on a single machine. It uses Ollama for the foreground workload and Python worker processes for background pressure.

## What it does

- Runs repeated inference requests against a local Ollama model with a fixed prompt.
- Applies one of four background conditions:
  - `none`
  - `file_seq`
  - `mmap_random`
  - `anon`
- Records per-request latency and per-run system/process counters.
- Writes raw CSV files, plots, and a markdown summary.
- Supports a fast pilot mode and resumable experiment runs.

## Requirements

- Python 3.9+
- Ollama installed and running locally
- A small Ollama model already available, for example `qwen2.5:3b`

Install dependencies:

```bash
pip install -r requirements.txt
```

Make sure Ollama is running and the chosen model is present:

```bash
ollama list
ollama serve
```

## Run

Pilot mode:

```bash
python3 src/main.py --pilot
```

Full run:

```bash
python3 src/main.py
```

Useful overrides:

```bash
python3 src/main.py --model qwen2.5:3b
python3 src/main.py --host 127.0.0.1 --port 11434
python3 src/main.py --force
```

## Output

Raw data:

- `results/raw/inference_runs.csv`
- `results/raw/system_runs.csv`

Plots:

- `results/plots/latency_by_condition.png`
- `results/plots/p95_latency_by_condition.png`
- `results/plots/faults_by_condition.png` when supported data exists
- `results/plots/io_by_condition.png` when supported data exists

Summary:

- `results/summary.md`

Logs:

- `results/logs/run_*.log`

## Cross-platform notes

- The benchmark prefers `psutil` and the standard library.
- Detailed minor and major page-fault counters are not uniformly available on every OS.
- Linux uses `/proc/<pid>/stat` for per-process minor and major faults.
- Windows exposes total page-fault counts through the Win32 process API, but not a minor/major split.
- On other Unix-like systems, fault counters may be partial or unavailable, and the project records null values instead of failing.

## Safety model

- Anonymous-memory pressure is capped by a configurable safe fraction of RAM.
- File-backed pressure is capped by available disk space and logged honestly when reduced.
- Runs continue across condition failures whenever possible.
- Existing completed runs are skipped unless `--force` is passed.

## Project layout

```text
project_root/
  README.md
  requirements.txt
  config/
    default.yaml
  src/
    main.py
    config.py
    inference_client.py
    pressure_file_seq.py
    pressure_mmap_random.py
    pressure_anon.py
    pressure_manager.py
    metrics.py
    runner.py
    analysis.py
    utils.py
  data/
    pressure_data.bin
  results/
    raw/
    plots/
    logs/
```
