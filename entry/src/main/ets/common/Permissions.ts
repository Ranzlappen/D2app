import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type { Permissions } from '@ohos.abilityAccessCtrl';
import type common from '@ohos.app.ability.common';

/**
 * Requests user-grant permissions at runtime. Declaring a user_grant
 * permission in module.json5 is not enough on HarmonyOS — the guarded API
 * fails with error 201 until the user has approved the dialog shown here.
 * Returns true only if every requested permission was granted.
 */
export async function requestPermissions(
  context: common.UIAbilityContext,
  permissions: Array<Permissions>
): Promise<boolean> {
  try {
    const atManager = abilityAccessCtrl.createAtManager();
    const result = await atManager.requestPermissionsFromUser(context, permissions);
    return result.authResults.every((status: number) => status === 0);
  } catch (e) {
    console.error('D2Prototype', 'Permission request failed: ' + JSON.stringify(e));
    return false;
  }
}
