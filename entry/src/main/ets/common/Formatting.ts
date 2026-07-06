/**
 * Pure display-formatting helpers for sensor and battery values, kept out of
 * .ets files so they can run under Node for unit tests.
 */

/** Battery display: "85%" for a valid state-of-charge, "--" otherwise. */
export function formatBattery(soc: number): string {
  return soc >= 0 && soc <= 100 ? `${soc}%` : '--';
}

/** The HR sensor reports 0 (or negative) while it has no reading yet. */
export function isValidHeartRate(bpm: number): boolean {
  return bpm > 0;
}

/** Sensor delivers fractional bpm; the UI shows whole beats. */
export function roundHeartRate(bpm: number): number {
  return Math.round(bpm);
}
