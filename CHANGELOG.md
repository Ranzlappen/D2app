# Changelog

All notable changes to this project are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning: semver (`versionName` in `AppScope/app.json5`).

## [Unreleased]

### Added
- Steps page (pedometer) and Settings page (12/24-hour clock, heart-rate polling interval), navigable from the watch face
- Runtime permission request for heart-rate access (fixes HR stuck on "Unavailable" on real hardware)
- Unit tests for display logic (`npm test`), run on every PR
- PR-gated CI builds, shared composite setup action, hvigor caching
- Release workflow: release-mode builds, automatic `versionCode`/`versionName` bump + commit, optional CI signing via `HOS_*` secrets
- Full documentation set under `docs/`, plus LICENSE, CONTRIBUTING, ROADMAP, issue/PR templates

### Removed
- Unused `ACCELEROMETER` permission
- Dangling `signingConfig` reference in `build-profile.json5`

## [1.0.0] — 2025

### Added
- Initial prototype: live digital clock, real-time heart rate, battery level, tap-to-toast — dark theme for the round Watch D2 screen
- GitHub Actions debug-HAP build with Linux SDK workarounds
- Manual release workflow producing tagged GitHub Releases
