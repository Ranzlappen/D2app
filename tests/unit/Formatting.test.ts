import { test } from 'node:test';
import assert from 'node:assert/strict';
import { formatBattery, isValidHeartRate, roundHeartRate } from '../../entry/src/main/ets/common/Formatting';

test('formatBattery renders valid state-of-charge as a percentage', () => {
  assert.equal(formatBattery(0), '0%');
  assert.equal(formatBattery(85), '85%');
  assert.equal(formatBattery(100), '100%');
});

test('formatBattery renders out-of-range values as --', () => {
  assert.equal(formatBattery(-1), '--');
  assert.equal(formatBattery(101), '--');
});

test('isValidHeartRate rejects the sensor\'s no-reading values', () => {
  assert.equal(isValidHeartRate(0), false);
  assert.equal(isValidHeartRate(-1), false);
  assert.equal(isValidHeartRate(1), true);
  assert.equal(isValidHeartRate(72.4), true);
});

test('roundHeartRate rounds fractional bpm to whole beats', () => {
  assert.equal(roundHeartRate(71.5), 72);
  assert.equal(roundHeartRate(71.4), 71);
  assert.equal(roundHeartRate(72), 72);
});
