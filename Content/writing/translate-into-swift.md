---
image: https://arturoa925.github.io/images/og.png
layout: PostPage
date: 2026-11-02 09:00
tags: Full-stack, Swift, Process
description: My method for unfamiliar code. Read it for what it does, then rewrite the idea in Swift.
---
# Learning unfamiliar code by translating it into Swift

When I hit unfamiliar code, I do two things:

1. **Read it for what it does, not how it's written.** I ignore syntax at first and describe the behavior in one sentence.
2. **Ask: "How would I write this in Swift?"**

Seeing the same idea in two languages is where the understanding sticks. The syntax stops mattering, and the actual concept is what's left.

## An example from my own code

My FITNESS app has a JavaScript and React Native client. Here's the kind of thing that shows up when grouping calendar entries by day:

```javascript
const byDate = entries.reduce((groups, entry) => {
  const key = entry.date;
  if (!groups[key]) groups[key] = [];
  groups[key].push(entry);
  return groups;
}, {});
```

**What it does:** turns a flat list of entries into a dictionary keyed by date.

**In Swift:**

```swift
let byDate = Dictionary(grouping: entries, by: \.date)
```

One line. Translating it taught me two things:

- `reduce` with an object accumulator in JavaScript is often just "group by" in disguise. Once I saw that, I started recognizing the pattern everywhere.
- Swift's standard library has names for intents that JavaScript makes you build by hand. `Dictionary(grouping:by:)`, `compactMap` and `reduce(into:)` say what you mean.

## Going the other direction works too

It also works backwards. When I study Swift concurrency, I compare it with what I already knew from JavaScript:

| JavaScript | Swift |
| --- | --- |
| `async function` / `await` | `async` func / `await` |
| `Promise.all` | `async let` or a `TaskGroup` |
| A single-threaded event loop | Actors and `@MainActor` for isolation |

The last row is where the mental models differ. JavaScript avoids data races by running one thing at a time. Swift lets work run in parallel and uses actors to protect shared state. The comparison showed me *why* Swift 6 reports errors that JavaScript never would.

## Why this works

Translating forces you to understand the intent. You can't rewrite something you only half understand. And because I came to Swift from full-stack JavaScript, every new Swift concept has a hook to hang on.
