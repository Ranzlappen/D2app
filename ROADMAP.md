# Roadmap

Priorities for turning D2 Prototype from a demo into a genuinely useful wrist app. Contributions welcome — open an issue referencing the item before starting anything sizable.

## P1 — Make it useful (next up)

- [ ] **Multi-page navigation** via `@ohos.router`: small nav affordances on the watch face; every page registered in `main_pages.json`.
- [ ] **Steps / activity page** — pedometer via `sensor.SensorId.PEDOMETER`; requires `ohos.permission.ACTIVITY_MOTION` (user-grant, via `common/Permissions.ts`). Daily step count, large and glanceable.
- [ ] **Settings page** — persisted with `@ohos.data.preferences`: 12/24-hour clock (feeds `common/TimeFormat.ts`), heart-rate polling interval (battery vs. freshness).

## P2 — Wearable polish

- [ ] **Ambient/always-on behavior** — decide what happens when the screen dims: either integrate with the system watch-face rules or ensure clean suspend/resume of sensor subscriptions to protect battery.
- [ ] **Workout session mode** — start/stop a session that samples HR at a higher rate, shows elapsed time + live HR, and summarizes (min/avg/max) at the end.
- [ ] **Haptic feedback** (`@ohos.vibrator`) on tap interactions and workout milestones.
- [ ] **HR history sparkline** — keep the last N readings in memory and render a simple trend line under the bpm value.
- [ ] **Localization** — move remaining hardcoded UI strings into resources; add German.

## P3 — Bigger bets

- [ ] **Companion phone app / sync** — export sessions to a phone (or cloud) for history beyond the watch's memory.
- [ ] **Watch-face complication** — investigate exposing HR/steps as a complication or widget card, if the D2's HarmonyOS version exposes an API for third parties.
- [ ] **SpO₂ / additional sensors** — evaluate which additional Watch D2 sensors are exposed to third-party apps (`@ohos.sensor` capability probing) and surface the useful ones.
- [ ] **Real app identity + AppGallery distribution** — replace the placeholder bundle name `com.example.d2prototype` with a real vendor identity, then evaluate AppGallery submission so users don't need UDID sideloading.

## Infrastructure follow-ups

- [ ] Verify whether the Linux command-line-tools repack ships `codelinter`; if yes, promote the CI lint step from advisory to enforcing.
- [ ] Nightly scheduled CI run to catch SDK-mirror/registry rot early.
- [ ] Commit `oh-package-lock.json5` the day the first ohpm dependency lands (currently gitignored because there are zero deps).
