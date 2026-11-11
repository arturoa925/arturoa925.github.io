---
image: https://arturoa925.github.io/images/og.png
layout: ProjectPage
order: 3
platform: Full-stack
date: 2026-09-01
subtitle: A full-stack training app with an offline-first React Native client and a Node.js, Express and PostgreSQL API.
stack: React Native, Expo, JavaScript, Node.js, Express, Sequelize, PostgreSQL, JWT, OAuth, OpenAI API
repo: https://github.com/arturoa925/FITNESS-client
tags: Full-stack
---
# FITNESS

## TL;DR

- Follow structured training programs day by day, generate a one-off AI workout, and log workouts and food on a calendar.
- The client is **offline-first**: every write lands locally first and syncs when the connection comes back.
- The API handles email, Google and GitHub sign-in, program enrollment, a per-user calendar, and AI-generated workouts. Code: [client](https://github.com/arturoa925/FITNESS-client) and [server](https://github.com/arturoa925/FITNESS-server).

## What it does

- **Programs:** browse a catalog (half marathon prep, hypertrophy split, kettlebells, yoga, calisthenics), enroll, and walk through it day by day.
- **Daily Grind:** generate a workout that isn't tied to a program.
- **Calendar:** see completed workouts by month and log or remove foods for any day.
- **Sign-in:** email and password, Google or GitHub, plus Face ID or Touch ID for quick login.

## Architecture

```text
React Native (Expo) client                 Node.js / Express API
┌────────────────────────────┐            ┌──────────────────────────────┐
│ Screens                    │  REST +    │ /users  /auth  /ai           │
│ UserContext (state + sync) │ ─ JWT ───► │ JWT middleware, rate limits  │
│ AsyncStorage + SecureStore │            │ Sequelize models             │
└────────────────────────────┘            └──────────────┬───────────────┘
                                                         ▼
                                     PostgreSQL · Cloudinary · OpenAI
```

## Code choices and why

### Offline-first writes

A workout app gets used in gyms, garages and basements, so it can't depend on signal. `UserContext` handles every write the same way:

1. Update local state and `AsyncStorage` **first**, so the UI responds instantly.
2. If the request fails or the device is offline, push the action onto a persisted `pendingOps` queue.
3. A `NetInfo` listener replays the queue when connectivity returns. Anything that still fails stays queued for the next try.

The user never loses a completed workout because of a dead zone.

### A calendar row per day, with JSONB

The server stores one `Calendar` row per user per day, with `workouts` and `foods` as JSONB arrays. Logging is always "what happened on this day," so the data is shaped the way it's read. Workouts are deduplicated by an external ID, so a replayed offline write can't create a duplicate.

### Security that's proportionate

- Passwords hashed with **bcrypt** in model hooks.
- **JWT** bearer tokens with a one-hour expiry, checked by middleware.
- **Rate-limited login:** 10 attempts per IP every 15 minutes.
- **OAuth** for Google and GitHub: the server exchanges the code, upserts the user, issues its own JWT, and redirects back into the app through its deep-link scheme.
- On the device, the token and a cached profile live in `expo-secure-store`, so the app can restore a session offline.

### AI that fails gracefully

Daily workouts come from the OpenAI API with a strict contract: return a single JSON object, exactly four exercises (upper push, upper pull, lower body, and a core or conditioning finisher), with realistic volumes. The server validates the response and wraps the call in a 15-second timeout. If the AI isn't configured, times out or returns bad JSON, the API responds with a clear `503` and an error code instead of a broken workout.

### Images handled on the server

Profile photos are uploaded in memory with a 5 MB limit, resized to 512×512 WebP with `sharp`, and stored on Cloudinary. The phone never has to do the image work.

## What's next

Consolidating the API URL handling into a single module, using one consistent key for the stored auth token, and adding a consistency and streak view.
