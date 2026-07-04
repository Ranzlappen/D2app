import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  DEFAULT_SETTINGS,
  HR_INTERVAL_OPTIONS,
  nextHrInterval,
  hrIntervalToNanos
} from '../../entry/src/main/ets/common/AppSettings';

test('default HR interval is one of the offered options', () => {
  assert.ok(HR_INTERVAL_OPTIONS.includes(DEFAULT_SETTINGS.hrIntervalSeconds));
});

test('nextHrInterval cycles through every option and wraps around', () => {
  let current = HR_INTERVAL_OPTIONS[0];
  const seen: number[] = [current];
  for (let i = 1; i < HR_INTERVAL_OPTIONS.length; i++) {
    current = nextHrInterval(current);
    seen.push(current);
  }
  assert.deepEqual(seen, HR_INTERVAL_OPTIONS);
  assert.equal(nextHrInterval(current), HR_INTERVAL_OPTIONS[0]);
});

test('nextHrInterval resets unknown values to the first option', () => {
  assert.equal(nextHrInterval(42), HR_INTERVAL_OPTIONS[0]);
  assert.equal(nextHrInterval(-1), HR_INTERVAL_OPTIONS[0]);
});

test('hrIntervalToNanos converts seconds to sensor nanoseconds', () => {
  assert.equal(hrIntervalToNanos(3), 3000000000);
  assert.equal(hrIntervalToNanos(1), 1000000000);
});
