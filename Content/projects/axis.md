---
layout: ProjectPage
order: 2
platform: iOS + watchOS
date: 2026-10-20
subtitle: Build strength routines on iPhone, run them set by set on Apple Watch, and review every session in your history.
stack: Swift, SwiftUI, SwiftData, WatchConnectivity, watchOS, Swift Testing
repo: https://github.com/arturoa925/Axis
tags: iOS, watchOS, Swift
---
# Axis

## TL;DR

- A two-device strength-training app: **plan on iPhone, train on Apple Watch, review on iPhone.**
- The sync sends only small `Codable` payloads, and each direction uses the WatchConnectivity transport that fits its job.
- About 100 Swift Testing tests across the iPhone and Watch targets.

## What it does

1. **Plan on iPhone.** Build a routine from a library of 141 exercises, filter by equipment, and set target sets and reps.
2. **Train on Apple Watch.** Routines show up on the Watch automatically. Start one, count reps with + and − buttons, and complete each set. Axis moves to the next exercise on its own, and paused time doesn't count toward the workout.
3. **Review on iPhone.** When you finish, the Watch sends a summary back, and the phone saves it to History.

Both apps also switch between a day theme and a night theme based on the time, with no toggle needed.

## Architecture

```text
 iPhone                                         Apple Watch
┌──────────────────────────┐                  ┌──────────────────────────┐
│ Create / edit routines   │ ── templates ──► │ Pick a routine           │
│ (SwiftData)              │                  │ Track reps & sets        │
│ History of completed     │ ◄── workout ──── │ Session complete         │
│ workouts                 │                  │                          │
└──────────────────────────┘                  └──────────────────────────┘
```

On the phone, SwiftData holds two separate shapes of data:

```text
WorkoutTemplate ──► [TemplateExercise] ──► Exercise     (the plan)
CompletedWorkout ──► [CompletedExercise]                 (what you actually did)
```

## Code choices and why

### History is a snapshot, not a reference

A completed workout is stored as its own `CompletedWorkout`, separate from the routine it came from. If it pointed at the routine instead, editing a routine next week would silently rewrite last week's history.

### SwiftData stays on the phone

Only lightweight `Codable` payloads cross the connection. The Watch never needs the full data model, and keeping the models on one device avoids two databases drifting apart.

### The right transport for each direction

| Direction | Transport | Why |
| --- | --- | --- |
| iPhone → Watch (routines) | `updateApplicationContext` | Only the latest set of routines matters, and the Watch gets it the next time it wakes |
| Watch → iPhone (finished workout) | `sendMessage`, falling back to `transferUserInfo` | Instant when the phone is reachable, queued when it isn't, so a workout is never lost |

The fallback is the important part. A workout you just finished is the one thing the app can't afford to drop:

```swift
if WCSession.default.isReachable {
    WCSession.default.sendMessage(message, replyHandler: nil) { _ in
        // phone not reachable in time — queue for background delivery
        WCSession.default.transferUserInfo(message)
    }
} else {
    WCSession.default.transferUserInfo(message)
}
```

### Session logic you can test without a Watch

The live-session logic (rep tracking, completing sets, moving between exercises, pause and resume, building the payload) lives in `WatchWorkoutSession`, separate from the views. That's what made it possible to test the whole session from start to finish.

### Accessibility in the timing

When VoiceOver is on, the onboarding's timed transitions wait for you to tap **Continue**, so focus isn't pulled away while it's still reading.

## Testing

- **iPhone (51 tests):** converting a Watch payload into a `CompletedWorkout`, the template and history models, equipment types, and routine editing and validation.
- **Watch (51 tests):** `WatchWorkoutSession` from start to finish, including pausing, resuming and the last-exercise check.

## What's next

- HealthKit workout sessions on the Watch for heart rate and active calories. `CompletedWorkout` already has fields ready for both.
- Custom exercises (the model already supports them).
- Progress charts in History.
