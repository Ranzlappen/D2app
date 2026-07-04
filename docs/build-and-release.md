# Build & Release

## CI pipeline overview

Two workflows, sharing one composite action:

| Workflow | Trigger | What it does |
|---|---|---|
| `Build D2 Prototype HAP` (`build-hap.yml`) | push to `main`, every PR, manual | `unit-tests` job (Node, seconds) + `build` job (debug HAP → `d2-prototype-hap` artifact) |
| `Release D2 Prototype` (`release.yml`) | manual dispatch with a version input | bumps version, commits, builds a **release** HAP, optionally signs it, tags, creates a GitHub Release |
| `.github/actions/setup-harmonyos/action.yml` | used by both | JDK 17, Node 20, HarmonyOS command-line tools, OpenHarmony SDK 5.0.0 + fixups, caches |

### Why the CI setup looks strange

GitHub's Linux runners are not a supported HarmonyOS build environment, so the composite action does several non-obvious, **load-bearing** things. Do not "clean these up":

- **Command-line tools come from a community mirror** (`fcitx-contrib/ohpm-cli-tools`) because Huawei's official downloads require an authenticated session. The archive is split into parts and reassembled. Cached by version.
- **Permissive JSON schemas are fabricated** under the SDK's `toolchains/modulecheck/` and `toolchains/configcheck/` — hvigor's PreBuild validates `module.json5`/`app.json5` against schemas the OpenHarmony SDK doesn't ship.
- **`device-define` syscap files are fabricated** under `ets/api/device-define/` — hvigor checks requested system capabilities against per-device-type lists that are also missing from the SDK.
- **Executable bits are set** on SDK toolchain binaries (`restool`, `es2abc`, …) — the SDK zip loses them.
- **`hvigorw` patches the SDK manager in CI** (`CI=true`): it disables the license check and component download because Huawei's CDN is unreachable from Actions. The patch is idempotent, so caching `hvigor/node_modules` is safe.

### Caches

- `~/commandline-tools` — keyed on the tools version
- OpenHarmony SDK — cached internally by `openharmony-rs/setup-ohos-sdk`
- `hvigor/node_modules` — keyed on `hvigor/hvigor-config.json5`
- npm cache for the unit-test job

## Cutting a release

1. Go to **Actions → Release D2 Prototype → Run workflow**.
2. Enter a semver version (`1.1.0`, or `1.1.0-beta` + tick *pre-release*).
3. The workflow:
   - validates the version and computes `versionCode = major×1000000 + minor×1000 + patch` (pre-releases share the code of their final version),
   - patches both fields in `AppScope/app.json5` and **commits the bump** to the branch the workflow ran on, so the tag points at the released version,
   - builds a **release**-mode HAP,
   - signs it if signing secrets are configured (below),
   - tags `v<version>` and publishes a GitHub Release with `d2-prototype-v<version>-unsigned.hap` (and `-signed.hap` when signing ran).

## Signing

HarmonyOS apps must be signed with a certificate + a provisioning profile that lists the target device's UDID before a watch will run them. This repo supports two modes:

### Without secrets (default)

Releases ship the **unsigned** HAP. Sign it yourself in DevEco Studio (File → Project Structure → Signing Configs, with your AppGallery cert and profile) or with `hap-sign-tool`, then install. See [installation.md](installation.md).

### With secrets (CI signs for you)

Add these repository secrets (**Settings → Secrets and variables → Actions**) and the release workflow signs automatically:

| Secret | Content |
|---|---|
| `HOS_KEYSTORE_B64` | Your `.p12` keystore, base64-encoded (`base64 -w0 my.p12`) |
| `HOS_CERT_B64` | Your debug/release certificate (`.cer`), base64-encoded |
| `HOS_PROFILE_B64` | Your provisioning profile (`.p7b`), base64-encoded |
| `HOS_KEYSTORE_PASSWORD` | Keystore password |
| `HOS_KEY_ALIAS` | Key alias inside the keystore |
| `HOS_KEY_PASSWORD` | Key password |

To obtain the files:

1. Create a (free) developer account at [developer.huawei.com](https://developer.huawei.com) and open **AppGallery Connect**.
2. **Users and permissions → Devices**: register your watch's UDID (on the watch: *Settings → About*, or `hdc shell bm get --udid`).
3. **Certificates, App IDs & Profiles**: create a **debug certificate** (upload a CSR generated from your keystore — DevEco Studio can generate keystore + CSR under *Build → Generate Key and CSR*) and a **debug provisioning profile** that includes your device and the bundle name `com.example.d2prototype`.
4. Download the `.cer` and `.p7b`, base64-encode all three files, and add the secrets.

The signing step is guarded — if `HOS_KEYSTORE_B64` is absent, the release simply ships unsigned, exactly as before.

> **Note:** the CI signing path uses `hap-sign-tool` from the SDK after the build, rather than hvigor's `signingConfigs` (which expect DevEco-encrypted password material that doesn't translate to CI secrets). This is also why `signingConfigs` in `build-profile.json5` is intentionally empty.

## Versioning

- `versionName`: semver, set by the release workflow.
- `versionCode`: derived (`1.2.3` → `1002003`); must always increase for a watch to accept an upgrade. Don't edit either by hand — cut a release instead.
