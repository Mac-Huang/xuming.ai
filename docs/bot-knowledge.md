# Bot knowledge and model choices

The bot uses current résumé facts and public website content. It does not have access to private files or unpublished personal information. Curated profile records take precedence over historical blog posts. Research appointments and published papers are separate categories.

## Updating content

1. Update the public pages/data and the curated résumé records in `scripts/build-bot-knowledge.py` when facts change.
2. Run `python3 scripts/build-bot-knowledge.py` with Node on PATH (or set `SITE_NODE` to its executable).
3. Run `node --test tests/bot-core.test.mjs` and `python3 scripts/audit-site.py`.
4. Commit the generated `data/bot-knowledge.json` with the content changes.

The generated knowledge version is a hash of the content. The browser fetches it with cache revalidation, replacing the old chunk-count-only embedding cache. The September 23 build contains 169 records, including all 24 listed projects, actual publications, current coursework, and full prose from the listed blogs.

## Retrieval and answers

Named-person and common profile questions return curated evidence directly. Other questions use weighted lexical retrieval with relevance thresholds and source deduplication. No arbitrary top-five sources are added. The source panel lists only cited records. Missing citations, unsupported numbers, first-person impersonation, model failures, and model refusals despite retrieved evidence fall back to attributed excerpts. Unknown questions without matching evidence return an explicit unknown answer.

Generated answers can still be wrong: citation presence and numerical checks are not complete semantic verification. The source links remain available for inspection. Aliases and regression cases should be expanded as new failure examples arise.

## Two local models

- Fast/default: `Llama-3.2-1B-Instruct-q4f16_1-MLC`.
- Better: `Llama-3.2-3B-Instruct-q4f16_1-MLC`.

WebLLM is pinned to 0.2.85. The [official WebLLM catalog](https://github.com/mlc-ai/web-llm/blob/main/src/config.ts) lists estimated GPU memory of 879.04 MB and 2263.69 MB for these configurations. These are estimates, not download sizes or guarantees for every browser. The compared Qwen3 0.6B/4B configurations have larger catalog memory estimates (1403.34/3431.59 MB). The existing Llama family provides a smaller default and a more capable alternative without introducing a third option.

Both Llama configurations loaded successfully in browser testing. The 1B model sometimes declined a supported technical question; the source-excerpt fallback handles that case. Model switching unloads the previous engine. With no WebGPU or a failed download, sourced evidence answers remain available.
