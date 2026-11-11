---
image: https://arturoa925.github.io/images/og.png
layout: PostPage
date: 2026-10-04 09:00
tags: Debugging, Swift, Testing
description: Some bugs only exist in the real world. Why I test location and network features by walking into garages and basements.
---
# The simulator will never show you this bug

Some bugs don't exist in the simulator. You have to walk into a garage or a basement to find them.

The simulator gives you perfect conditions: a steady location, instant network, a device that's never under load. Real phones live in elevators, parking structures, subway stations and dead zones. If your app depends on location or the network, those are the places it breaks.

## What changes when signal drops

**Location gets worse before it disappears.** GPS doesn't switch off. Updates slow down, `horizontalAccuracy` grows from a few meters to hundreds, and the reported position jumps. An app that trusts every update will teleport the user or jitter in place.

**Network requests hang instead of failing.** A weak connection is worse than no connection. Requests can sit for a long time before timing out, and a UI that waits on them looks frozen.

**Sensors keep reporting.** The compass and motion sensors still work underground, so you can get a confident heading with a badly wrong position.

## What I check now

- **Filter by accuracy.** Ignore or down-weight location updates with poor `horizontalAccuracy` instead of treating every fix as truth.
- **Smooth between fixes.** In Drift, the app estimates position along your velocity between GPS fixes and eases toward each new one, and it snaps you to the nearest real road within 25 meters, so drift doesn't put you inside a building.
- **Keep the last good state.** In Drift, a failed weather fetch records the error but keeps the last condition it fetched, so the screen never falls back to a broken state. Time of day is calculated on the device, so it still works offline.
- **Time out on purpose.** Set request timeouts and show a clear state instead of an endless spinner.
- **Queue writes.** In my FITNESS app, every write goes to local storage first and into a queue that replays when connectivity returns, so nothing the user did is lost.

## How I test it

- Walk the app through a parking garage, an elevator and a basement.
- Use the **Network Link Conditioner** to simulate bad connections on purpose.
- Turn on Airplane Mode in the middle of an action.

The simulator is great for building. The real world is where you find out whether what you built actually holds up.
