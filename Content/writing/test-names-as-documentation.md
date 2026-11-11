---
layout: PostPage
date: 2026-09-10 09:00
tags: Testing, Swift
description: If your test names don't explain themselves, are they documentation or just a checkbox? How I name tests with Swift Testing.
---
# Test names are documentation

If your test names don't explain themselves, are they really documentation, or just a checkbox?

A good test suite tells a new developer how the code behaves without them reading the implementation. The test names do most of that work. `testStreak2()` tells you nothing. A sentence tells you the rule.

## Name the behavior, not the function

In Launch Control, my daily planner, the streak has one rule that surprises people: if you haven't completed anything **yet today**, the streak counts from yesterday, so it doesn't reset to zero the moment a new day starts.

That rule deserves a test whose name *is* the rule. Swift Testing makes this easy, because `@Test` takes a display name:

```swift
import Testing

@Suite("Streak calculation")
struct StreakCalculatorTests {
    @Test("Streak counts from yesterday when nothing is completed today")
    func streakCountsFromYesterday() {
        // ...
    }

    @Test("Streak resets after a day with no completed events")
    func streakResetsAfterGap() {
        // ...
    }
}
```

Read the test navigator and you get a spec:

- Streak calculation
    - Streak counts from yesterday when nothing is completed today
    - Streak resets after a day with no completed events

## A pattern that works

For each test I write the name as **"[thing] [does what] when [condition]"**:

- "Mark Complete updates the event when the app isn't running"
- "Routine order stays in sequence when an exercise is removed"
- "Completed workout is queued when the phone isn't reachable"

If I can't write that sentence, I usually don't understand the behavior well enough to test it yet.

With XCTest, the same idea works in the method name: `test_streak_countsFromYesterday_whenNothingCompletedToday()`. It's longer, but it reads.

## Why it matters

- **Failures explain themselves.** "Streak resets after a day with no completed events — failed" tells you what broke before you open the file.
- **Tests outlive memory.** Six months from now, the name is how I'll remember why a weird rule exists.
- **It changes how I write the test.** One clear behavior per name means one clear assertion per test.

Tests that only check a box protect the code today. Tests that explain themselves also protect it from the next person to touch it, and that's often me.
