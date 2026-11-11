---
image: https://arturoa925.github.io/images/og.png
layout: PostPage
date: 2026-11-01 09:00
tags: Process, Swift
description: Before I build a feature, I map the screens and the data loop in Figma and ask "what breaks?" at every arrow.
---
# Figma first: mapping the loop before I write code

Before I build anything, I map it out in Figma. Not polished mockups, just two things side by side:

- **The screens:** what the user sees.
- **The data loop:** what happens behind them, as **input → processing → output → feedback**.

Then I go arrow by arrow and ask one question: **"What breaks?"**

It takes a short while, and it catches problems that would take hours to debug later.

## A real example: "Mark Complete" from a notification

In Launch Control, my daily planner, reminders have a **Mark Complete** button right on the notification. Here's the loop:

1. **Input:** the user taps *Mark Complete* on the notification.
2. **Processing:** the notification delegate finds the event and marks it done.
3. **Output:** the event is saved.
4. **Feedback:** the app shows the event as completed and the streak updates.

Now, what breaks at each arrow?

- **Input → Processing:** the app might not be running. The delegate has to work without the UI being alive.
- **Processing → Output:** where does it save? If the delegate opens its own data store, the app won't see the change.
- **Output → Feedback:** the next time the app opens, does it show the new state, or a stale copy?

Those questions led to an architecture decision before I wrote any feature code. The app, the Siri App Intents, and the notification delegate all open **one shared SwiftData store in an App Group**. A change from any entry point shows up everywhere.

```text
SwiftUI views ───────────┐
App Intents (Siri) ──────┼──► one SwiftData store (App Group)
Notification action ─────┘
```

If I had started in Xcode, I would have built the feature for the app first and found the notification problem much later.

## How I run the check

- **One frame per screen** and **one row of boxes for the data**, with arrows between them.
- At every arrow I write the failure cases in a sticky note: no network, no permission, app killed, empty data, a duplicate tap.
- Every sticky note becomes either a design change or a test case.

## Why it's worth it

Code is expensive to change once it exists. A box in Figma isn't. Asking "what breaks?" while things are still boxes is the cheapest debugging I'll ever do.
