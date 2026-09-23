# Research-site refresh — September 23, 2026

## Content authority

The current `Resume.pages` is the factual source for dates, roles, advisors, publications, and research metrics. `EdgeAI.pages` was used only for explanatory context; its conflicting performance figures were not imported into the current overview.

The homepage and research page now contain four research experiences. Publications are listed separately, newest first, with Xuming Huang emphasized. The Edge AI overview labels foreground compilation, average KV memory, and CPU sorting as distinct metrics. CASH's energy result remains explicitly modeled and its experiment remains a 5,000-task simulation. Earlier JIT experiment reports retain their original campaign scope and link to the current summary.

The downloadable CV uses the existing two-page PDF matching the current résumé, with corrected destinations for compiler PR #348 and the OS-inference project. The supplied Pages files were not edited.

## Presentation and loading

- Added six local SVG conceptual covers, including a cover for every research and publication entry.
- Added responsive layouts, visible keyboard focus, and working ongoing/completed filters.
- Included research HTML in the initial document for readers without JavaScript and search engines.
- Removed automatic bot-model preloading from ordinary site pages. The bot page remains available.

## Validation

- 83 HTML pages, 684 local references: no missing files or unresolved static anchors.
- 118 unique external URLs checked. Repaired malformed references and stale course, repository, and blog links.
- Remaining automated-access limitations: two LinkedIn profile links return HTTP 999; IEEE's DOI resolves to the intended article with HTTP 202; Wiley's DOI resolves to the intended article but returns HTTP 403 to the checker. These are not counted as verified page-content loads.
- Browser checks at 1280px and 390px: homepage, research, both new project overviews, projects, and blog have no horizontal overflow, broken images, or JavaScript errors. Research filters show one ongoing and three completed entries.
- Local browser QA blocks third-party requests to isolate site behavior; the external-link audit checks remote destinations independently.
- CV: both pages rendered and visually inspected; current metrics and corrected annotation destinations verified.
- JavaScript syntax and `git diff --check` pass.

## Maintenance

Edit `data/publications.js`, then run `npm run render-research` to refresh initial HTML in the homepage and research page. The browser uses the same data for filters. Run `npm run audit` for local references or `python3 scripts/audit-site.py --external` for bounded external checks. The JSON report is written to the system temporary directory.
