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

## Style correction

At the user's request, restored the pre-refresh homepage and research-page format: the original stylesheet, serif typography, blue links, yellow selected rows, circular portrait, left sidebar, table layout, and section navigation. Publications and the two new overviews use the same original table format. Removed the new design stylesheet and filters. Résumé corrections, link repairs, covers, static research HTML, and the current CV remain.

Validation after restoring the style: 83 pages and 686 local references pass. Homepage, research, and both new overviews pass browser checks at 1280px and 390px with no broken images, JavaScript errors, or horizontal overflow. The only addition to the original shared stylesheet is a mobile table-cell sizing fix.


## Follow-up: preserve style and refine content

- Simplified homepage bio to interests and current work; added Michael Swift, Vinay Banakar, and ADSL links.
- Merged Teaching and Service; retained the service anchor for existing bookmarks.
- Limited yellow research highlighting to Edge AI and LinuxGuard; projects highlight the resume's heap allocator, algorithms, Transformer, and GPT work.
- Publication rows use paper figures, full authors, bold venue/year, and expandable BibTeX. CASH Figure 1 was cropped from the supplied published PDF (page 2); the full PDF is in papers/cash-2026.pdf. Filter Figure 1 was retrieved from the publisher's article, DOI 10.1049/mna2.70007, without modifying the image.
- BEIT: publisher abstract verified in browser; figures and PDF require subscription. The invented cover was removed and the image column is intentionally empty pending an original figure. This request remains incomplete for that one cover.
- Removed the two GPU interference posts from the blog listing; their existing URLs remain reachable. Expanded the NPU post to cover compiler sorting caches and the progressive-compilation/copy-and-grow runtime using resume metrics, in the traditional blog layout.
- Courses: 14 compact course blocks, seven lecture PDFs from CS577/CS540. Materials expand on demand. Excluded homework, answer keys, passwords, and private teaching files. ESL118 has no asserted term because the local document does not establish one.
- Validation: local audit across 83 HTML files found no missing files or anchors. External audit: 113/118 returned 200; LinkedIn (two URLs) blocks automated requests, and IEEE/Wiley publication endpoints require normal-browser checks. IEEE and Wiley article pages were confirmed in browser. No claim that subscription content is freely accessible.
- Browser QA: home, research, projects, blog, courses, and NPU article have no horizontal overflow at 390px; desktop layouts checked at 1280px. Publication BibTeX toggles and course disclosure controls work. Exactly two research rows and five resume-related project rows are highlighted; removed blog titles are absent.
