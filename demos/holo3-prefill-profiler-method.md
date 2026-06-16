# Measuring where Holo3 prefill time actually goes — what I built, ran, and verified

This documents the instrument and procedure behind the measured per-operation prefill
profile of **Holo3-35B-A3B** (`qwen35moe`) on the NUC16, CPU-only. It is the *method*
companion to the result chart (**[where prefill time actually goes](holo3-prefill-op-profile.html)**).

The question it answers: *for one prefill step, which operation eats the wall-clock —
FFN/MoE, the attention core, the Q/K/V/O projections, or the Gated-DeltaNet recurrence —
and at what context depth does attention take over?* Previously this was asserted
schematically ("prefill is GEMM-bound"). This replaces the schematic with a measurement
in real milliseconds-per-token.

---

## 1. What I modified — and what I deliberately did **not**

There are two ways to get per-operation timing out of llama.cpp:

| approach | cost | what it touches |
|---|---|---|
| Patch the engine (add timers inside the graph compute / per-layer) | invasive, must be maintained against upstream | `ggml`, `llama-context`, the model graph builders |
| **Use the public `cb_eval` hook** (what I did) | a standalone program, **zero core edits** | nothing — links the prebuilt libraries |

I chose the second. `llama_context_params` already exposes an evaluation callback that
the scheduler invokes for **every node** of the compute graph:

```c
// include/llama.h:362
ggml_backend_sched_eval_callback cb_eval;
void *                           cb_eval_user_data;
```

It is wired straight through to `ggml_backend_sched_set_eval_callback`
(`src/llama-context.cpp:1286`). So a small program that links `build-cpu`'s shared
libraries and sets `cb_eval` can time the graph **without modifying llama.cpp at all**.
The whole instrument is one ~280-line `.cpp` (`profile_prefill_ops.cpp`) plus a ~200-line
categoriser (`categorize_ops.py`). The llama.cpp checkout stays clean — this is a private
research instrument, not an upstream change.

> This is the opposite trade-off from the [fake-prefix prefill guide](holo3-fakekv-guide.html),
> which *does* need an engine patch because it changes what the engine computes. Here I only
> *observe* what it already computes, so the public hook suffices.

---

## 2. How the timer works — the `cb_eval` mechanism

The scheduler's per-node loop (`ggml/src/ggml-backend.cpp`,
`ggml_backend_sched_compute_splits`, ~lines 1683-1714) behaves differently depending on
what the callback returns to the `ask` probe:

```c
for (int j0 = 0; j0 < n_nodes; j0++) {
    bool need = callback(node[j0], /*ask=*/true);   // (A)
    int j1 = j0;
    while (!need && j1 < n_nodes-1)                  // (B) extend a fused run
        need = callback(node[++j1], /*ask=*/true);
    gv = graph_view(j0 .. j1);
    graph_compute_async(gv);                         // compute the range
    synchronize();
    if (need) callback(node[j1], /*ask=*/false);     // (C) observe
    j0 = j1;
}
```

The instrument runs in two modes by flipping one flag inside `cb_eval_user_data`:

- **TIMED mode** — `ask` returns **`true`** for every node. Then `need` is true
  immediately (the while-loop **(B)** never extends), so the graph view is a **single
  node**, it is computed, synchronised, and **(C)** fires. I stamp a clock on **(A)** and
  again on **(C)**; the difference is that one node's compute time. Every node is isolated
  and waited on.

- **FUSED mode** — `ask` returns **`false`** for every node. Now **(B)** extends `j1` to
  the end, the whole split computes as one graph at **native speed**, and **(C)** never
  fires. I wrap the whole `llama_decode` in a monotonic clock to get the **true** marginal
  prefill time of the chunk.

```cpp
// profile_prefill_ops.cpp — the callback (simplified; the real one guards the
// metadata capture with `if (a.calls == 0)` and also records src1/layer/ne)
static bool cb_eval(ggml_tensor * t, bool ask, void * user) {
    CBData * d = (CBData *) user;
    if (!d->timed) return false;             // FUSED: never observe -> nodes fuse
    if (ask) { d->t_ask = now_ms(); return true; }   // TIMED: isolate this node
    double dt = now_ms() - d->t_ask;         // node t just computed + synced
    auto & a = (*d->acc)[t->name[0] ? t->name : ggml_op_name(t->op)];
    a.op = ggml_op_name(t->op);
    a.src0 = t->src[0] ? t->src[0]->name : "";   // weight name -> band + layer
    a.ms += dt; a.calls++;
    return true;
}
```

**Why two modes instead of one.** TIMED disables op fusion, so its *absolute* time is
slightly inflated; but it gives clean per-node *shares*. FUSED gives the honest absolute
wall but no breakdown. The per-band number is

```
band ms/token = (band's TIMED share) × (FUSED chunk ms) ÷ 512
```

On this CPU backend the two totals agree to **~1.4% on average** (the heavy ops — MoE
GEMMs, flash-attention, the delta-net scan — don't fuse with neighbours, so their absolute
time is the same either way), so the share decomposition is essentially unbiased. The
per-depth discrepancy ranges roughly −3% to +5%, largest at depth 0 (the cache-cold first
chunk) and decaying with depth.

> A subtlety the verification flagged: the CPU backend's `synchronize` is a *no-op*
> (`iface.synchronize == NULL`). That is **not** a bug here — `ggml_graph_compute` is itself
> blocking (it joins the OpenMP/threadpool workers before returning), so by the time
> **(C)** fires the node is genuinely done. The empirical "sum of isolated node times ≈
> fused wall (1.4%)" is the proof.

---

## 3. The depth sweep — getting a clean point at each context length L

To see attention's cost *as a function of depth*, I prefill a fixed **512-token chunk**
(one ubatch) at increasing context depths. The trick is to do it cumulatively so the model
only pays for building the context once:

- decode the context in 512-token chunks, chunk *c* covering positions `[c·512, c·512+512)`;
- chunk *c* is a probe at depth **L = c·512** — it attends to `L+512` keys;
- run the whole sweep **twice per cycle**: once all-TIMED (per-node shares), once
  all-FUSED (true ms). Both passes hit the *same* chunk-boundary depths, and the recurrent
  state is naturally consistent within each pass (no rollback needed).

```cpp
for (int c = 0; c < n_chunks; ++c) {            // FUSED pass
    double t0 = now_ms();
    decode_chunk(c*M, M);                        // 512 new tokens at depth c*M
    fused[c].push_back(now_ms() - t0);           // true marginal prefill ms
}
// ... then a TIMED pass over the same chunks for the per-node breakdown
```

80 chunks → depths 0…40k. Quality is irrelevant to op timing (these matmul / softmax /
scan kernels are data-independent), so the probe uses deterministic filler tokens spread
across the vocab so MoE expert routing resembles real text.

---

## 4. Sorting nodes into operation bands

`categorize_ops.py` maps every ggml node to one of five bands using three signals, most
reliable first:

1. **ggml op type** — `FLASH_ATTN_EXT → attention core`, `GATED_DELTA_NET` / `SSM_CONV →
   GDN`, `MUL_MAT_ID → FFN/MoE experts`. (Holo3 uses *fused* flash-attention and *fused*
   delta-net, so each is a single op per layer.)
2. **weight name** for plain matmuls — the input weight `blk.<L>.<proj>.weight` names the
   projection exactly. `attn_q/k/v/output → projections`, `attn_qkv`/`attn_gate`/`ssm_* →
   GDN`, `ffn_* → FFN/MoE`.
3. **layer type** — a layer is recurrent (GDN) or full-attention; this disambiguates the
   few node names that the attention and GDN paths share.

```python
# exact proj-token map (avoids the substring trap below)
WEIGHT_EXACT = {
  "attn_q":"proj","attn_k":"proj","attn_v":"proj","attn_output":"proj",
  "attn_qkv":"gdn","attn_gate":"gdn","ssm_out":"gdn","ssm_in":"gdn",
  "ssm_alpha":"gdn","ssm_beta":"gdn","ssm_conv1d":"gdn","ssm_norm":"gdn",
  "ffn_down_exps":"ffn_moe","ffn_gate_exps":"ffn_moe","ffn_up_exps":"ffn_moe", ...
}
```

Coverage of the timed wall by the five bands is **100%** at every depth — nothing falls
through. The leftover "other" band is only the token embedding, the final RMSNorm, the
248k-vocab LM head (computed for the last token only), and residual adds.

---

## 5. What I ran — the clean-room sweep

The production Holo3 server holds a 262k-token KV cache (~76 GB) and was paused, so I
measured in a clean room: stop the (idle) server, run the sweep with the whole machine to
itself, then **always** restart the server on exit.

```bash
# stop supervisor + server, wait for RAM to free, then:
profile_prefill_ops  Holo3-35B-A3B.i1-Q4_K_M.gguf  \
    41984   512   40960   3   op_profile.json   8 16
#   n_ctx  ubatch  max_depth cycles  out         -t -tb
# ... server restarted via serve_holo3.sh on exit (EXIT trap)
```

- **CPU-only, `-t 8 / -tb 16`** — identical to the production server, so the numbers are
  the ones the live system pays.
- **3 cycles, median per depth** — the middle of three samples, robust to transient OS jitter.
- the model is loaded **text-only** (no vision encoder) — vision is a separate one-shot
  encode and is not part of the per-token prefill cost being profiled.
- everything lands in a write-once run folder: the raw per-node JSON (~39 MB/cycle), the
  instrument source, the system snapshot, and the sweep log.

The full sweep is ~one hour of compute (cumulative decode to 40k, twice per cycle, ×3).

---

## 6. How it was verified

The result was put through a 3-reviewer **adversarial** pass — each reviewer re-derived
the numbers from the raw per-node dump and tried to break them:

- **Timing fidelity** — per-node-isolated sum vs fused wall agree to **1.4% on average**
  (per-depth −3% to +5%, largest at depth 0); the no-op CPU `synchronize` is a red herring
  (graph compute is blocking).
- **Coverage** — 100% at every depth; "other" is clean; a cross-band audit confirms no
  heavy op is mis-binned.
- **Physics** — absolute scale **122 tok/s at depth 0 vs the server's measured ~118 tok/s**
  (+3.4%); attention-core cost is **linear in L (R²≈0.9998)** — the textbook flash-attention
  O(L) signature; the flat bands are flat (CV ≤ 3.3%).

**One real bug was caught and fixed.** The first categoriser used substring matching and
`"attn_q"` is a prefix of `"attn_qkv"`, so the 30 Gated-DeltaNet *input* GEMMs were briefly
counted under "projections." Those `attn_qkv` GEMMs are ~2× the real Q/K/V/O projections, so
the bug roughly **tripled** the projection band and correspondingly **deflated** GDN. The fix
is exact proj-token matching plus a cross-band audit that flags any recurrent-layer matmul
landing in an attention band; it moves those GEMMs back to GDN. After the fix, **GDN — not
projections — is the second flat band**, which is what the architecture predicts (30 GDN
layers vs 10 attention layers).

---

## 7. The measured answer

At shallow depth the step is **FFN/MoE-bound** (~4.3 ms/token, the dominant flat cost).
The **attention core climbs linearly** with context and **overtakes FFN/MoE at L ≈ 13.6k
tokens**; by the deepest probe (40k) it is ~60% of prefill (12.7 ms/token). The other three
bands stay flat regardless of depth — GDN ~3.4, projections ~0.65, other ~0.2 ms/token.
Full chart, per-depth table, and numbers:
**[where prefill time actually goes →](holo3-prefill-op-profile.html)**.

---

## 8. Reproduce

```bash
# build the instrument against the prebuilt build-cpu libraries (no core edit)
g++ -std=c++17 -O2 profile_prefill_ops.cpp \
  -I llama.cpp/include -I llama.cpp/ggml/include -I llama.cpp/common \
  -L llama.cpp/build-cpu/bin -lllama -lllama-common -lggml -lggml-base -lggml-cpu \
  -Wl,-rpath,$PWD/llama.cpp/build-cpu/bin -o profile_prefill_ops

# run a sweep, then categorise + plot
profile_prefill_ops MODEL.gguf 41984 512 40960 3 op_profile.json 8 16
python3 categorize_ops.py op_profile.json     # per-band ms/token + coverage audit
```

*Measured on wuklab-NUC16 (Intel Core Ultra 7 356H, 16 cores, CPU-only) via llama.cpp's
public `cb_eval` per-node timing.*
