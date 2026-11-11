---
layout: PostPage
date: 2026-10-08 09:00
tags: Debugging, Swift
description: The scariest bugs don't crash. They quietly do nothing. Where silent failures hide in Swift and how I make them loud.
---
# The scariest bugs quietly do nothing

The scariest bugs aren't the ones that crash. A crash gives you a stack trace and a line number. The scary ones just **quietly do nothing**: the button you tap, the save that never saves, the reminder that never fires.

Swift is a safe language, and some of that safety is exactly what makes failures quiet. Here's where I've learned to look.

## 1. `try?` that swallows the error

```swift
try? context.save()   // if this fails, nobody will ever know
```

`try?` turns an error into `nil` and moves on. That's fine when failure truly doesn't matter. For saves, network calls and file writes, it hides the one piece of information you need.

```swift
do {
    try context.save()
} catch {
    logger.error("Save failed: \(error.localizedDescription)")
}
```

## 2. Optional chaining on something that's `nil`

```swift
viewModel?.markComplete(event)
```

If `viewModel` is `nil`, this line does nothing. No warning, no crash. When an action "doesn't work," the first thing I check is whether the object I'm calling is actually there.

## 3. A `guard` that returns without a word

```swift
guard let event = events.first(where: { $0.id == id }) else { return }
```

Every early return is a path where the feature silently stops. I add a log line to the ones that should never happen.

## 4. Permissions that were never granted

Notifications, location and the camera all fail politely when permission is denied. Your code runs and nothing happens. Check the authorization status and handle the "denied" case in the UI.

## 5. Work that never reaches the main actor

UI state updated off the main actor, or a `Task` that was cancelled before it finished, can leave the screen showing old data with no error anywhere. Swift 6's strict concurrency checking catches many of these at compile time, which is one reason I turn it on.

## How I make failures loud

- **Log every unhappy path** with `OSLog`. In Launch Control, if the data store fails to load, the app logs the error, rebuilds the store, and falls back to an in-memory store instead of crashing, but it never fails silently.
- **Write tests for the "nothing happened" cases**, not just the happy path.
- **Treat "it did nothing" as a real bug report.** It usually means an error was thrown away somewhere.

A crash is the app telling you something went wrong. A silent failure is the app keeping a secret.
