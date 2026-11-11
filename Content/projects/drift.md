---
layout: ProjectPage
order: 4
platform: iOS, in progress
date: 2026-10-13
subtitle: A street-level map experience that reacts to the weather, the time of day and how you're moving.
stack: Swift, SwiftUI Canvas, Core Location, CoreMotion, Open-Meteo, OpenStreetMap
repo: https://github.com/arturoa925/Drift
tags: iOS, Swift, Design
---
# Drift

## TL;DR

- A map that's meant to be **experienced, not read**: a full-screen gradient that shifts with weather and time of day, over a street-level world drawn in a SwiftUI `Canvas`.
- My first app built **entirely by prompting AI**. I owned the concept, the design system, the build order and every review; the AI wrote the implementation.
- In progress. The theme engine, sensors, weather and street-level renderer work. Onboarding, settings and the floating controls are next.

## How I built it

In Launch Control and Axis, I wrote the code myself and used AI for specific jobs like tests and debugging. With Drift, I wanted to see how far I could get by **directing instead of typing**.

- I came up with the concept, the name and the feel of the app.
- I worked out the design system: a gradient for each condition, floating "pill" controls, the motion rules, and the screen flow.
- I wrote all of it into `claude.md`, a living design spec that gives the AI full project context at the start of every session.
- I set the build order, reviewed every change, tested on device, and changed direction when something didn't feel right. I dropped MapKit for a custom renderer, and replaced placeholder geometry with real OpenStreetMap data.

The lesson: prompting well is mostly product and engineering judgment. You have to be precise about what you want and catch where the output drifts from the vision.

## The theme engine

One function turns two inputs into the whole look of the screen:

```swift
static func theme(weather: WeatherCondition, timeOfDay: TimeOfDayCondition) -> MapTheme {
    weather.overridesTimeOfDay ? theme(for: weather) : theme(for: timeOfDay)
}
```

| Priority | Input | Source |
| --- | --- | --- |
| 1 | **Weather:** rain, snow, storm and fog override time of day | Open-Meteo (free, no API key) |
| 2 | **Time of day:** sunrise, midday, sunset, night | Calculated on the device with the sunrise equation |
| — | **Movement:** still, walking, biking | CoreMotion. Drives animation only, never color |

There are eight hand-tuned gradients, and one rule holds for all of them: **it never goes fully dark.** Even at night or in a storm, the bottom of the gradient fades to a pale tone.

## The street-level world

- **You stay still and the world moves.** Roads and buildings are positioned relative to your location each frame, and the scene turns with your compass heading.
- **A tiny planet.** The ground curves like a small sphere, so streets fall away over a horizon.
- **Smooth motion between GPS fixes.** Position is estimated along your velocity and eased toward each new fix.
- **Buildings that sway** with your speed and turning, through springs that overshoot slightly and settle.
- **Road snapping** within 25 meters, so GPS drift doesn't put you inside a building.

Real roads and building footprints come from OpenStreetMap through the Overpass API. Each fetch covers twice the visible area, and the app only fetches again once you leave it, to stay within a shared free API's limits.

## What's next

Onboarding with contextual permission requests, settings, the floating weather and speed pills, place search, a fading movement trail, and later an Apple Watch face over the same live gradient.
