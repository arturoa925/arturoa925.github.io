# arturoa925.github.io — working notes for Claude

Arturo's portfolio site, built in Swift with Ignite and deployed to GitHub Pages
(https://arturoa925.github.io) by `.github/workflows/deploy.yml` on every push to `main`.

## Content rules

- The site is about the code he produces. **Technical posts only**: Swift, DSA, build process,
  debugging, testing, full-stack. No journey stories, quote posts, job asks or open questions.
- First person, direct, plain words. Short paragraphs. Every claim gets a *why*.
- Facts about his apps must match the repos (Daily-Protocol, Axis, Drift, FITNESS-client,
  FITNESS-server under github.com/arturoa925). Read the code or README before stating them.
- Never invent his thoughts or experiences ("where my head was"). Ask him or leave it out.
- Compile and run any Swift snippet before publishing it.
- Avoid: dot-joined meta strings, "→" on links, all-caps labels, em-dash label fragments.

## Adding a post

Create `Content/writing/<slug>.md`:

```markdown
---
image: https://arturoa925.github.io/images/og.png
layout: PostPage
date: 2026-11-11 09:00
tags: Swift, Testing
description: One sentence shown in the writing list.
---
# Title in sentence case

Body…
```

Tags in use: Swift, DSA, Process, Debugging, Testing, Full-stack, Design.

## Adding or editing a project

`Content/projects/<slug>.md` with front matter `layout: ProjectPage`, `order` (position in
lists), `platform` (right-hand label), `subtitle`, `stack` (comma-separated), `repo`, `image`.
Case study sections: TL;DR, What it does, Architecture, Code choices and why, Testing,
What's next. "Where my head was" only from Arturo's own words.

## Résumé

Two copies must stay in sync: `Sources/Pages/Resume.swift` (web page) and
`Assets/files/arturo-ayala-resume.pdf` (download, one page, no phone number).

## Build and check locally

Swift 6.0 toolchain; on Linux a debug build works (a release build crashes the 6.0 optimizer
inside Ignite, so CI uses `swift run`, not `-c release`).

```bash
swift run                              # writes the site to Build/
python3 -m http.server -d Build 8765   # preview at http://localhost:8765
```

Check new pages at desktop (1280px) and phone (390px) widths, in light and dark mode,
and confirm internal links resolve before pushing.

## Design tokens

Defined in `Assets/css/site.css`: paper #FCFCFD, ink #15171C, graphite #4A5060, mist #6B7080,
hairline #E7E8EC, Swift orange #F05138 (accent: caret, link hover, focus only). Geist / Geist Mono.
Dark mode overrides the same variables under `prefers-color-scheme: dark`.
Interactive touches live in `Assets/js/site.js` and must respect reduced motion and touch screens.

## Deploy

Commit to `main` and push. Watch the "Build and deploy site" workflow; it takes about 2 minutes.
