import { test } from 'node:test';
import assert from 'node:assert/strict';
import { formatClock } from '../../entry/src/main/ets/common/TimeFormat';

test('24-hour format pads hours and minutes', () => {
  assert.equal(formatClock(9, 5), '09:05');
  assert.equal(formatClock(0, 0), '00:00');
  assert.equal(formatClock(23, 59), '23:59');
});

test('24-hour is the default', () => {
  assert.equal(formatClock(13, 30), formatClock(13, 30, true));
});

test('12-hour format drops the leading zero and wraps past noon', () => {
  assert.equal(formatClock(9, 5, false), '9:05');
  assert.equal(formatClock(13, 30, false), '1:30');
  assert.equal(formatClock(23, 59, false), '11:59');
});

test('12-hour format shows midnight and noon as 12', () => {
  assert.equal(formatClock(0, 15, false), '12:15');
  assert.equal(formatClock(12, 0, false), '12:00');
});
