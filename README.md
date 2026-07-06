# D2 Prototype

A custom HarmonyOS wearable app for the **Huawei Watch D2**: live digital clock, real-time heart-rate monitoring, battery display, and a tappable interaction area — dark theme, optimized for the round watch screen.

Built with ArkTS/ArkUI (Stage model, API 12) and hvigor. GitHub Actions builds an installable `.hap` on every push and PR — no local SDK required.

## Quickstart

**Just want the app on your watch?**

1. Grab a `.hap`: from the [Releases page](../../releases), or the `d2-prototype-hap` artifact of the latest [Actions build](../../actions).
2. Sign it for your watch's UDID and install via phone (DevEco Assistant) or `hdc` — full walkthrough in **[docs/installation.md](docs/installation.md)**.

**Want to change the app?**

1. Edit `entry/src/main/ets/pages/Index.ets` (UI) or `entry/src/main/ets/common/` (logic) — see **[docs/development.md](docs/development.md)**.
2. Run the unit tests: `npm ci && npm test`.
3. Push / open a PR — CI builds the HAP and runs the tests automatically.

## Documentation

| Doc | What's in it |
|---|---|
| [docs/installation.md](docs/installation.md) | UDID signing, installing via phone or HDC, troubleshooting |
| [docs/development.md](docs/development.md) | DevEco Studio setup, local builds, project conventions |
| [docs/architecture.md](docs/architecture.md) | How the app is structured, config-file map, round-screen UI rules |
| [docs/build-and-release.md](docs/build-and-release.md) | CI pipeline (and why it looks the way it does), cutting releases, signing secrets |
| [docs/testing.md](docs/testing.md) | Testing strategy, unit tests, manual on-watch checklist |
| [ROADMAP.md](ROADMAP.md) | Where this app is headed |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to contribute |

## Project structure

```
AppScope/                  # Bundle name, version, app resources
entry/src/main/ets/
├── entryability/          # App lifecycle (UIAbility)
├── pages/                 # ArkUI pages — UI only
└── common/                # Pure logic + permission helper — unit-tested
tests/unit/                # Node-run unit tests
docs/                      # Documentation
.github/                   # CI workflows + shared setup action + templates
```

## License

[Apache-2.0](LICENSE)
