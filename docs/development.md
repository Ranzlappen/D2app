# Development

## Recommended: DevEco Studio

[DevEco Studio](https://developer.huawei.com/consumer/en/deveco-studio/) is the official IDE and the only fully supported way to build, lint, and debug HarmonyOS apps locally.

1. Install DevEco Studio (5.x) — it bundles the HarmonyOS SDK, toolchains, emulators, and the Code Linter.
2. **File → Open** the repository root. DevEco recognizes the project from `build-profile.json5`.
3. Let the IDE sync; it generates `local.properties` pointing at its bundled SDK.
4. Build: **Build → Make Hap(s)**, or from the IDE terminal:
   ```bash
   ./hvigorw assembleHap -p buildMode=debug --no-daemon
   ```
5. Run on a device/emulator via the run configuration. Note the **heart-rate sensor only works on real hardware**.

## Command-line build (without the IDE)

You need the OpenHarmony SDK (API 12) and Node 20+:

```bash
export OHOS_BASE_SDK_HOME=/path/to/ohos-sdk    # contains <api-version>/ets, /js, /toolchains…
./hvigorw assembleHap -p buildMode=debug --no-daemon
```

`hvigorw` bootstraps hvigor 5.3.3 into `hvigor/node_modules` on first run (pinned in `hvigor/hvigor-config.json5`). The built HAP lands under `entry/build/default/outputs/`.

> On a plain Linux machine the OpenHarmony SDK needs the same fixups CI applies (permissive module-check schemas, device-define syscap files, executable bits). See [build-and-release.md](build-and-release.md#why-the-ci-setup-looks-strange) — or just use the GitHub Actions build.

## No local hardware? Use CI

Every push to `main` and every pull request builds a debug HAP in GitHub Actions and uploads it as the `d2-prototype-hap` artifact. This is the primary build path for this repo; a local SDK is optional.

## Unit tests

```bash
npm ci        # once — installs the dev tooling (tsx)
npm test      # runs tests/unit/*.test.ts under Node
```

See [testing.md](testing.md) for the testing strategy and its constraints.

## Conventions

- **Keep testable logic out of `.ets` files.** Formatting, calculations, and state logic go in `entry/src/main/ets/common/*.ts`; `.ets` files hold UI and OHOS-API glue only.
- ArkTS is stricter than TypeScript: no `any`, no destructuring of `@State` fields, no structural-typing tricks. Catch parameters are untyped — use `(e)` and stringify.
- Every page must respect the round-screen constraints listed in [architecture.md](architecture.md#ui-constraints-round-watch-screen).
- User-grant permissions must be requested via `common/Permissions.ts` before the guarded API call.
- New pages must be registered in `entry/src/main/resources/base/profile/main_pages.json`.

## Repository layout

```
D2app/
├── AppScope/                      # App-level config (bundle name, version) + resources
├── entry/                         # The single HAP module
│   └── src/main/
│       ├── ets/
│       │   ├── entryability/      # UIAbility lifecycle
│       │   ├── pages/             # ArkUI pages (UI only)
│       │   └── common/            # Pure logic + permission helper (unit-tested)
│       ├── module.json5           # Permissions, device types, abilities
│       └── resources/             # Strings, colors, media, page registry
├── tests/unit/                    # Node-run unit tests for common/
├── docs/                          # You are here
├── .github/
│   ├── actions/setup-harmonyos/   # Shared CI environment setup (load-bearing!)
│   └── workflows/                 # build-hap.yml, release.yml
├── build-profile.json5            # SDK + build modes + signing
├── hvigor/, hvigorw, hvigorfile.ts# Build tool (pinned 5.3.3)
├── oh-package.json5               # ohpm deps (none)
└── package.json                   # npm dev tooling (test runner) only
```
