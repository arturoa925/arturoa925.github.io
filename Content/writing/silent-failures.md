---
image: https://arturoa925.github.io/images/og.png
layout: PostPage
date: 2026-10-08 09:00
tags: Debugging, Swift
description: The scariest bugs don't crash. They quietly do nothing. Where silent failures hide in Swift, and four layers to catch them: code, UI, tests and logs.
---
# The scariest bugs quietly do nothing

The scariest bugs aren't the ones that crash. A crash gives you a stack trace and a line number. The scary ones just **quietly do nothing**: the button you tap, the save that never saves, the reminder that never fires.

Swift is a safe language, and some of that safety is exactly what makes failures quiet. Here's where they hide, and then the four layers I use to catch them: in the code, in the UI, in tests, and while the app is running.

## Where they hide

### 1. `try?` that swallows the error

```swift
try? context.save()   // if this fails, nobody will ever know
```

`try?` turns an error into `nil` and moves on. That's fine when failure truly doesn't matter. For saves, network calls and file writes, it hides the one piece of information you need.

**Fix:** catch it, log it, and decide what the user should see.

```swift
do {
    try context.save()
} catch {
    Logger.data.error("Save failed: \(error.localizedDescription, privacy: .public)")
    saveError = error
}
```

### 2. Optional chaining on something that's `nil`

```swift
viewModel?.markComplete(event)
```

If `viewModel` is `nil`, this line does nothing. No warning, no crash.

**Fix:** ask why it's optional at all. Most of the time the dependency should be passed in through `init`, so it can't be missing. If it really can be `nil`, unwrap it with a `guard` and say so when it isn't there.

### 3. A `guard` that returns without a word

```swift
guard let event = events.first(where: { $0.id == id }) else { return }
```

Every early return is a path where the feature silently stops.

**Fix:** if the path should never happen, make it loud in development and recorded in production.

```swift
guard let event = events.first(where: { $0.id == id }) else {
    Logger.data.fault("markComplete: no event with id \(id, privacy: .public)")
    assertionFailure("Event \(id) not found")
    return
}
```

`assertionFailure` stops the debugger on the exact line while I'm building, and does nothing in a release build. The `fault` log is what's left to find later.

### 4. Permissions that were never granted

Notifications, location and the camera all fail politely when permission is denied. Your code runs and nothing happens.

**Fix:** check the status every time it matters, not just at onboarding. The user can turn it off in Settings at any time.

```swift
let settings = await UNUserNotificationCenter.current().notificationSettings()
if settings.authorizationStatus == .denied {
    showNotificationsOffBanner = true   // explain it, link to Settings
}
```

### 5. Work that never reaches the main actor

UI state updated off the main actor, or a `Task` that was cancelled before it finished, can leave the screen showing old data with no error anywhere.

**Fix:** mark the types that own UI state `@MainActor`, and turn on Swift 6's strict concurrency checking. Many of these become compile errors instead of mysteries.

## Layer 1: make the code refuse to stay quiet

A few rules cover most of the list above:

- **No `try?` on anything that writes.** Saves, network calls and file writes get a `do`/`catch`. Every `try?` left in the project needs a reason I could say out loud.
- **Every "should never happen" path logs at `.fault`** and calls `assertionFailure`.
- **Don't return `Bool` or `nil` for failures that have a cause.** Throw an error with a name, so the caller can't confuse "failed" with "nothing to do."

## Layer 2: tell the user

A failure the user can see is a failure that gets reported. The worst version is a UI that shows a change that never saved: the checkmark appears, the user moves on, and the data is gone next launch.

So the model owns the error, and it undoes what it couldn't save:

```swift
public struct Event: Identifiable, Sendable {
    public let id: Int
    public var isDone = false
    public init(id: Int) { self.id = id }
}

public protocol EventStore {
    func save(_ events: [Event]) throws
}

@MainActor
public final class PlannerModel {
    public private(set) var events: [Event]
    public private(set) var lastError: Error?
    private let store: EventStore

    public init(events: [Event], store: EventStore) {
        self.events = events
        self.store = store
    }

    public func markComplete(id: Int) {
        guard let index = events.firstIndex(where: { $0.id == id }) else {
            lastError = PlannerError.eventNotFound(id)
            return
        }
        events[index].isDone = true
        do {
            try store.save(events)
        } catch {
            events[index].isDone = false   // don't show a change that wasn't saved
            lastError = error
        }
    }
}

public enum PlannerError: Error { case eventNotFound(Int) }
```

The view watches `lastError` and shows an alert or a banner. The important part is the `catch`: the screen only shows what's actually stored.

## Layer 3: test the "nothing happened" path

Happy-path tests pass even when a failure is silent, because they never make anything fail. So I write tests that force the failure and check that it's reported, using a store that always throws:

```swift
struct FailingStore: EventStore {
    struct DiskFull: Error {}
    func save(_ events: [Event]) throws { throw DiskFull() }
}

@MainActor
@Test func saveFailureIsReportedNotSwallowed() {
    let model = PlannerModel(events: [Event(id: 1)], store: FailingStore())
    model.markComplete(id: 1)
    #expect(model.lastError != nil)
    #expect(model.events[0].isDone == false)
}
```

The second `#expect` matters as much as the first. It checks that the UI didn't keep a change the store rejected. I also keep one test per action that checks the state really changed afterward. "It ran without throwing" isn't the same as "it did something."

## Layer 4: watch it while it runs

Crash reports in Xcode's Organizer catch crashes and hangs. They can't catch a silent failure, because to the system nothing went wrong. Logs are the only witness, so they have to be easy to find.

- **One subsystem, a few categories.** Give the logger a name so you can filter to your app and nothing else:

  ```swift
  import OSLog

  extension Logger {
      static let data = Logger(subsystem: "com.example.planner", category: "data")
      static let notifications = Logger(subsystem: "com.example.planner", category: "notifications")
  }
  ```

- **Watch the stream while testing.** Console.app filtered by subsystem works for a connected iPhone. For the simulator:

  ```text
  xcrun simctl spawn booted log stream --level debug --predicate 'subsystem == "com.example.planner"'
  ```

- **Bring the logs to the device.** When you're testing away from a Mac, a hidden debug screen can list this launch's errors with `OSLogStore`:

  ```swift
  let store = try OSLogStore(scope: .currentProcessIdentifier)
  let problems = try store.getEntries()
      .compactMap { $0 as? OSLogEntryLog }
      .filter { $0.subsystem == "com.example.planner" && $0.level.rawValue >= OSLogEntryLog.Level.error.rawValue }
  ```

- **Audit before every release.** `grep -rn "try?" .` and read every hit. It takes a minute, and it's the cheapest way to find the errors you're throwing away.

In Launch Control, the data store follows these rules: if it fails to load, the app logs the error, rebuilds the store, and falls back to an in-memory store instead of crashing, but it never fails silently.

## The short version

- Find where errors get thrown away: `try?`, optional chaining, bare `return`, denied permissions, cancelled tasks.
- Make each one loud: a log, an assertion, or an error the user can see.
- Prove it with a test that forces the failure.
- Keep the logs easy to find, because for a silent failure they're the only evidence.

A crash is the app telling you something went wrong. A silent failure is the app keeping a secret.
