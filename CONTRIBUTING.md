# Contributing

Thanks for helping improve D2 Prototype!

## Workflow

1. Fork/branch from `main`.
2. Make your change. Keep commits small and messages descriptive (`fix:`, `feat:`, `ci:`, `docs:`, `test:` prefixes appreciated).
3. Run the unit tests locally: `npm ci && npm test`.
4. Open a PR — the template asks for a summary and testing notes. CI must be green:
   - `unit-tests` (Node, fast) — required
   - `build` (debug HAP) — required
5. If your change affects on-device behavior, run the [manual checklist](docs/testing.md#manual-on-watch-checklist) on a real watch if you can, and say so in the PR.

## Ground rules

- **Testable logic goes in `entry/src/main/ets/common/*.ts`**, not in `.ets` pages — and gets a unit test in `tests/unit/`. See [docs/testing.md](docs/testing.md).
- **Round-screen UI constraints** are non-negotiable: black background, centered layout, content inside the circle. See [docs/architecture.md](docs/architecture.md#ui-constraints-round-watch-screen).
- **User-grant permissions** must be requested through `common/Permissions.ts` before the guarded API call, and declared in `module.json5`.
- **New pages** must be registered in `entry/src/main/resources/base/profile/main_pages.json`.
- **Don't touch the CI SDK fixups** (`.github/actions/setup-harmonyos/`) unless you know why each step exists — they are documented in [docs/build-and-release.md](docs/build-and-release.md#why-the-ci-setup-looks-strange).
- ArkTS strictness: no `any`, no structural-typing tricks, untyped catch params.

## Dependencies

- **App dependencies** go in `oh-package.json5` (ohpm). There are currently none. The day the first one lands, remove `oh-package-lock.json5` from `.gitignore` and commit the lockfile in the same PR.
- **`package.json` is dev tooling only** (unit-test runner). Don't add app code dependencies there.
- The hvigor version is pinned in `hvigor/hvigor-config.json5`; bumping it is a CI-risk change — test the full build workflow in your PR.

## Releases

Maintainers only: Actions → *Release D2 Prototype* → enter a semver version. Everything else (version bump commit, tag, release build, optional signing, GitHub Release) is automated — see [docs/build-and-release.md](docs/build-and-release.md).
