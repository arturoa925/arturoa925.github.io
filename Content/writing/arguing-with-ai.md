---
layout: PostPage
date: 2026-10-28 09:00
tags: Process
description: The best developers argue with their AI. How I use AI to understand code, not just to produce it.
---
# Arguing with your AI

The best developers argue with their AI.

I used to be against AI assistance. Now I use it every day, but with a rule: **AI speeds up the typing. I make the decisions.** Architecture and algorithm choices stay with me. Boilerplate, test scaffolding and debugging help are fair game.

## Two ways I've used it

**In Launch Control and Axis**, I wrote the code myself and brought AI in for specific jobs: writing tests, chasing down bugs, and making UI tweaks.

**In Drift**, I tried the opposite. It's my first app built entirely by prompting. I came up with the concept and the feel, wrote a detailed design spec (`claude.md`) that gives the AI full context at the start of every session, set the build order, and reviewed every change on a real device.

Drift taught me that prompting well is mostly engineering judgment. Two examples where I pushed back:

- **I dropped MapKit** for a custom street-level renderer drawn in a SwiftUI `Canvas`.
- **I replaced placeholder geometry** with real OpenStreetMap roads and buildings once the placeholder stopped telling me anything useful.

Neither change would have happened if I'd accepted the first output.

## How I argue with it

- **Ask "why" before "write."** I ask the model to explain its approach before it writes code. If the reasoning is weak, the code will be too.
- **Ask for alternatives.** "Give me two other ways to do this and the trade-offs." The first answer is rarely the only good one.
- **Make it show its work in the code.** In Drift, every file has doc comments explaining *why* it works the way it does. That's the part I learn from.
- **Verify on device.** Generated code that compiles isn't the same as code that works. The simulator and a real phone don't always agree.
- **Use it to understand, not to skip understanding.** My best sessions are rabbit holes like "walk me through why Swift 6 flags this as a data race." I come out knowing something, not just having something.

## The risk

If you only accept answers, you stop building judgment, and judgment is exactly what makes the AI useful. Arguing with it is how I keep learning while still moving fast.
