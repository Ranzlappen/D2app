# Testing

## The constraint that shapes everything

**Instrumented HarmonyOS tests (Hypium/ohosTest) cannot run headless.** At hvigor 5.3.3 there is no `hvigorw test` task; arkxtest local/instrumented tests are executed by DevEco Studio against a connected device or emulator. GitHub's Linux runners have neither. Do not add `entry/src/ohosTest` scaffolding expecting CI to run it — it won't.

The strategy that follows:

| Layer | What | Where it runs |
|---|---|---|
| Unit tests | Pure logic in `entry/src/main/ets/common/*.ts` | Node in CI (`unit-tests` job), gates every PR |
| Lint | `codelinter` (advisory in CI), DevEco Studio Code Linter (authoritative) | CI best-effort / IDE |
| Build verification | Debug HAP build on every PR and push to `main` | CI |
| On-device behavior | Manual checklist (below) | A real Watch D2 |

## Unit tests

```bash
npm ci     # once
npm test   # tsx --test tests/unit/*.test.ts
```

- Tests live in `tests/unit/` and import directly from `entry/src/main/ets/common/`.
- They use `node:test` + `node:assert` — no test-framework dependency beyond `tsx` to strip types.
- **Rule: keep testable logic out of `.ets` files.** If you're writing a calculation, formatter, or state machine inside a page, extract it to `common/*.ts` and test it. The `.ets` file should only wire it to ArkUI and OHOS APIs.
- `common/Permissions.ts` imports OHOS modules and is intentionally *not* unit-tested — it's glue.

## Lint

CI runs `codelinter` best-effort (`continue-on-error`) using `code-linter.json5`; whether the community Linux command-line-tools repack ships the binary is unverified, so the step skips gracefully. The authoritative linter is DevEco Studio's built-in **Code Linter**, which uses the same config file — run it before submitting UI changes.

## Manual on-watch checklist

Run after any change that affects runtime behavior (CI cannot cover these):

1. **Install & launch** — app installs over the previous version and opens to the watch face.
2. **Permission flow (fresh install)** — health-data permission dialog appears on first launch; **Allow** → HR shows "Measuring…" then a bpm value within ~15 s; **Deny** → HR shows "Permission denied" and the app stays usable.
3. **Clock** — matches the watch's system time; minute rollover updates within a second.
4. **Battery** — percentage matches the system value; shows `--` only on read failure.
5. **Tap area** — "Tap me" shows the toast.
6. **Round-screen fit** — no content clipped by the circular bezel on any page.
7. **Lifecycle** — leave the app (crown press) and return: clock resumes, HR resumes without a new permission prompt, no duplicate-timer fast-ticking.
8. **Battery drain sanity** — after ~1 h on the wrist, no abnormal drain attributable to the app (HR polls every ~3 s).

Record results in the PR description under "Testing".
