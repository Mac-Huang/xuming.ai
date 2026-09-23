# Bot knowledge and model choices

The bot uses current résumé facts and public website content. It does not have access to private files or unpublished personal information. Curated profile records take precedence over historical blog posts. Research appointments and published papers are separate categories.

## Updating content

1. Update the public pages/data and the curated résumé records in `scripts/build-bot-knowledge.py` when facts change.
2. Run `python3 scripts/build-bot-knowledge.py` with Node on PATH (or set `SITE_NODE` to its executable).
3. Run `node --test tests/bot-core.test.mjs tests/bot-generation.test.mjs` and `python3 scripts/audit-site.py`.
4. Commit the generated `data/bot-knowledge.json` with the content changes.

The generated knowledge version is a hash of the content. The browser fetches it with cache revalidation, replacing the old chunk-count-only embedding cache. The September 23 build contains 171 records, including all 24 listed projects, actual publications, current coursework, collaborators, and full prose from the listed blogs.

## Retrieval and answers

Every answer uses actual inference from the selected model, including named-person questions, short profile prompts, and questions without relevant evidence. Alias matching selects evidence; it never supplies a finished answer. Other questions use weighted lexical retrieval with relevance thresholds and source deduplication. No arbitrary top-five sources are added. The model receives recent conversational context and the current question's sources, and streams its answer using [WebLLM's streaming API](https://webllm.mlc.ai/docs/user/basic_usage.html#streaming-chat-completion). The source panel lists only cited records.

Citation errors, unsupported numbers, unsupported praise, or first-person impersonation trigger one model-generated revision. A second validation failure reports an error; it does not silently substitute stored prose. Missing WebGPU, model-load failures, and inference errors are explicit. Send stays disabled until a model is actually loaded. Successful replies display the model name, reported output token count, and measured generation duration. These indicators are based on real inference; there is no artificial delay.

Each request supplies fresh evidence; prior generated answers are not replayed into the prompt, so a hobby answer cannot contaminate a later research-interest answer. Short follow-up retrieval retains the previous user topic.

Generated answers can still be wrong: citation presence and numerical checks are not complete semantic verification. The source links remain available for inspection. Aliases and regression cases should be expanded as new failure examples arise.

## Two local models

- Fast: `Qwen2.5-1.5B-Instruct-q4f16_1-MLC`.
- Better/default: `Llama-3.2-3B-Instruct-q4f16_1-MLC`.

WebLLM is pinned to 0.2.85. The [official WebLLM catalog](https://github.com/mlc-ai/web-llm/blob/v0.2.85/src/config.ts) lists estimated GPU memory of 1629.75 MB and 2263.69 MB for these configurations. These are estimates, not download sizes or guarantees for every browser. Llama 3.2 1B was rejected after browser testing produced unsupported activities and dates in hobby answers. The 3B model is the default for answer quality.

Model switching unloads the previous engine. Retry model unloads and reloads the selected engine after a failure. A smaller model can still produce weaker phrasing or unsupported details; the checks are limited.

## Natural-language retrieval regression

Question contractions and possessives are normalized before scoring, common verb/plural forms share tokens, and profile topics include natural experience/background aliases. A research overview handles broad research questions. The reported “what’s your football experience” failure and nearby phrasings are covered by regression tests, alongside unknown personal-detail questions. Module URLs are versioned for this fix so reloading does not retain the earlier retrieval code.
