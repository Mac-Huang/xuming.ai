# Academic Portfolio Template (Minimal, No Frameworks)

A minimal academic portfolio template inspired by Jon Barron’s design philosophy, built with plain HTML, CSS, and JavaScript. Use it as a clean starting point for your own academic homepage.

## Overview

This repository contains the website scaffolding only. It intentionally avoids bundling any private or proprietary research/project source code. Replace content with your own details and link out to public repos or papers you choose to share.

## Demo/Deployment

- Local: open `index.html` directly, or run a static server.
- GitHub Pages: push to a `username.github.io` repo or enable Pages in repository settings.

Example (Python):

```bash
python -m http.server 8000
# then visit http://localhost:8000
```

## Features

- Research and publications sections with simple, readable layout
- Optional blog/posts structure for long-form notes
- Minimal JS (no frameworks) and fast loading
- Clean typography and accessible color contrast

## Project Structure

```
.
├── index.html          # Main landing page
├── research.html       # Research and publications
├── projects.html       # Project showcase (you add your own items)
├── blog.html           # Blog listing (optional)
├── courses.html        # Courses/teaching (optional)
├── bot.html            # Simple keyword-based assistant (optional)
├── stylesheet.css      # Global styles
├── data/               # Example data files (replace with yours)
├── demos/              # Example demo pages (can remove or repurpose)
├── blog/posts/         # Example posts (optional; use or delete)
├── js/                 # Minimal JS for interactivity
└── images/             # Assets
```

Note: Specific files that reference personal projects are placeholders. Feel free to delete folders you don’t need (e.g., `blog/`, `demos/`).

## Quick Start

1. Use this repo as a template (or clone and remove personal content).
2. Update text and links in `index.html`, `research.html`, and `projects.html`.
3. Replace images under `images/` with your own.
4. Edit colors/typography in `stylesheet.css` (primary color defaults to `#1772d0`).
5. Update contact info and any email obfuscation logic in `js/main.js`.

## Hiding Private Projects (Important)

This template does not include any private or unpublished project source code. If you showcase projects:

- Describe at a high level; do not embed proprietary code.
- Link only to public repositories or published artifacts you’re comfortable sharing.
- Remove or rename any demo pages that might reveal internal code. You can safely delete the `demos/` folder if not needed.

## Design Notes

- Clean, table-style layout inspired by Jon Barron
- Minimal JavaScript; no build tools required
- Fast to load, easy to customize

## Attribution

You are free to use and adapt this template for your own academic website. If you reuse substantial portions, a small attribution is appreciated.

— Built for clarity and simplicity —

