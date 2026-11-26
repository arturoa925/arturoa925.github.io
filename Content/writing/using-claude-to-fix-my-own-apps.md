---
image: https://arturoa925.github.io/images/og.png
layout: PostPage
date: 2026-11-26 12:00
tags: Debugging, Process
description: How I work with Claude on bug fixes in my Swift projects, including a visual bug in Drift, and the checks I run before I accept a fix.
---
# How I use Claude to fix my own apps, and what I check before I accept it

When something breaks in one of my projects, I don't start by staring at the code anymore. I start by describing the problem to Claude: what I expected, what happened, and where I think it's coming from. A few minutes later I have a proposed fix.

That part is easy. What I do next is the part that matters.

## A real example

In Drift, one of my iOS apps, the buildings and street names weren't rendering the way I expected. In real life, buildings sit side by side. In my app, they were overlapping.

A bug like that is hard to describe in words, so I gave Claude references from other apps and software that get it right. That way it had a picture of what "correct" looks like instead of guessing from my description.

Since it was all visual work, I couldn't trust the code to tell me whether it was fixed. I ran it on my own device and looked at it in the real world. I also used the simulator to check different locations, because a map that looks right in one place can break in another.

## What it's good at

It reads a lot of code quickly, and it explains its reasoning so I can check it. It's also useful when I can show it a reference. The more clearly I describe what "right" looks like, the better the fix. It also handles repetitive work and small edits, so my time goes to decisions.

## What I don't hand off

A fix that compiles isn't necessarily a fix that's right. Before I accept one, I do four things:

1. **Read the diff.** If I can't explain a change, I don't merge it.
2. **Run it myself.** I test on a real device where it matters, not just wherever Claude ran it. For visual bugs, my eyes are the test.
3. **Check more than one case.** Different locations, empty data, denied permissions, things happening twice. Edge cases are where fixes tend to fail.
4. **Ask what else it could break.** A fix in one place can quietly change behavior somewhere else.

## Why I work this way

I'm still the one responsible for the app. AI makes me faster, but it doesn't change who decides. I keep the architecture and trade-offs for myself and use Claude for speed.

The more it can do, the more I want to understand what it did. That's how I keep improving instead of just collecting code.
