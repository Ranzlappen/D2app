# CLAUDE.md

Guidance for AI agents (and new contributors) working in this repository.

## What this is

D2 Prototype — a HarmonyOS/OpenHarmony **wearable** app for the Huawei Watch D2. ArkTS + ArkUI, Stage model, API 12, built with hvigor. There are **no ohpm dependencies**; the only pinned tooling is hvigor 5.3.3 in `hvigor/hvigor-config.json5`.

## Build

```bash
./hvigorw assembleHap -p buildMode=debug --no-daemon
```

Requires the OpenHarmony SDK (`OHOS_BASE_SDK_HOME` or `sdk.dir` in `local.properties`). Locally, use DevEco Studio (see `docs/development.md`). In this repo's Linux CI the SDK cannot build a HAP out of the box — the workflows fabricate permissive JSON schemas under `toolchains/modulecheck/`, `device-define` syscap files, and chmod SDK binaries. **Those setup steps in `.github/actions/setup-harmonyos/action.yml` are load-bearing; do not "clean them up".**

## Testing

- **Hypium/ohosTest does NOT run headless.** There is no `hvigorw test` task at hvigor 5.3.3; instrumented tests need DevEco Studio + a device. Do not add ohosTest scaffolding expecting CI to run it.
- Unit tests: pure logic lives in plain `.ts` modules under `entry/src/main/ets/common/` and is tested with Node:
  ```bash
  npm test   # npx tsx --test tests/unit/*.test.ts
  ```
- **Rule: keep testable logic out of `.ets` files.** Formatting, calculations, and state logic go in `common/*.ts` (imported by `.ets` pages); `.ets` files hold only UI and OHOS-API glue.

## Repo conventions

- The root `package.json` is **dev tooling only** (test runner). App dependencies would go in `oh-package.json5` (ohpm), not npm. `oh-package-lock.json5` is gitignored while there are zero ohpm deps; commit it the day the first dep lands.
- ArkTS is stricter than TypeScript: no `any`, no destructuring in `@Component` structs' state, no structural typing tricks. Untyped catch params: use `(e)` and stringify.
- Every page must fit a **round 1.5" screen**: black background, centered column layout, generous font sizes, content inside the circle (`borderRadius('50%')` on the root container).
- User-grant permissions (`READ_HEALTH_DATA`, `ACTIVITY_MOTION`) must be requested at runtime via `entry/src/main/ets/common/Permissions.ts` before using the guarded API — declaring them in `module.json5` is not enough.

## Releases

`Release D2 Prototype` workflow (manual dispatch): bumps `versionName` + `versionCode` in `AppScope/app.json5`, commits to `main`, tags, builds a **release**-mode HAP, optionally signs it when the `HOS_*` secrets are configured (see `docs/build-and-release.md`), and attaches assets to a GitHub Release.

## Key paths

- `entry/src/main/ets/pages/` — UI pages (registered in `entry/src/main/resources/base/profile/main_pages.json`)
- `entry/src/main/ets/common/` — pure logic + permission helper
- `entry/src/main/module.json5` — permissions, device types
- `AppScope/app.json5` — bundle name, version
- `.github/actions/setup-harmonyos/` — shared CI environment setup
- `docs/` — architecture, development, build/release, installation, testing
