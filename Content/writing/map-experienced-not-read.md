---
layout: PostPage
date: 2026-10-13 09:00
tags: Swift, Design
description: What would a map feel like if it was designed to be experienced instead of read? A design note on Drift.
---
# A map designed to be experienced, not read

What would a map feel like if it was designed to be experienced instead of read?

Most map apps are tools: get from A to B as fast as possible. **Drift** asks the opposite question. It treats the world as something alive, with motion but no urgency and no pressure to get anywhere.

## The theme engine

The whole screen is a full-screen gradient. One function decides how it looks:

```swift
ThemeEngine.theme(weather:timeOfDay:)
```

Two inputs, in priority order:

1. **Weather:** rain, snow, storm and fog override everything else. Data comes from Open-Meteo, which is free and needs no API key.
2. **Time of day:** sunrise, midday, sunset or night, calculated on the device with the sunrise equation, so it works offline.

A third input, **movement** (still, walking, biking) from CoreMotion, drives animation only and never color. That separation keeps the palette calm while the scene still feels alive.

There are eight hand-tuned gradients, and one rule holds for all of them: **the gradient never goes fully dark.** Even at night or in a storm, the bottom fades to a pale tone. The mood should be atmospheric, not gloomy.

## A street-level world instead of a map

Drift doesn't use MapKit for rendering. It draws the world itself in a SwiftUI `Canvas`, from a camera a few meters behind and above you, looking down the street you're facing.

- **You stay still and the world moves.** Roads and buildings are positioned relative to your location every frame, and the scene turns with your compass heading.
- **A tiny planet.** The ground curves like a small sphere, so streets fall away over a horizon and buildings rise up from behind it.
- **Smooth motion between GPS fixes.** GPS updates about once a second, so the app estimates your position between fixes and eases toward each new one.
- **Buildings that sway.** They lean with your speed and turning, through springs that overshoot slightly and settle when you stop.
- **Road snapping.** Your position snaps to the nearest real street within 25 meters, so GPS drift doesn't put you inside a building.

Real roads and building footprints come from OpenStreetMap through the Overpass API. Each fetch covers twice the area on screen, and the app only fetches again once you leave it, to stay within a shared free API's limits.

## The design principle

Every decision answers the same question: does this make the world feel alive, or does it make the screen feel busy? Color carries the mood, motion carries the life, and everything else gets out of the way.

Drift is still in progress. Onboarding, settings and the floating controls are next.
