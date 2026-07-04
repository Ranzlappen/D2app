# Architecture

D2 Prototype is a HarmonyOS/OpenHarmony **Stage-model** app written in ArkTS with the declarative ArkUI framework, targeting API 12 and the `wearable` device type (Huawei Watch D2, round 1.5" AMOLED, 466×466).

## Runtime flow

```
module.json5 (mainElement: EntryAbility)
        │
        ▼
EntryAbility.ets ──── onWindowStageCreate ────► loadContent('pages/Index')
        │                                              │
        ▼                                              ▼
UIAbility lifecycle                          pages/Index.ets (@Entry)
                                                       │
                                     ┌─────────────────┼──────────────────┐
                                     ▼                 ▼                  ▼
                              @ohos.sensor      @ohos.batteryInfo   setInterval clock
                              (HEART_RATE)      (batterySOC)
```

- **`entry/src/main/ets/entryability/EntryAbility.ets`** — the app's single `UIAbility`. Its only job is lifecycle glue: it loads the first page when the window stage is created.
- **`entry/src/main/ets/pages/Index.ets`** — the watch face. Subscribes to the heart-rate sensor (after obtaining the runtime permission), polls battery state-of-charge, and ticks a clock every second. Pages are registered in `entry/src/main/resources/base/profile/main_pages.json`; navigation between pages uses `@ohos.router`.
- **`entry/src/main/ets/common/`** — logic that does *not* touch ArkUI:
  - `Permissions.ts` — wraps `abilityAccessCtrl.requestPermissionsFromUser`. Every user-grant permission must go through this before the guarded API is called; declaring it in `module.json5` alone is not enough (the API fails with error 201).
  - `TimeFormat.ts`, `Formatting.ts` — pure display formatting, unit-tested under Node (see [testing.md](testing.md)).

## Layered rule

**UI and OHOS-API glue live in `.ets`; everything computable lives in plain `.ts` under `common/`.** This is what makes the logic testable in CI, because instrumented tests cannot run headless (see [testing.md](testing.md)).

## Configuration files

| File | Purpose |
|---|---|
| `AppScope/app.json5` | Bundle name (`com.example.d2prototype`), `versionCode`/`versionName` (managed by the release workflow) |
| `entry/src/main/module.json5` | Module type, `deviceTypes` (`default`, `wearable`), abilities, **requested permissions** |
| `entry/src/main/resources/base/profile/main_pages.json` | Page registry — every page must be listed here |
| `build-profile.json5` | SDK versions (compile/compatible = 12), build modes (`debug`/`release`), signing configs (intentionally empty — see [build-and-release.md](build-and-release.md)) |
| `hvigor/hvigor-config.json5` | Pinned hvigor build-tool version (5.3.3) |
| `oh-package.json5` | ohpm app dependencies (currently none) |
| `package.json` | **npm dev tooling only** (unit-test runner) — not app dependencies |

## UI constraints (round watch screen)

Every page targets a round 1.5" display:

- Black background (`#000000`) — battery-friendly on AMOLED and blends with the bezel
- Root container: full-size `Column`, centered content, `borderRadius('50%')` so content is clipped to the circle
- Generous font sizes (the clock is 56fp), content kept away from the circle's edge with padding
- Dark theme colors throughout; no light mode

## Permissions model

| Permission | Kind | Requested where |
|---|---|---|
| `ohos.permission.READ_HEALTH_DATA` | user_grant | Declared in `module.json5`, requested at runtime by `Index.ets` via `common/Permissions.ts` before `sensor.on(HEART_RATE)` |

New sensor features must follow the same pattern: declare in `module.json5` *and* request via `Permissions.ts` before first use.
