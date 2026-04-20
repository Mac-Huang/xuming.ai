// In-browser RAG bot: WebLLM (local LLM) + transformers.js (embeddings)
// Loads a local LLM in WebGPU, embeds repo content, does top-k retrieval,
// and answers grounded questions with conversation memory.

import { CreateMLCEngine, prebuiltAppConfig } from "https://esm.run/@mlc-ai/web-llm";
import { pipeline, env } from "https://cdn.jsdelivr.net/npm/@xenova/transformers@2.17.2";

env.allowLocalModels = false;

const MODEL_OPTIONS = [
  { id: "Llama-3.2-3B-Instruct-q4f16_1-MLC", label: "Llama 3.2 3B (better, ~1.8GB)" },
  { id: "Llama-3.2-1B-Instruct-q4f16_1-MLC", label: "Llama 3.2 1B (faster, ~700MB)" },
  { id: "Qwen2.5-3B-Instruct-q4f16_1-MLC",   label: "Qwen 2.5 3B (better, ~1.9GB)" },
];
const DEFAULT_MODEL = "Llama-3.2-3B-Instruct-q4f16_1-MLC";
const EMBED_MODEL = "Xenova/all-MiniLM-L6-v2";
const KB_CACHE_KEY = "ragbot.kb.v1";
const HISTORY_WINDOW = 6; // last N messages kept as memory

// ---------------------------------------------------------------------------
// Knowledge base construction (from globals loaded by bot.html)
// ---------------------------------------------------------------------------

const BIO_CHUNKS = [
  {
    source: "Bio",
    title: "Who is Xuming Huang",
    text: "Xuming Huang is a junior Computer Science student at the University of Wisconsin – Madison. His research interests are in Machine Learning Systems, Operating Systems, distributed systems, compiler optimization, and efficient computing infrastructure. He is particularly focused on making large-scale ML training and inference more efficient through systems optimization. Career goal: advance ML infrastructure at leading tech companies or pursue a PhD in ML systems."
  },
  {
    source: "Bio",
    title: "Stanford Summer 2025",
    text: "During Summer 2025 at Stanford, Xuming took CS107 Computer Organization & Systems (A+, 99/100) and CS161 Design and Analysis of Algorithms (A, 93/100). He also discovered critical security vulnerabilities in Stanford's Andrew File System (AFS) during CS107, followed responsible disclosure, documented the issues, and worked with Alex Keller from the engineering team to implement fixes."
  },
  {
    source: "Bio",
    title: "UW-Madison coursework",
    text: "Current and completed courses at UW-Madison include COMP SCI 200 Programming I, ECE 252 Computer Engineering, MATH 340 Linear Algebra, COMP SCI 240 Discrete Mathematics. Planned future courses: COMP SCI 352 Digital System Fundamentals, COMP SCI 552 Computer Architecture, COMP SCI 537 Operating Systems, COMP SCI 744 Big Data Systems."
  },
  {
    source: "Bio",
    title: "Skills and experience",
    text: "Technical skills: C/C++, Python, Java, x86 Assembly, CUDA, PyTorch, systems programming, security analysis, algorithm design. Experience: interned at CoolAI working on AI products and represented the company at the World Artificial Intelligence Conference (WAIC); discovered Stanford AFS vulnerabilities; created widely-used CS educational visualizations."
  },
  {
    source: "Bio",
    title: "Hobbies and achievements",
    text: "NFL FLAG Football National Champion 2023 (USST Earthmoving Vehicles team). Beyond coding, enjoys reading about technology trends, contributing to open source, mentoring students, and participating in hackathons and research seminars at UW-Madison."
  },
  {
    source: "Bio",
    title: "Contact",
    text: "GitHub: github.com/Mac-Huang. To email Xuming, click the 'show email' link on the homepage. He is open to research collaborations, technical discussions, and internship opportunities in ML infrastructure."
  },
];

const TECH_TOPICS = [
  ["Gradient checkpointing",
   "Gradient checkpointing (activation checkpointing) trades compute for memory: instead of storing all intermediate activations during the forward pass, recompute them during backprop. Reduces activation memory by roughly (L-1)/L where L is number of layers, at ~33% extra compute. Enables training 2-3x larger models on the same hardware."],
  ["Distributed training",
   "Distributed training splits model training across GPUs/machines. Three axes: data parallelism (each GPU on different batches, synchronized via AllReduce), model/tensor parallelism (weight matrices split across GPUs), pipeline parallelism (layers split across GPUs with micro-batching). Main challenges: communication overhead and synchronization."],
  ["ZeRO optimizer",
   "The Zero Redundancy Optimizer (ZeRO) partitions optimizer states, gradients, and parameters across data-parallel ranks. Stage 1 partitions optimizer states (~8x memory reduction for Adam). Stage 2 also partitions gradients (~2x more). Stage 3 also partitions parameters (Nx reduction across N GPUs)."],
  ["Mixed precision",
   "Mixed precision training uses FP16/BF16 for compute while keeping FP32 master weights and loss scaling for numerical stability. ~50% memory reduction for weights and activations, 2-8x speedup on tensor cores."],
  ["FlashAttention",
   "FlashAttention is an IO-aware exact attention algorithm that reduces HBM reads/writes from O(n^2) to O(n). Uses tiling to keep Q/K/V blocks in fast SRAM during softmax and recomputes on-chip during backward. 2-4x speedup and much lower memory for long sequences."],
  ["Quantization",
   "Quantization reduces precision from FP16/FP32 to INT8/INT4 (or lower). Shrinks memory ~4-8x and speeds up inference. Post-training quantization (PTQ) is cheap; quantization-aware training (QAT) preserves more accuracy. GPTQ and AWQ are popular for LLMs."],
  ["CUDA programming",
   "CUDA is NVIDIA's parallel compute platform. Key concepts: grid/block/thread hierarchy, shared memory, warp execution (32 threads in lockstep), warp divergence, memory coalescing, occupancy. Essential for writing optimized GPU kernels."],
  ["ML compilers",
   "ML compilers (XLA, TorchInductor, TVM, MLIR) lower framework graphs to hardware-specific code. Key passes: operator fusion (merge elementwise ops into a single kernel), memory planning, constant folding, auto-tuning and auto-scheduling, kernel codegen."],
  ["Attention mechanisms",
   "Attention maps (Q, K, V) with softmax(QK^T / sqrt(d)) V. Standard attention is O(n^2) in sequence length. Efficient variants: linear attention (kernelized), sparse/local attention, FlashAttention (IO-aware), multi-query/grouped-query attention (fewer KV heads)."],
  ["Distributed communication",
   "Collective primitives: AllReduce (sum gradients), AllGather, ReduceScatter, Broadcast. NCCL implements these efficiently over NVLink/InfiniBand. Ring-AllReduce is bandwidth-optimal; tree-based is latency-optimal for small messages."],
  ["Automatic differentiation",
   "AutoDiff computes gradients by composing chain rule. Forward-mode is efficient when outputs >> inputs; reverse-mode (backprop) is efficient when inputs >> outputs, which is the usual deep learning case."],
  ["Model compression",
   "Techniques to shrink models while preserving quality: pruning (remove weights), quantization, knowledge distillation (student mimics teacher), low-rank factorization (LoRA), neural architecture search."],
];

function buildKnowledgeBase() {
  const chunks = [...BIO_CHUNKS];

  for (const [name, body] of TECH_TOPICS) {
    chunks.push({ source: "Technical topics", title: name, text: body });
  }

  if (typeof publications !== "undefined") {
    for (const p of publications) {
      const authors = (p.authors || "").replace(/<[^>]+>/g, "");
      chunks.push({
        source: "Publication",
        title: p.title,
        text: `${p.title} (${p.venue}, ${p.year}). Authors: ${authors}. ${p.abstract || ""}`.trim(),
        url: p.paper_url || p.code_url || null,
      });
    }
  }

  if (typeof projects !== "undefined") {
    for (const pr of projects) {
      chunks.push({
        source: "Project",
        title: pr.title,
        text: `${pr.title}. ${pr.description} Tech: ${pr.tech}.`,
        url: pr.demo_url || pr.code_url || null,
      });
    }
  }

  if (typeof blogPosts !== "undefined") {
    for (const b of blogPosts) {
      chunks.push({
        source: "Blog",
        title: b.title,
        text: `${b.title} (${b.date}, ${b.category}). ${b.excerpt}`,
        url: b.url,
      });
    }
  }

  return chunks;
}

// ---------------------------------------------------------------------------
// Embeddings + vector index
// ---------------------------------------------------------------------------

let embedder = null;

async function getEmbedder(progress) {
  if (embedder) return embedder;
  progress?.("Loading embedding model (~23MB)…");
  embedder = await pipeline("feature-extraction", EMBED_MODEL, { quantized: true });
  return embedder;
}

async function embed(text) {
  const ex = await getEmbedder();
  const out = await ex(text, { pooling: "mean", normalize: true });
  return Array.from(out.data);
}

function cosine(a, b) {
  let s = 0;
  for (let i = 0; i < a.length; i++) s += a[i] * b[i];
  return s; // already unit-normalized
}

async function buildOrLoadIndex(chunks, progress) {
  const cacheRaw = localStorage.getItem(KB_CACHE_KEY);
  if (cacheRaw) {
    try {
      const cache = JSON.parse(cacheRaw);
      if (cache.n === chunks.length && cache.dim && cache.vectors?.length === chunks.length) {
        return cache.vectors;
      }
    } catch {}
  }
  progress?.(`Embedding ${chunks.length} knowledge chunks…`);
  await getEmbedder(progress);
  const vectors = [];
  for (let i = 0; i < chunks.length; i++) {
    vectors.push(await embed(chunks[i].text));
    if (i % 5 === 0) progress?.(`Embedding chunks… ${i + 1}/${chunks.length}`);
  }
  try {
    localStorage.setItem(KB_CACHE_KEY, JSON.stringify({
      n: chunks.length, dim: vectors[0].length, vectors,
    }));
  } catch (e) {
    console.warn("KB cache write failed:", e);
  }
  return vectors;
}

async function retrieve(query, chunks, vectors, k = 5) {
  const qv = await embed(query);
  const scored = vectors.map((v, i) => ({ i, s: cosine(qv, v) }));
  scored.sort((a, b) => b.s - a.s);
  return scored.slice(0, k).map(({ i, s }) => ({ ...chunks[i], score: s }));
}

// ---------------------------------------------------------------------------
// LLM engine + chat
// ---------------------------------------------------------------------------

let engine = null;
let currentModel = null;
let kbChunks = null;
let kbVectors = null;
let ready = false;
let history = []; // [{role, content}]

const SYSTEM_PROMPT = `You are Xuming Bot, an assistant that speaks in first person as Xuming Huang, a junior CS student at UW-Madison.

Ground rules:
- Answer using ONLY the Context below and the prior conversation. If the answer isn't supported, say you don't have that information and suggest what to check (e.g. the Research, Projects, or Blog pages, or emailing Xuming directly).
- Be concise: 2-5 sentences unless the user asks for depth.
- Use first person ("I", "my") when talking about Xuming's work, background, or opinions.
- When you reference specific work, name it (e.g. "my LinuxGuard project", "my Stanford CS107 experience").
- Do not invent publications, grades, dates, or quotes that are not in the Context.`;

function formatContext(retrieved) {
  return retrieved
    .map((c, i) => `[${i + 1}] (${c.source}${c.title ? " — " + c.title : ""})\n${c.text}`)
    .join("\n\n");
}

export async function initBot(modelId, progressCb) {
  currentModel = modelId || DEFAULT_MODEL;
  ready = false;

  progressCb?.({ stage: "kb", text: "Building knowledge base…", pct: 0 });
  kbChunks = buildKnowledgeBase();

  progressCb?.({ stage: "embed", text: "Loading embeddings…", pct: 5 });
  kbVectors = await buildOrLoadIndex(kbChunks, (msg) =>
    progressCb?.({ stage: "embed", text: msg, pct: 15 })
  );

  progressCb?.({ stage: "llm", text: `Loading ${currentModel}…`, pct: 25 });
  engine = await CreateMLCEngine(currentModel, {
    initProgressCallback: (report) => {
      const pct = 25 + Math.round((report.progress || 0) * 70);
      progressCb?.({ stage: "llm", text: report.text || "Loading model…", pct });
    },
  });

  ready = true;
  progressCb?.({ stage: "ready", text: "Ready.", pct: 100 });
}

export function isReady() {
  return ready;
}

export function listModels() {
  return MODEL_OPTIONS;
}

export function resetConversation() {
  history = [];
}

export async function ask(userMessage, { onToken, onSources } = {}) {
  if (!ready) throw new Error("Bot is not ready yet.");

  const retrieved = await retrieve(userMessage, kbChunks, kbVectors, 5);
  onSources?.(retrieved);

  const context = formatContext(retrieved);
  const systemWithContext = `${SYSTEM_PROMPT}\n\nContext:\n${context}`;

  // Keep a rolling window of the last HISTORY_WINDOW turns for memory.
  const windowed = history.slice(-HISTORY_WINDOW);
  const messages = [
    { role: "system", content: systemWithContext },
    ...windowed,
    { role: "user", content: userMessage },
  ];

  const stream = await engine.chat.completions.create({
    messages,
    temperature: 0.6,
    top_p: 0.9,
    max_tokens: 512,
    stream: true,
  });

  let full = "";
  for await (const chunk of stream) {
    const delta = chunk.choices?.[0]?.delta?.content || "";
    if (delta) {
      full += delta;
      onToken?.(delta, full);
    }
  }

  // Persist to memory AFTER completion, storing only the user turn and final reply.
  history.push({ role: "user", content: userMessage });
  history.push({ role: "assistant", content: full });

  return { text: full, sources: retrieved };
}

// Expose a small API on window for bot.html (non-module code).
window.RagBot = {
  init: initBot,
  ask,
  isReady,
  listModels,
  reset: resetConversation,
};
