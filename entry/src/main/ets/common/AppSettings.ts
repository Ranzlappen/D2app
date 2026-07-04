/**
 * Pure settings model — defaults and option cycling live here so they can be
 * unit-tested under Node; persistence glue is in SettingsStore.ts.
 */
export interface AppSettings {
  use24HourClock: boolean;
  hrIntervalSeconds: number;
}

export const DEFAULT_SETTINGS: AppSettings = {
  use24HourClock: true,
  hrIntervalSeconds: 3
};

/** Trade-off between reading freshness and battery drain. */
export const HR_INTERVAL_OPTIONS: number[] = [1, 3, 5, 10];

/** Cycles to the next HR polling interval; unknown values reset to the first option. */
export function nextHrInterval(current: number): number {
  const idx = HR_INTERVAL_OPTIONS.indexOf(current);
  return HR_INTERVAL_OPTIONS[(idx + 1) % HR_INTERVAL_OPTIONS.length];
}

/** @ohos.sensor intervals are expressed in nanoseconds. */
export function hrIntervalToNanos(seconds: number): number {
  return seconds * 1_000_000_000;
}
