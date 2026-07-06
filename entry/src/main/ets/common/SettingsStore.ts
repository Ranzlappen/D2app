import preferences from '@ohos.data.preferences';
import type common from '@ohos.app.ability.common';
import { DEFAULT_SETTINGS } from './AppSettings';
import type { AppSettings } from './AppSettings';

const STORE_NAME = 'd2_settings';

export async function loadSettings(context: common.UIAbilityContext): Promise<AppSettings> {
  try {
    const store = await preferences.getPreferences(context, STORE_NAME);
    const use24 = await store.get('use24HourClock', DEFAULT_SETTINGS.use24HourClock);
    const hr = await store.get('hrIntervalSeconds', DEFAULT_SETTINGS.hrIntervalSeconds);
    const settings: AppSettings = {
      use24HourClock: use24 as boolean,
      hrIntervalSeconds: hr as number
    };
    return settings;
  } catch (e) {
    console.error('D2Prototype', 'Failed to load settings: ' + JSON.stringify(e));
    const fallback: AppSettings = {
      use24HourClock: DEFAULT_SETTINGS.use24HourClock,
      hrIntervalSeconds: DEFAULT_SETTINGS.hrIntervalSeconds
    };
    return fallback;
  }
}

export async function saveSettings(context: common.UIAbilityContext, settings: AppSettings): Promise<void> {
  try {
    const store = await preferences.getPreferences(context, STORE_NAME);
    await store.put('use24HourClock', settings.use24HourClock);
    await store.put('hrIntervalSeconds', settings.hrIntervalSeconds);
    await store.flush();
  } catch (e) {
    console.error('D2Prototype', 'Failed to save settings: ' + JSON.stringify(e));
  }
}
