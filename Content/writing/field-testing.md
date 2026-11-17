---
image: https://arturoa925.github.io/images/og.png
layout: PostPage
date: 2026-10-04 09:00
tags: Debugging, Swift, Testing
description: Some bugs only exist in the real world. Eight everyday places your users lose signal, what breaks there, and how to test for it outside the simulator.
---
# The simulator will never show you this bug

Some bugs don't exist in the simulator. You have to walk into a garage or a basement to find them.

The simulator gives you perfect conditions: a steady location, instant network, a device that's never under load. Real phones live in elevators, parking structures, subway stations and dead zones. If your app depends on location or the network, those are the places it breaks.

The surprising part is that **"no signal" is the easy case.** The phone knows it's offline, and so can your app. The hard cases are the ones where the phone *looks* connected and isn't, or connects and then changes its mind halfway through a request.

## Eight places your users lose signal

### 1. The coffee shop Wi-Fi they never signed into

The phone joins a café, hotel or airport network that needs a login page first. The Wi-Fi icon shows full bars, so the network looks available. Every request your app sends gets back the login page instead of your API.

**What breaks:** your JSON decoding fails on an HTML page, and if that error is swallowed, the screen just stays empty. "Connected" and "online" are not the same thing.

### 2. Full bars, no data

A stadium, a concert, a festival, a busy train station. Thousands of phones share the same towers. The signal is strong, but almost nothing gets through.

**What breaks:** requests don't fail, they hang. By default, `URLSession` waits 60 seconds for data before giving up on a request, and up to 7 days for the whole transfer. To the user, a spinner that runs for a minute is a frozen app.

### 3. Walking out the front door

A request starts on home Wi-Fi. Halfway down the driveway, the phone drops Wi-Fi and moves to cellular.

**What breaks:** the request that was in flight dies with a "connection lost" error, even though the phone is online again a second later. If the app treats that as a final failure, the user sees an error for something a single retry would have fixed.

### 4. The elevator that eats the response

This is the one that surprises people most. The user taps **Save**, the request reaches your server, the server saves it, and then the elevator doors close before the response comes back.

**What breaks:** the app thinks the save failed. The user taps Save again. Now the workout is logged twice. On the server, a timeout doesn't mean "it didn't happen." It means "I don't know if it happened."

### 5. The subway between stations

Signal comes and goes every couple of minutes. The app reconnects, starts syncing, loses signal, and starts over.

**What breaks:** an app that retries instantly and forever burns battery and data, and a large sync that restarts from zero may never finish. Retries need to wait longer each time, and big work needs to resume rather than restart.

### 6. Locking the phone in line

The user starts an upload, locks the phone and puts it in their pocket.

**What breaks:** a regular `URLSession` task doesn't keep running once the app is suspended. For uploads and downloads that must finish, use a background session, which hands the transfer to the system so it can complete while the app isn't running.

### 7. Low Data Mode, Low Power Mode, and the work VPN

None of these are "bad signal," but they behave like it. Low Power Mode pauses Background App Refresh, so the data you expected to be fresh when the app opens may be hours old. Low Data Mode asks apps to cut back on network use. A company or school network or a VPN can block some domains entirely, so the app works at home and fails at the office.

**What breaks:** anything that assumes background work ran on schedule, or that every network can reach every server.

### 8. Downtown, between tall buildings

GPS signals bounce off glass and concrete. The position can land on the wrong side of the street or jump a block, and `horizontalAccuracy` can grow from a few meters to hundreds. Parking garages and basements make it worse.

**What breaks:** an app that trusts every location update will teleport the user, or jitter them in place. The compass and motion sensors keep working underground, so you can get a confident heading with a badly wrong position.

## What I build in now

- **Filter by accuracy.** Ignore or down-weight location updates with poor `horizontalAccuracy` instead of treating every fix as truth.
- **Smooth between fixes.** In Drift, the app estimates position along your velocity between GPS fixes and eases toward each new one, and it snaps you to the nearest real road within 25 meters, so drift doesn't put you inside a building.
- **Keep the last good state.** In Drift, a failed weather fetch records the error but keeps the last condition it fetched, so the screen never falls back to a broken state. Time of day is calculated on the device, so it still works offline.
- **Queue writes.** In my FITNESS app, workouts and food logs go to local storage first and into a queue that replays when connectivity returns, so what the user logged isn't lost to a dead zone.
- **Time out on purpose, and make retries safe.** Short timeouts with a clear "can't connect" state, and an ID on every write so a retry after the elevator can't create a duplicate:

```swift
let config = URLSessionConfiguration.default
config.timeoutIntervalForRequest = 15      // default: 60 seconds of silence
config.timeoutIntervalForResource = 120    // default: 7 days
config.waitsForConnectivity = true         // wait for a network instead of failing at once
let session = URLSession(configuration: config)

var request = URLRequest(url: url)
request.httpMethod = "POST"
request.httpBody = pending.body
// Same key on every retry of this write, so the server can ignore duplicates.
request.setValue(pending.id.uuidString, forHTTPHeaderField: "Idempotency-Key")
```

The key only works if it's created once, when the user taps Save, and reused on every retry. A new key per attempt defeats the purpose. The server also has to remember the keys it has seen and return the original result for a repeat.

- **Don't trust "connected."** Treat a response you can't decode as a network problem, not an empty result, and tell the user.

## How to test it in the real world

**Walk a route.** Pick one path that hits the bad places: the elevator, a parking garage, a basement, the walk from your front door to the street. Use the app the whole way, and do the important actions at the worst moments: save just as the elevator doors close, start a sync in the garage.

**Use the Network Link Conditioner.** On an iPhone with Developer Mode on, it's under Settings > Developer. Its presets include **100% Loss**, **Very Bad Network**, **High Latency DNS**, **Edge** and **3G**. "100% Loss" is the interesting one: the phone still shows a connection, but nothing gets through, which is scenario 2 on demand.

**Find a captive portal.** Join a café or hotel network and open the app before signing in.

**Run the matrix.** For each action that writes data, try it under each condition:

| Condition | What to check |
|---|---|
| Airplane Mode on mid-request | Clear error or queued, never a silent no-op |
| 100% Loss | Times out with a message, no endless spinner |
| Wi-Fi off while walking away | Retries and succeeds on cellular |
| Lose signal right after tapping Save | No duplicate when it retries |
| Lock the phone mid-upload | Upload finishes or resumes |
| Low Power Mode overnight | Opens with stale data handled gracefully |

The simulator is great for building. The real world is where you find out whether what you built actually holds up.
