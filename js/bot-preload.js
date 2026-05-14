// Background preloader for the Ask Me bot.
//
// Loaded on every page. As soon as the page is idle, this starts downloading
// and initializing the WebLLM model (the slow part of the Ask Me page) so
// that by the time the user clicks "Ask Me", the model is hot. Same-tab
// navigation also reuses the in-memory engine via window.BotPreload.
//
// On non-bot pages, a small pill in the bottom-right shows progress and
// links to the bot. On bot.html the rag-bot reads window.BotPreload state.

(function () {
  if (window.BotPreload) return;

  const DEFAULT_MODEL = "Llama-3.2-3B-Instruct-q4f16_1-MLC";
  const PILL_DISMISS_KEY = "botPreloadPillDismissed";

  if (!("gpu" in navigator)) {
    window.BotPreload = {
      unsupported: true,
      isReady: () => false,
      onProgress: (fn) => { fn({ unsupported: true }); return () => {}; },
      getEngine: () => null,
      getModelId: () => DEFAULT_MODEL,
      start: () => {},
      state: { unsupported: true, pct: 0, text: "WebGPU not available", ready: false, error: null },
    };
    return;
  }

  const state = {
    modelId: DEFAULT_MODEL,
    pct: 0,
    text: "Queued",
    ready: false,
    engine: null,
    error: null,
    started: false,
  };
  const listeners = new Set();

  function emit() {
    for (const fn of listeners) {
      try { fn(state); } catch (_) {}
    }
  }

  async function start() {
    if (state.started) return;
    state.started = true;
    state.text = "Pre-warming AI…";
    emit();
    try {
      const { CreateMLCEngine } = await import("https://esm.run/@mlc-ai/web-llm");
      state.engine = await CreateMLCEngine(state.modelId, {
        initProgressCallback: (rep) => {
          state.pct = Math.max(state.pct, Math.round((rep.progress || 0) * 100));
          state.text = rep.text || "Loading model…";
          emit();
        },
      });
      state.ready = true;
      state.pct = 100;
      state.text = "Ready";
      emit();
    } catch (e) {
      console.warn("BotPreload failed:", e);
      state.error = e;
      state.text = "Preload skipped";
      emit();
    }
  }

  window.BotPreload = {
    state,
    onProgress(fn) {
      listeners.add(fn);
      try { fn(state); } catch (_) {}
      return () => listeners.delete(fn);
    },
    isReady: () => state.ready,
    getEngine: (modelId) => (modelId && modelId !== state.modelId ? null : state.engine),
    getModelId: () => state.modelId,
    start,
  };

  function kick() {
    if (window.requestIdleCallback) requestIdleCallback(start, { timeout: 3000 });
    else setTimeout(start, 1500);
  }
  if (document.readyState === "complete") kick();
  else window.addEventListener("load", kick);

  // Floating pill — only on non-bot pages.
  if (location.pathname.endsWith("bot.html")) return;
  if (sessionStorage.getItem(PILL_DISMISS_KEY)) return;

  function injectStyles() {
    if (document.getElementById("bot-preload-style")) return;
    const style = document.createElement("style");
    style.id = "bot-preload-style";
    style.textContent = `
      #bot-preload-pill {
        position: fixed;
        bottom: 18px;
        right: 18px;
        z-index: 9999;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        padding: 7px 12px 8px;
        background: #ffffff;
        border: 1px solid #d8e2ee;
        border-radius: 3px;
        box-shadow: 0 2px 6px rgba(20, 50, 90, 0.08);
        font-family: 'EB Garamond', 'TeX Gyre Termes', Georgia, serif;
        font-size: 14px;
        color: #333;
        text-decoration: none;
        opacity: 0;
        transition: opacity 0.5s ease, border-color 0.4s ease, box-shadow 0.4s ease;
        max-width: 320px;
        overflow: hidden;
      }
      #bot-preload-pill:hover {
        text-decoration: none;
        border-color: #1772d0;
        box-shadow: 0 3px 10px rgba(23, 114, 208, 0.18);
      }
      #bot-preload-pill .bpp-label {
        color: #555;
        white-space: nowrap;
      }
      #bot-preload-pill .bpp-label em {
        color: #1772d0;
        font-style: italic;
        margin-right: 2px;
      }
      #bot-preload-pill .bpp-pct {
        color: #1772d0;
        font-variant-numeric: tabular-nums;
        font-size: 13px;
        min-width: 32px;
        text-align: right;
      }
      #bot-preload-pill .bpp-close {
        color: #b0b7c2;
        font-size: 16px;
        line-height: 1;
        margin-left: 2px;
        padding: 0 3px;
        cursor: pointer;
        font-family: Georgia, serif;
        transition: color 0.2s;
      }
      #bot-preload-pill .bpp-close:hover { color: #1772d0; }
      #bot-preload-pill .bpp-bar {
        position: absolute;
        left: 0;
        right: 0;
        bottom: 0;
        height: 2px;
        background: transparent;
      }
      #bot-preload-pill .bpp-bar::after {
        content: "";
        display: block;
        height: 100%;
        width: var(--bpp-progress, 0%);
        background: #1772d0;
        transition: width 0.4s ease;
      }
      #bot-preload-pill.ready {
        border-color: #1772d0;
      }
      #bot-preload-pill.ready .bpp-label em { color: #1772d0; }
      #bot-preload-pill.ready .bpp-pct { display: none; }
      #bot-preload-pill.ready .bpp-bar::after { width: 100%; }
    `;
    document.head.appendChild(style);
  }

  function mountPill() {
    injectStyles();
    const pill = document.createElement("a");
    pill.id = "bot-preload-pill";
    pill.href = "bot.html";
    pill.setAttribute("aria-live", "polite");
    pill.innerHTML =
      '<span class="bpp-label"><em>Ask Me</em> <span id="bpp-text">pre-warming</span></span>' +
      '<span class="bpp-pct" id="bpp-pct">0%</span>' +
      '<span class="bpp-close" id="bpp-close" title="Dismiss">×</span>' +
      '<span class="bpp-bar"></span>';
    document.body.appendChild(pill);
    requestAnimationFrame(() => { pill.style.opacity = "1"; });
    pill.querySelector("#bpp-close").addEventListener("click", (e) => {
      e.preventDefault();
      e.stopPropagation();
      pill.style.opacity = "0";
      setTimeout(() => pill.remove(), 500);
      sessionStorage.setItem(PILL_DISMISS_KEY, "1");
    });
    return pill;
  }

  function ensurePill() {
    if (!document.body) {
      window.addEventListener("DOMContentLoaded", ensurePill, { once: true });
      return;
    }
    const pill = document.getElementById("bot-preload-pill") || mountPill();
    const textEl = pill.querySelector("#bpp-text");
    const pctEl  = pill.querySelector("#bpp-pct");
    window.BotPreload.onProgress((s) => {
      if (!textEl) return;
      if (s.error) {
        textEl.textContent = "preload skipped";
        if (pctEl) pctEl.style.display = "none";
        pill.style.setProperty("--bpp-progress", "0%");
      } else if (s.ready) {
        textEl.innerHTML = "is ready &rarr;";
        pill.classList.add("ready");
        pill.style.setProperty("--bpp-progress", "100%");
      } else {
        textEl.textContent = "pre-warming";
        if (pctEl) pctEl.textContent = `${s.pct}%`;
        pill.style.setProperty("--bpp-progress", `${s.pct}%`);
      }
    });
  }
  ensurePill();
})();
