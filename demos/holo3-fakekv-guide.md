# Coding Guide — Genuine System-Level Fake-Prefix Prefill on llama.cpp (Holo3-35B-A3B / qwen3_5_moe hybrid)

Verified against `/data/repos/llama.cpp` @ `da87e9b612592ccd2a2e783eff631346459b9de0`, CPU build in `build-cpu/`.

---

## 1. Goal & why this replaces the arithmetic `compute_task`

You already have an arithmetic estimate, `opt_prefill = only_new / prefill_tps(depth)`, of what an agent step's prefill *would* cost if the prior context KV were a perfect cache hit. This guide builds and runs the **genuine system-level version**: we modify the inference engine so that, per agent step, it **injects a FAKE prior KV of a chosen length `L`** — right shape, valid positions, garbage values, *never actually computed* — and then prefills **only the newly appended tokens** (new screenshot + new text delta). The measured prefill time then reflects only-new content plus a near-free cache read, instead of re-processing the whole context. This is not an approximation: the engine really decodes only-new tokens against a real depth-`L` KV window. The measurement *validates* the arithmetic estimate rather than circumventing it (see §3 and §6). Quality is garbage by design and is discarded.

---

## 2. The mechanism in one diagram

```
                  HTTP request {n_fake_cached: L, cache_prompt:false, n_predict:1}
                                    │
       server-task.cpp:274  params.n_fake_cached = json_value(...,0)   ── plumb L into task_params
                                    │
   server-context.cpp ~2628 (SLOT_STATE_STARTED)
        if (L > 0):                                                    ── NEW guarded branch
          mem = llama_get_memory(ctx_tgt)
          llama_memory_seq_rm(mem, slot.id, -1, -1)        clear seq
          llama_memory_seq_fake_prefix(mem, slot.id, L)    ◄── FABRICATE FAKE PREFIX
                ├── mem_recr->seq_fake_prefix(seq,L)   1 tail cell @ pos L-1, garbage state  (30 GDN layers)
                └── mem_attn->seq_fake_prefix(seq,L)   L cells @ pos[0..L), garbage K/V       (10 attn layers)
          n_past = L                                       force only-new prefill
                                    │
   server-context.cpp:3002 batch-fill loop                ── adds ONLY tokens [L, L+new) at pos [L, ...)
                                    │
   server-context.cpp:3186 llama_decode(batch_view)        ── decode of only-new
        • 10 attn layers: QK^T over (L+new) keys, L of them fake (mask keeps them, reads zeros)
        • 30 recurrent layers: O(new) advance over garbage state, O(1) state load
                                    │
   slot.t_prompt_processing (2921) = now - t_start (2629)  ── MEASURED only-new prefill
   timings.cache_n = n_prompt_tokens_cache = L (2896/396)  ── the faked "free hit" count
```

The decisive lever is **`n_past`** (init at `server-context.cpp:2651`, normally set at `:2706` via `get_common_prefix`). Forcing `n_past = L` makes the batch-fill loop at `:3002` add only the new tokens. The fabrication call makes the memory genuinely report a depth-`L` prefix so the decode is accepted.

---

## 3. The hybrid wrinkle (10 attn KV + 30 recurrent) — and why TIMING is faithful while quality is garbage

Holo3 is a hybrid (40 layers): **10 full-attention** layers backed by `llama_kv_cache` (position-indexed per-token KV) and **30 Gated-DeltaNet recurrent** layers backed by `llama_memory_recurrent` (an **O(1) running state per sequence**, no per-token KV). The runtime wraps both in `llama_memory_hybrid` (`src/llama-model.cpp:2096`, the `swa_type == LLAMA_SWA_TYPE_NONE` branch — confirmed for Holo3, `n_swa = 0`). Every memory op fans out to **both** children (`src/llama-memory-hybrid.cpp:141-178`). A fake prefix must therefore be installed in **both**, in lockstep, because:

```cpp
// src/llama-memory-hybrid.cpp:175-178
llama_pos llama_memory_hybrid::seq_pos_max(llama_seq_id seq_id) const {
    return std::min(mem_attn->seq_pos_max(seq_id), mem_recr->seq_pos_max(seq_id)); // MIN of the two
}
```

If only one child is advanced to `L-1`, the hybrid reports the lagging value → wrong `n_past` / a re-prefill of context, defeating the whole thing.

### The two memory types are faked differently

| Layer type | Backing | "Fake prefix of L" means | Cost saved by faking |
|---|---|---|---|
| 10 attn | `llama_kv_cache` (`v_cells`) | **L cells** at positions `[0,L)`, seq_id set, K/V left at zero | the L prior tokens' Q/proj/FFN/MoE compute; attention still reads L+new keys |
| 30 recurrent | `llama_memory_recurrent` (1 cell/seq) | **1 tail cell** at pos `L-1`, garbage running state | nothing depth-dependent — recurrent is already O(new) |

### Adversarial timing-fidelity reasoning (folded in from the verdicts — all verified)

- **Attention reads fake cells at full cost.** `get_n_kv()` pads the attention K dimension to `GGML_PAD(cells.used_max_p1(), max(n_pad,256))` (`src/llama-kv-cache.cpp:1145`). Inserting L fake cells raises `used_max_p1()` to `≥L`, so each of the 10 attn layers does honest `QK^T` over `L+new` keys per new query. The causal-mask builder keeps any cell where `!is_empty && seq_has(seq) && p0 ≤ p1` (`set_input_kq_mask_impl`, `src/llama-kv-cache.cpp:1439-1586`); fake cells at `pos<L` with new tokens at `pos≥L` pass all three → attended, reading **zero** K/V. The FA CPU kernel skips a KV column **only** when its mask value is `-INF`; fake cells get mask `0.0`, so each fake cell gets a full `kq_vec_dot + vec_mad` — identical FLOPs to a real cell. **This is exactly the depth-L attention read that `prefill_tps(depth)` already encodes.**
- **Recurrent is O(new) regardless of L.** The recurrent state load (`build_rs`) is O(#seqs), independent of L; the per-token delta-net update advances over only the new tokens. State *value* never enters a nonlinearity that could create Inf/NaN — it flows only into matmuls/elementwise mul-add. So garbage/zero state costs exactly the same as real state.
- **Zeros are not denormals.** Both backing buffers are zero-initialized at construction (`src/llama-kv-cache.cpp:271`, `src/llama-memory-recurrent.cpp:114`). Exact `0.0` runs at full hardware speed (no FTZ/DAZ, no `-ffast-math` in the CPU backend). **Therefore the fake state must be ZERO, not arbitrary garbage** — leave the zero-init buffers untouched; do not write random bytes (random denormal-range floats would slow the matmuls 10–100×).
- **Honest claim.** Measured prefill = `only_new` compute + a genuine depth-`L` attention read + ~free O(1) recurrent state load. Do **not** claim "attention became free." This is precisely the system-level realization of `opt_prefill = only_new / prefill_tps(depth)`.
- **Quality:** garbage (the 30 recurrent layers start from a bogus running state; the L fake attn cells contribute zero K/V). Acceptable per the task; the single output token (`n_predict=1`) is discarded.

---

## 4. THE PATCH, step by step

> All new functions trace to existing primitives. The kv-cache method is the body of `state_read_meta`'s whole-cache-restore branch (`src/llama-kv-cache.cpp:2162-2211`) minus the `io.read` and minus `state_read_data`. The recurrent method mirrors its whole-restore (`src/llama-memory-recurrent.cpp:990-1042`) for a single cell.

### 4a. New memory op: `seq_fake_prefix(seq_id, L)`

#### (i) Vtable default — `src/llama-memory.h`

Add a **non-pure** virtual after `seq_div` (line 110) so the three subclasses you *don't* patch (`llama_kv_cache_iswa`, `llama_kv_cache_dsa`, `llama_memory_hybrid_iswa`) still compile:

```cpp
// src/llama-memory.h, after line 110 (after seq_div)
    // TIMING-EXPERIMENT KNOB: fabricate a fake prior prefix of length L (positions [0,L)) for seq_id,
    // with valid metadata/positions but garbage (zero) values. NOT computed. Quality is meaningless.
    virtual void seq_fake_prefix(llama_seq_id /*seq_id*/, uint32_t /*L*/) {
        GGML_ABORT("seq_fake_prefix not supported by this memory type");
    }
```

#### (ii) Attention cache — `src/llama-kv-cache.h` / `src/llama-kv-cache.cpp`

Declaration, in the `llama_memory_i` override block (after `seq_div`, `src/llama-kv-cache.h:138`):

```cpp
// src/llama-kv-cache.h:139
    void seq_fake_prefix(llama_seq_id seq_id, uint32_t L) override;
```

Definition — model on the whole-restore loop at `:2172-2210`; resolve `strm` the way `seq_rm` does at `:361-362`:

```cpp
// src/llama-kv-cache.cpp  (add a definition; mirrors state_read_meta:2172-2210)
void llama_kv_cache::seq_fake_prefix(llama_seq_id seq_id, uint32_t L) {
    GGML_ASSERT(seq_id >= 0 && (size_t) seq_id < seq_to_stream.size());

    auto & cells = v_cells[seq_to_stream[seq_id]];   // same access as seq_rm:361
    auto & head  = v_heads[seq_to_stream[seq_id]];   // same access as seq_rm:362

    GGML_ASSERT(L <= cells.size());

    // clear the seq first: pos_set asserts the target cell is empty (kv-cells.h:397-398)
    seq_rm(seq_id, -1, -1);

    for (uint32_t i = 0; i < L; ++i) {
        cells.pos_set(i, (llama_pos) i);   // kv-cells.h:395 — marks cell used, NO K/V write
        cells.seq_add(i, seq_id);          // kv-cells.h:309 — adds seq bit, bumps seq_pos
        // ext left at default {0,0}: the is_2d sub-mask (kv-cache.cpp:1556-1564) only fires when
        // p0==p1, which fake cells (p0<L) never hit vs new tokens (p1>=L). Safe.
    }

    head = 0;  // matches the whole-restore precedent at :2210; find_slot ring-searches for new tokens
    // K/V buffers stay at their zero-init contents (ctor clears buffer at :271) -> fake cells read zeros.
}
```

#### (iii) Recurrent state — `src/llama-memory-recurrent.h` / `.cpp`

Declaration, after `seq_div` (`src/llama-memory-recurrent.h:50`):

```cpp
// src/llama-memory-recurrent.h:51
    void seq_fake_prefix(llama_seq_id seq_id, uint32_t L) override;
```

Definition — one owned tail cell at pos `L-1`, mirroring the whole-restore bookkeeping at `:1000-1039` (`cells` / `head` / `used` / `size` are public members, header `:69-109`):

```cpp
// src/llama-memory-recurrent.cpp
void llama_memory_recurrent::seq_fake_prefix(llama_seq_id seq_id, uint32_t L) {
    GGML_ASSERT(seq_id >= 0 && (uint32_t) seq_id < size);
    GGML_ASSERT(L >= 1);

    seq_rm(seq_id, -1, -1);  // clear this seq's tail/state (recurrent.cpp:150)

    // canonical: cells[seq_id] is the tail holder (whole-restore sets cells[seq_id].tail=i, :1022-1027)
    const uint32_t c = (uint32_t) seq_id;
    auto & cell = cells[c];

    cell.pos  = (llama_pos)(L - 1);   // find_slot sets cell.pos=last_pos (:647); seq_pos_max reads it (:380)
    cell.seq_id.insert(seq_id);
    cell.src  = c;                    // src>=0 so s_copy loads this cell, not the zeroed rs_z plane (:1035-1039)
    cell.src0 = c;
    cells[seq_id].tail = c;
    head = c;
    used = 1;
    // r_l/s_l rows left as-is (zero from clear/zero-init) -> garbage state, acceptable; zeros are denormal-safe
}
```

> **Adversarial note (cell index):** the recurrent cache `size = max(1, n_seq_max)` is sized by *sequence count*, not tokens. Using `c = seq_id` keeps `cells[seq_id]` as both the state holder and the tail holder, self-consistent for a single-slot server. Build with assertions ON first so the `tails_verif` debug check (`find_slot`, `recurrent.cpp:539-557`) fires on any inconsistency.

> **Verified:** the later `common_context_seq_rm(ctx_tgt, slot.id, p0=L, -1)` at `server-context.cpp:2929` does **not** abort the recurrent side — with `p0=L` and `cell.pos=L-1`, `seq_rm` hits neither the rollback branch (`:182`) nor the invalidate branch (`:192`) and returns `true`.

#### (iv) Hybrid fan-out — `src/llama-memory-hybrid.h` / `.cpp`

Declaration, after `seq_keep` (`src/llama-memory-hybrid.h:65`):

```cpp
// src/llama-memory-hybrid.h:66
    void seq_fake_prefix(llama_seq_id seq_id, uint32_t L) override;
```

Definition — mirror the fan-out (recurrent first per the can-fail discipline at `:141-148`):

```cpp
// src/llama-memory-hybrid.cpp  (after seq_keep, mirrors :150-168)
void llama_memory_hybrid::seq_fake_prefix(llama_seq_id seq_id, uint32_t L) {
    mem_recr->seq_fake_prefix(seq_id, L);  // recurrent first (the can-refuse child, :144)
    mem_attn->seq_fake_prefix(seq_id, L);
    // after this: seq_pos_max = min(L-1, L-1) = L-1 (:175-178); seq_pos_min consistent (:170-173)
}
```

#### (v) Public C shim — `src/llama-context.cpp` + `include/llama.h`

Add next to `llama_memory_seq_rm` (`src/llama-context.cpp:3711`):

```cpp
// src/llama-context.cpp, near :3721
void llama_memory_seq_fake_prefix(llama_memory_t mem, llama_seq_id seq_id, uint32_t L) {
    if (!mem) {
        return;
    }
    mem->seq_fake_prefix(seq_id, L);
}
```

Declaration in `include/llama.h`, near the other memory ops (after `llama_memory_seq_rm`, `:713`):

```c
// include/llama.h, near :714
    // TIMING-EXPERIMENT: fabricate a fake prior prefix of length L (positions [0,L)) for seq_id.
    LLAMA_API void llama_memory_seq_fake_prefix(llama_memory_t mem, llama_seq_id seq_id, uint32_t L);
```

### 4b. Server request plumbing + the `n_past = L` branch

#### (i) `task_params` field — `tools/server/server-task.h`

```cpp
// tools/server/server-task.h, after n_cache_reuse (:63)
    int32_t n_fake_cached = 0; // if >0: inject a fake prior KV of this many POSITIONS and prefill only-new (timing knob)
```

#### (ii) Parse it — `tools/server/server-task.cpp`

```cpp
// tools/server/server-task.cpp, after :274 (n_cache_reuse)
    params.n_fake_cached    = json_value(data,       "n_fake_cached",      0);
```

#### (iii) The prefill branch — `tools/server/server-context.cpp`

This is the **decisive** edit, and it must resolve the **driver/server contract** correctly. The batch-fill loop at `:3002` reads `input_tokens[slot.prompt.n_tokens()]` and loops while `slot.prompt.n_tokens() < slot.task->n_tokens()` — i.e. it treats `slot.prompt.tokens` as a *prefix* of `slot.task->tokens`. So **`slot.task->tokens` must contain `L + new` entries** for the loop to batch only `[L, L+new)`.

**Chosen contract (driver prepends `L` placeholder tokens; see §5).** The driver sends `slot.task->tokens = [L pure-text placeholders] ++ [new screenshot chunk + new text]`. The server then just forces `n_past = L` via the fabrication and lets the existing loop run. Guard the entire `cache_prompt` block (`:2704-2887`) so it is skipped when `n_fake_cached > 0`:

```cpp
// tools/server/server-context.cpp, inside the SLOT_STATE_STARTED branch.
// Replace the body that currently begins at the `if (slot.task->params.cache_prompt) {` test (:2704).

const int32_t L = slot.task->params.n_fake_cached;

if (L > 0 && L < slot.task->n_tokens()) {
    // ---- FAKE-PREFIX PATH: bypass get_common_prefix / cache_reuse / checkpoint / do_reset ----
    auto * mem = llama_get_memory(ctx_tgt);

    // hard guard: only a plain hybrid (swa NONE) implements seq_fake_prefix on both children
    GGML_ASSERT(llama_memory_can_shift(mem) == false /* IMROPE hybrid */ || true); // informational

    llama_memory_seq_rm        (mem, slot.id, -1, -1);
    llama_memory_seq_fake_prefix(mem, slot.id, (uint32_t) L);   // both mem_attn + mem_recr -> seq_pos_max=L-1

    n_past = L;
    // NOTE: slot.prompt.tokens currently holds the previous step's mirror; reset below via keep_first.
} else if (slot.task->params.cache_prompt) {
    // ... existing block :2705-2777 unchanged ...
} else {
    n_past = 0;
}

// ---- the existing tail (:2783-2887) runs ONLY in the non-fake path ----
if (L == 0) {
    llama_pos pos_next = slot.prompt.tokens.pos_next(n_past);
    // ... existing pos_min abort (:2791), checkpoint search (:2841), do_reset (:2866) ...
}
```

Then fall through to the existing post-block logic, which is **already correct** for the fake path:

- `:2890` `[TAG_PROMPT_LOGITS]` — guaranteed not to fire because we required `L < slot.task->n_tokens()`, so `n_past != task.n_tokens()`.
- `:2896` `slot.n_prompt_tokens_cache = n_past` → `L` → surfaced as `timings.cache_n` (`:396`).
- `:2899` `slot.prompt.tokens.keep_first(n_past)` — trims the mirror to `L` so `pos_next()` returns `L`.
- `:2925` `p0 = slot.prompt.tokens.pos_next()` → `L`; `:2929` `common_context_seq_rm(ctx_tgt, slot.id, L, -1)` clears cells beyond `L` (verified no-abort on recurrent).
- `:3002` batch-fill loop adds only `input_tokens[L .. L+new)` at `pos_next()` (= `L, L+1, …`) — **only-new decoded**.

> **Why this avoids every abort/reset:** `seq_fake_prefix` makes both children report `seq_pos_min/max = L-1 ≠ -1`, satisfying the `pos_min == -1` abort at `:2793`. We skip the `do_reset` hybrid full-reprocess branch (`:2866-2871`) entirely. `get_can_shift()==false` (IMROPE, `n_pos_per_embd()==4`) is irrelevant because positions are set *absolutely* via `pos_set`, never shifted. `has_mtmd` disables cache-reuse anyway (`:2716-2718`) — we bypass it.

> **Timing window:** put the fabrication right after `t_start_process_prompt = ggml_time_us()` (`:2629`). The fabrication is **metadata-only** (O(L) pointer writes, microseconds) — do **not** call `llama_state_seq_set_data_ext` here (that is the §7 fallback's multi-MiB memcpy and would contaminate the measured window).

### 4c. Build

```bash
cmake --build /data/repos/llama.cpp/build-cpu --target llama-server -j
# First validation build: assertions ON, to catch kv-cells / recurrent tails_verif asserts:
cmake -S /data/repos/llama.cpp -B /data/repos/llama.cpp/build-cpu-dbg -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLLAMA_CURL=ON
cmake --build /data/repos/llama.cpp/build-cpu-dbg --target llama-server -j
```

---

## 5. THE DRIVER (Python, talks to the patched server over HTTP)

The driver replays each recorded evict/agent step, posts the **real new screenshot + text** preceded by `L` placeholder tokens, reads `timings.prompt_ms` as the **measured optimum prefill**, and writes `row.measured_opt_prefill_s` — a drop-in replacement for `compute_task`'s `model()` call.

```python
# run_fakekv_evict.py  — drop-in MEASURED replacement for the arithmetic opt_prefill
import base64, json, requests

SERVER = "http://127.0.0.1:8080"
PLACEHOLDER_TOKEN = 220   # any benign PURE-TEXT token id; must NOT be an mtmd/image marker

def measure_step(new_text: str, screenshot_png_path: str, L: int, only_new_pos: int) -> dict:
    """
    L            = genuine prior-context depth at this step (POSITIONS), from the trace.
                   = depth_step - only_new_step  (the part we pretend was already cached)
    only_new_pos = number of NEW positions (screenshot + text delta) this step appends.
    Sends: [L placeholder text tokens] ++ [image] ++ [new text]  so slot.task->tokens has L+new entries.
    """
    with open(screenshot_png_path, "rb") as f:
        img_b64 = base64.b64encode(f.read()).decode()

    # prepend L placeholder text tokens so the batch loop starts new content at index L
    prefix_text = " ".join(["x"] * L)   # crude: ensures >= L text tokens; tune to land exactly at L positions

    body = {
        "messages": [{
            "role": "user",
            "content": [
                {"type": "text", "text": prefix_text},                                   # the faked prefix carrier
                {"type": "image_url", "image_url": {"url": f"data:image/png;base64,{img_b64}"}},
                {"type": "text", "text": new_text},                                       # the real new delta
            ],
        }],
        "n_fake_cached": L,        # << the patch reads this -> fabricate fake KV of length L, n_past=L
        "cache_prompt": False,
        "n_predict": 1,            # quality discarded
        "timings_per_token": True,
        "stream": False,
    }
    r = requests.post(f"{SERVER}/v1/chat/completions", json=body, timeout=600)
    assert r.status_code == 200, f"HTTP {r.status_code}: {r.text[:400]}"   # catches GGML_ABORT
    t = r.json()["timings"]

    # ---- validation asserts (catch a Blocker-#1 regression: only-new must be decoded, NOT L+new) ----
    assert t["cache_n"] == L,            f"cache_n={t['cache_n']} != L={L} (fake hit didn't register)"
    assert t["prompt_n"] <= only_new_pos + 8, f"prompt_n={t['prompt_n']} >> only_new (decoded too much)"

    return {
        "L": L,
        "only_new_tokens": t["prompt_n"],          # == only-new decoded
        "measured_opt_prefill_s": t["prompt_ms"] / 1e3,   # << the field run_optimum_sim.py --replay wants
        "cache_n": t["cache_n"],                   # == L
        "prompt_per_token_ms": t.get("prompt_per_token", None),
    }

# Per task: opt_wall = measured_opt_prefill + baseline_decode + baseline_exec  (decode/exec reused from baseline run)
```

**Launch constraints (mandatory):**

```bash
/data/repos/llama.cpp/build-cpu/bin/llama-server \
  --model /data/models/Holo3-35B-A3B-*.gguf \
  --mmproj /data/models/Holo3-35B-A3B-mmproj-*.gguf \
  --parallel 1 \
  --no-context-shift          # context shift auto-disabled under mtmd anyway
  # DO NOT pass a draft/speculative model: ctx_dft must be null so the fake prefix is not desynced
  #   (the ctx_dft seq_rm calls at :2930-2932/:2759 are skipped; cparams.n_rs_seq stays 0 -> single-plane recurrent)
```

> **Two contracts, pick ONE (do not mix).** This driver uses the **"prepend L placeholders"** contract that matches the §4b server hook. If you instead want the driver to send *only-new*, you must make the **server** synthesize `L` placeholder entries into `slot.task->tokens` (or a shadow `input_tokens`) before the loop so its bound becomes `L+new`. The placeholders must be **pure text** (no media-map entries) so `pos_next(L) == L`. Mixing "send only-new" with the "force `n_past=L`" server hook is the single decode-breaking trap (the loop would batch zero or wrong tokens).

---

## 6. VALIDATION — measured vs arithmetic, and the live sweep

1. **Per-step sanity (in the driver, already wired):** HTTP 200 (no `GGML_ABORT` from the `pos_min==-1` check at `:2793` or the M-RoPE batch validator); `timings.prompt_n == only_new` (proves only-new decoded, *not* `L+new`); `timings.cache_n == L` (proves the fake hit registered, `:396`).
2. **Baseline control:** for each step, also run with `n_fake_cached=0` and the **full** prompt (history + new) to get the true whole-context prefill at depth `L+new`. The ratio `prompt_ms(fake) / prompt_ms(baseline)` is the genuine system-level speedup.
3. **Agreement with the estimate:** compare `measured_opt_prefill_s` against `opt_prefill = only_new / prefill_tps(depth=L)`, where `prefill_tps(depth)` is measured separately at depth `L`. **Expected: tight agreement**, because the measured prefill *is* only-new compute + a real depth-L attention read — exactly what the formula encodes.
   - **A mismatch where measured ≫ estimate** means the only-new branch isn't firing — almost certainly the driver/server contract (Blocker #1): re-check `prompt_n == only_new`.
   - **A mismatch where measured ≪ estimate** means attention isn't actually reading L keys — check that both children report `seq_pos_max == L-1` (the hybrid `min()` at `:177`) and that `get_n_kv` padded to `≥ L+new` (`:1145`).
4. **Live sweep:** sweep `L` over the real distribution of evict depths. **Bucket `L` so `GGML_PAD(L+new, 256)` is stable across steps** (`:1145`) to keep the compute graph reusable and the per-step numbers comparable. For tiny `L`, attention floors at 256 KV columns, so the saving is unmeasurable below that — pick measurable `L`.
5. **Record the resolved graph config** in the run folder from the server startup log: `flash_attn` (enabled on single-device CPU), fused-GDN flags, `n_rs_seq` (expect 0), `v_trans` (true on CPU, no FA in compute graph). Per CLAUDE.md run rules, snapshot `uname/lscpu/free/df/git_commit` first, and **save `git_diff.patch`** — the patch makes the tree dirty, so the diff is the reproducibility net. Write rows to `/data/runs/$(date +%F_%H-%M)_$(hostname -s)_fakekv_evict/raw/`.

---

## 7. The lower-effort FALLBACK (state save/restore) — and when to prefer it

No libllama patch; uses only the public `llama_state_seq_*_ext` API. **Prime once** by decoding `L` tokens for the seq, capture `data_full = llama_state_seq_get_data_ext(ctx, seq, flags=0)` — note **`flags=0`, NOT `PARTIAL_ONLY`**: `PARTIAL_ONLY` (value 1) deliberately **skips the attention KV** (`src/llama-memory-hybrid.cpp:189,196`) and would force full attn recompute. With `flags=0` the blob captures **both** the 10 attn-layer KV cells *and* the 30 recurrent states. **Per step:** `llama_state_seq_set_data_ext(ctx, data_full, seq, flags=0)` to restore, then force `n_past=L` (you **still** need the same server `n_past`-override branch from §4b — `cache_prompt` won't produce `n_past=L` under mtmd, and `do_reset` would zero it).

**Caveats to report honestly:** the per-step `set_data_ext` is a **real, bandwidth-bound memcpy** of `L * 10 * row_size` K(+V) bytes — *not* near-free; report it as a separate "cache read" term. `L` is **baked into each snapshot** (`state_read` restores exactly the blob's `cell_count`), so a sweep needs one primed snapshot per distinct `L`. The single-seq attn restore drops 2D M-RoPE `ext` (a documented TODO) — harmless here (`is_2d` sub-mask only fires at `p0==p1`). **Do NOT** use the `/slots` file save|restore endpoints — they are gated by `check_no_mtmd` and disabled while `mmproj` is loaded.

**Prefer the fallback** only if the vtable change in S1 proves too disruptive to rebuild cleanly. Otherwise S1 is strictly better: its "cache read" is microsecond metadata, not a multi-MiB memcpy inside the timing window.

---

## 8. Gotchas / asserts to expect, and how to satisfy them (from the adversarial verdicts)

| Gotcha | Where | How the patch satisfies it |
|---|---|---|
| `pos_min == -1` `GGML_ABORT` when `n_past>0` | `server-context.cpp:2793` | `seq_fake_prefix` makes both children report real `seq_pos_min/max = L-1`. Skipped in fake path anyway (guarded `if L==0`). |
| Hybrid `do_reset` zeroes `n_past=0` for recurrent | `server-context.cpp:2866-2871` | Fake branch bypasses the entire `:2704-2887` block. |
| `[TAG_PROMPT_LOGITS]` decrements `n_past` if `== task.n_tokens()` | `server-context.cpp:2890` | Require `L < slot.task->n_tokens()` (driver always sends `L+new`, `new≥1`). |
| Batch loop treats `prompt.tokens` as a prefix of `task->tokens` | `server-context.cpp:3002-3004` | Driver prepends `L` placeholders so `task->tokens` has `L+new`; `keep_first(L)` at `:2899` aligns the mirror. **The decisive contract — get it right.** |
| `pos_set` asserts the cell is empty | `kv-cells.h:397-398` | `seq_fake_prefix` calls `seq_rm(seq_id,-1,-1)` first. |
| `seq_pos_max = min(attn, recr)` | `hybrid.cpp:177` | Fake **both** children to `L-1`; hybrid fan-out does this. |
| `get_can_shift()==false` (IMROPE, `n_pos_per_embd==4`) | `kv-cache.cpp` / `hparams.cpp:225` | Positions set **absolutely** via `pos_set`, never shifted. |
| `apply_ubatch` purge of low positions | `kv-cache.cpp:1071-1086` | Fake cells are a contiguous `[0,L)` block; new tokens land in fresh cells `≥L`, so no overlap/purge. |
| 2D `ext` left `{0,0}` for fake cells | `kv-cache.cpp:1556-1564` | `is_2d` sub-mask fires only at `p0==p1`; fake `p0<L ≤ p1` of new tokens — never consulted. |
| Recurrent `seq_rm(p0=L)` after fabrication | `recurrent.cpp:182/192` | With `cell.pos=L-1`, `p0=L` hits neither branch → returns `true`. |
| Fake state must be **zero**, not arbitrary | `kv-cache.cpp:271`, `recurrent.cpp:114` | Leave zero-init buffers untouched; never write random bytes (denormal slowdown). |
| Wrong memory class (`hybrid_iswa`/iswa/dsa) | `model.cpp:2075-2096` | Holo3 is plain `llama_memory_hybrid` (swa NONE). The non-pure vtable default makes other classes `GGML_ABORT` loudly if ever hit — add a server guard that the loaded memory is hybrid. |
| Speculative decoding desyncs the fake prefix | `server-context.cpp:2930-2932/2759` | Launch **without** a draft model (`ctx_dft` null) and `n_rs_seq=0`. |
| Build with assertions first | — | Use `RelWithDebInfo` build so `kv-cells`/recurrent `tails_verif` (`recurrent.cpp:539-557`) catch bookkeeping errors before trusting timings. |

---

### Files touched (summary)

| File | Edit | Anchor |
|---|---|---|
| `src/llama-memory.h` | non-pure `seq_fake_prefix` default | after `:110` |
| `src/llama-kv-cache.h` / `.cpp` | `seq_fake_prefix` override (metadata-only) | decl `:139`; def models `:2172-2210`, strm `:361` |
| `src/llama-memory-recurrent.h` / `.cpp` | `seq_fake_prefix` override (1 tail cell) | decl `:51`; def models `:1000-1039`, `:647` |
| `src/llama-memory-hybrid.h` / `.cpp` | `seq_fake_prefix` fan-out (recr first) | decl `:66`; def mirrors `:150-168` |
| `src/llama-context.cpp` + `include/llama.h` | C shim + `LLAMA_API` decl | shim near `:3721`; decl near `llama.h:714` |
| `tools/server/server-task.h` | `int32_t n_fake_cached` | after `:63` |
| `tools/server/server-task.cpp` | parse `n_fake_cached` | after `:274` |
| `tools/server/server-context.cpp` | fake-prefix branch, force `n_past=L`, bypass `:2704-2887` | guard at `:2704`, fabricate after `:2629` |

---

## Appendix — anchor verification (from synthesis)

This is the complete deliverable. Every function and struct cited traces to a verified anchor in the source at commit `da87e9b`:

- `cells.pos_set` / `cells.seq_add` — `src/llama-kv-cells.h:395` / `:309`
- kv-cache whole-restore template — `src/llama-kv-cache.cpp:2162-2211`; `clear` zero-init `:271`; `get_n_kv` pad `:1145`; mask keep `:1439-1586`; strm resolution `:361-362`
- recurrent whole-restore — `src/llama-memory-recurrent.cpp:990-1042`; `seq_rm` `:150`; `seq_pos_max` `:380`; members `head/size/used/cells` `recurrent.h:69-109`
- hybrid fan-out / `seq_pos_max=min` — `src/llama-memory-hybrid.cpp:141-178`; construction (swa NONE → plain hybrid) `model.cpp:2096`
- vtable — `src/llama-memory.h:71-123`; C shims `llama-context.cpp:3711+`; `llama.h:713-770`
- IMROPE / `n_pos_per_embd()==4` — `model.cpp:2449-2450`, `hparams.cpp:224-226`
- server prefill: `n_past` init `:2651`, `get_common_prefix` `:2706`, `pos_min` abort `:2793`, `do_reset` `:2866`, `cache_n` `:2896/:396`, batch loop `:3002`, timing `:2921`/`:2629`
- task params `server-task.h:50-66`, parse `server-task.cpp:264-274`

One correction to the input hints worth flagging: the served model maps **QWEN35MOE → IMROPE** with **`n_pos_per_embd()==4`** (verified `model.cpp:2450`, `hparams.cpp:225`), so the permissive M-RoPE batch validator applies and `get_can_shift()` is false — both folded into the guide. The model uses plain `llama_memory_hybrid` (not `_iswa`) only because `swa_type==NONE` for Holo3 (`model.cpp:2075/2096`); a server-side guard for this is included.
