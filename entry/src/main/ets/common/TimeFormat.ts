/**
 * Pure clock-formatting logic, kept out of .ets files so it can run under
 * Node for unit tests (see tests/unit/TimeFormat.test.ts).
 */
export function formatClock(hours: number, minutes: number, use24Hour: boolean = true): string {
  const mm = minutes.toString().padStart(2, '0');
  if (use24Hour) {
    return `${hours.toString().padStart(2, '0')}:${mm}`;
  }
  const h12 = hours % 12 === 0 ? 12 : hours % 12;
  return `${h12}:${mm}`;
}
