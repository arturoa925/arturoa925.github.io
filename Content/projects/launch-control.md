---
image: https://arturoa925.github.io/images/og.png
layout: ProjectPage
order: 1
platform: iOS
date: 2026-11-01
subtitle: A focused daily planner for iPhone that you can drive from Siri, Shortcuts and your notifications.
stack: Swift, SwiftUI, SwiftData, App Intents, UserNotifications, Swift Concurrency, Swift Testing, XCUITest
repo: https://github.com/arturoa925/Daily-Protocol
tags: iOS, Swift
---
# Launch Control

## TL;DR

- A three-screen daily planner: today's events, a calendar, and weekly and monthly completion charts, one swipe apart.
- Siri, Shortcuts and notification actions all read and write **one shared SwiftData store**, so a change from anywhere shows up everywhere.
- Swift 6 strict concurrency, self-healing persistence, full VoiceOver support, and unit plus UI tests.

## What it does

The app is a vertical pager with three screens:

| Screen | What it does |
| --- | --- |
| **Protocol** | Today's events, the date, and your current streak |
| **Calendar** | Pick any date to see, add and manage its events |
| **Completion** | A weekly bar chart of completed vs. total events, plus a 4-week monthly view |

Events are built for quick, gesture-first use: **swipe right** to complete, **swipe left** to undo, **long-press** for notes, **double-tap** to set a category. Reminders carry a **Mark Complete** action, so you can finish an event without opening the app. And you can do all of it hands-free with Siri:

- "Add event for today in Launch Control"
- "Mark *[event]* done in Launch Control"
- "What do I have today in Launch Control"

## Architecture

```text
SwiftUI Views ──► EventEditor (editing state + actions) ──► SwiftData ModelContext
      │                                                         ▲
      └── CompletionCalculator / StreakCalculator (pure logic)  │
                                                                │
App Intents (Siri) ──► IntentContainer (actor) ─────────────────┤
Notification action ──► EventNotificationDelegate ──────────────┘
                     Shared store in the App Group
```

Views stay thin. Editing logic lives in `EventEditor`, and anything that's just math (streaks, week and month ranges, completion counts) lives in stateless types that take an injectable `Calendar` and reference date, so they're easy to test.

## Code choices and why

### One shared store in an App Group

The app has three entry points: the UI, the App Intents that Siri runs, and the notification delegate. If each one opened its own store, a task completed from Siri wouldn't show up in the app. So all three open the same `LaunchControl.store` file inside an **App Group** container.

### An actor to hand out the container

App Intents run their queries off the main actor. Under Swift 6 strict concurrency, sharing a `ModelContainer` across those contexts produced data-race errors. The fix was a small actor that creates the container once and hands it to any async context safely:

```swift
private actor IntentContainer {
    static let shared = IntentContainer()
    private var container: ModelContainer?

    func get() throws -> ModelContainer {
        if let existing = container { return existing }
        let schema = Schema([Event.self])
        let appGroupID = "group.AA.Launch-Control"
        let config: ModelConfiguration
        if let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) {
            config = ModelConfiguration(schema: schema, url: groupURL.appendingPathComponent("LaunchControl.store"))
        } else {
            config = ModelConfiguration(schema: schema)
        }
        let fresh = try ModelContainer(for: schema, configurations: [config])
        container = fresh
        return fresh
    }
}
```

### Real entities for Siri, not strings

Events are exposed to Siri as an `AppEntity` with an `EntityQuery` and `EntityStringQuery`. That lets Siri suggest today's open events and search them by title, instead of making the user say an exact string.

### Persistence that heals instead of crashing

If the store fails to load, the app logs the error, deletes the store files and tries again. If that also fails, it falls back to an in-memory store. A planner that crashes on launch is worse than one that starts empty.

### A streak rule that matches how people think

`StreakCalculator` counts consecutive days with at least one completed event. If you haven't completed anything *yet today*, it counts from yesterday, so your streak doesn't drop to zero the moment the day starts.

### Accessibility as a feature, not a pass

Every gesture has a VoiceOver equivalent through named actions (mark complete, edit notes, choose category). Pages that aren't on screen are removed from the accessibility tree, the pager responds to the three-finger scroll, and animations respect Reduce Motion.

### Privacy by default

No accounts, no network calls, no analytics. The app ships a privacy manifest that declares no collected data types.

## Testing

- **Unit tests** with Swift Testing cover `EventEditor`, display formatting, settings, and the pager's scroll-edge logic.
- **UI tests** with XCUITest cover the main flows: adding and deleting events, notes, adding from the calendar, switching chart views, settings that persist across relaunches, and accessibility of off-screen pages.
- Launching with `-uiTestReset` wipes the store and settings, so every UI test starts from the same empty state.

## What's next

Dynamic Type support across every screen, more test coverage around the App Intents, and an App Store release.
