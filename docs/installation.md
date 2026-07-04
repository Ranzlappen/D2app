# Installing on your Huawei Watch D2

## Getting a HAP

- **Releases** (recommended): download `d2-prototype-v<version>-….hap` from the [Releases page](../../../releases). If a `-signed` asset exists, use it (it only runs on devices registered in the maintainer's provisioning profile). Otherwise take `-unsigned` and sign it yourself (below).
- **CI artifacts**: any push to `main` or PR produces a debug HAP — Actions → latest *Build D2 Prototype HAP* run → artifact `d2-prototype-hap` (unzip it to get the `.hap`).

## One-time setup: UDID signing

An unsigned `.hap` will not install. It must be signed with a certificate + provisioning profile that includes **your watch's UDID**:

1. Create a Huawei developer account at [developer.huawei.com](https://developer.huawei.com).
2. Get your watch's UDID: on the watch, **Settings → About** (scroll to Device UDID), or via HDC: `hdc shell bm get --udid`.
3. In **AppGallery Connect → Users and permissions → Devices**, register the UDID as a test device.
4. Create a **debug signing certificate** and a **debug provisioning profile** (bundle name `com.example.d2prototype`, your device included).
5. Sign the HAP:
   - **DevEco Studio**: configure the cert/profile under *File → Project Structure → Signing Configs* and rebuild, or
   - **CI**: add the signing secrets to the repo so releases come out signed automatically — see [build-and-release.md](build-and-release.md#signing).

## Option A: install via phone (no computer needed)

1. Install **HUAWEI DevEco Assistant** on your phone from AppGallery.
2. Pair it with your Watch D2 via Bluetooth.
3. Transfer the signed `.hap` to your phone (email, cloud drive, …).
4. In DevEco Assistant, tap **Install App** and select the `.hap`.
5. The app appears in the watch's app list as "D2 Prototype".

## Option B: install via HDC (computer required)

1. Enable developer mode on the watch: **Settings → About**, tap **HarmonyOS Version** 7 times.
2. **Settings → Developer Options → USB Debugging** on.
3. Connect the watch via its charging cradle (USB) and verify: `hdc list targets`.
4. Install:
   ```bash
   hdc install path/to/d2-prototype-v1.0.0-signed.hap
   ```

## First launch

On first open the app asks for **health data access** (heart rate). Deny it and the HR line shows "Permission denied" — you can re-grant from the watch's Settings → Apps → D2 Prototype → Permissions.

## Troubleshooting

- **Install fails / "signature verification failed"**: the HAP isn't signed for *your* device — re-check the UDID in the provisioning profile and re-sign.
- **App won't upgrade**: the installed `versionCode` is ≥ the new one. Releases always increase it; mixing debug artifacts and releases can trip this — uninstall first.
- **HR shows "Unavailable"**: the sensor needs real hardware (not the emulator) and the health-data permission.
- **HR shows "Permission denied"**: grant the permission in watch Settings → Apps.
- **Watch not detected via HDC**: different USB cable, restart the watch, re-toggle USB debugging.
