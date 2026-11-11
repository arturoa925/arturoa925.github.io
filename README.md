# arturoa925.github.io

My portfolio site: case studies of my iOS, watchOS and full-stack apps, technical writing, and my résumé.

**Live at [arturoa925.github.io](https://arturoa925.github.io)**

Built in Swift with [Ignite](https://github.com/twostraws/Ignite), a static site generator with a SwiftUI-like syntax, and deployed to GitHub Pages with GitHub Actions on every push to `main`.

## Structure

```
Sources/
├── Site.swift            # Site configuration, pages and layouts
├── Theme.swift           # Light and dark color themes
├── Layouts/MainLayout    # Nav bar, content, footer on every page
├── Pages/                # Home, Projects, Writing, Résumé, About
├── ArticlePages/         # Layouts for case studies and posts
└── Components/           # Nav bar, footer, project cards, post rows
Content/
├── projects/             # One Markdown case study per app
└── writing/              # Articles
Assets/
├── css/site.css          # Small layout fixes on top of Bootstrap
└── files/                # Résumé PDF
```

## Run it locally

Requires Swift 6 (Xcode 16 or later on macOS).

```bash
swift run                      # builds the site into Build/
python3 -m http.server -d Build 8000
```

Then open http://localhost:8000.

## Add a post

Create a Markdown file in `Content/writing/`:

```markdown
---
layout: PostPage
date: 2026-11-10 09:00
tags: Swift, Testing
description: One-sentence summary shown in lists.
---
# Post title

Body text…
```

Push to `main` and the site rebuilds automatically.
