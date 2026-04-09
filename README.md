# D2 Prototype

A custom HarmonyOS wearable app for the **Huawei Watch D2**. Features a live digital clock, real-time heart rate monitoring, battery display, and a tappable interaction area — all in a dark theme optimized for round watch screens.

---

## How It Works

The app is built with ArkTS (HarmonyOS Stage Model). GitHub Actions automatically builds a `.hap` file you can install on your watch.

---

## Building the App

### Automatic Build (GitHub Actions)

1. **Push any change to the `main` branch** — the build runs automatically.
2. Or go to **Actions → Build D2 Prototype HAP → Run workflow** to trigger it manually.

### Downloading the .hap File

1. Go to the **Actions** tab in this GitHub repository.
2. Click the latest successful **Build D2 Prototype HAP** run.
3. Scroll down to **Artifacts** and download `d2-prototype-hap`.
4. Unzip it — you'll find a `.hap` file inside.

---

## Installing on Your Huawei Watch D2

### One-Time Setup: UDID Signing

Before the app can run on your watch, the `.hap` must be signed with your device's UDID:

1. **Create a Huawei Developer account** at [developer.huawei.com](https://developer.huawei.com).
2. Log in to **AppGallery Connect** → **Users and permissions** → **Devices**.
3. On your watch, go to **Settings → About → scroll to Device UDID** and note it down.
   - Alternatively, connect via HDC (see below) and run: `hdc shell bm get --udid`
4. **Add the UDID** as a test device in AppGallery Connect.
5. **Create a debug signing certificate and provisioning profile** in AppGallery Connect.
6. Download the signing files and configure them in `build-profile.json5` under `signingConfigs`.
7. Rebuild — the new `.hap` will be signed for your device.

### Option A: Install via Phone (No Computer Needed)

1. Install **HUAWEI DevEco Assistant** on your phone from AppGallery.
2. Open DevEco Assistant and pair it with your Watch D2 via Bluetooth.
3. Transfer the `.hap` file to your phone (AirDrop, email, cloud drive, etc.).
4. In DevEco Assistant, tap **Install App** and select the `.hap` file.
5. The app will be pushed to your watch over Bluetooth.
6. Find "D2 Prototype" in your watch app list and open it.

### Option B: Install via HDC (Computer Required)

1. Enable HDC debugging on your watch (see below).
2. Connect the watch to your computer via its charging cradle (USB).
3. Run:
   ```bash
   hdc install path/to/your-file.hap
   ```
4. The app appears in the watch app list.

---

## Enabling HDC Debugging on Watch D2

1. On your watch, open **Settings**.
2. Go to **About** and tap **HarmonyOS Version** 7 times to enable Developer Mode.
3. Go back to **Settings → Developer Options**.
4. Turn on **USB Debugging**.
5. Connect the watch to your computer via the charging cradle.
6. On your computer, run `hdc list targets` to confirm the watch is detected.

---

## Editing the App

The main UI code is in:

```
entry/src/main/ets/pages/Index.ets
```

### What You Can Change

- **Clock style**: Modify the `Text(this.currentTime)` section (font size, color, weight).
- **Heart rate display**: Edit the heart rate `Row()` block.
- **Tap action**: Change the `onClick` handler and toast message.
- **Add new pages**: Create new `.ets` files in the `pages/` folder and register them in `entry/src/main/resources/base/profile/main_pages.json`.
- **Colors and theme**: Adjust `backgroundColor`, `fontColor` values throughout.

### After Making Changes

1. Commit and push to `main`:
   ```bash
   git add .
   git commit -m "your change description"
   git push
   ```
2. Wait for the GitHub Actions build to finish.
3. Download the new `.hap` and install it on your watch.

---

## Project Structure

```
D2app/
├── AppScope/              # App-level config and resources
│   ├── app.json5          # Bundle name, version, app label
│   └── resources/         # App icon, strings
├── entry/                 # Main module
│   ├── src/main/
│   │   ├── ets/
│   │   │   ├── entryability/EntryAbility.ets   # App lifecycle
│   │   │   └── pages/Index.ets                 # Main watch face UI
│   │   ├── module.json5                        # Module config (permissions, device type)
│   │   └── resources/                          # Module resources
│   ├── build-profile.json5
│   └── oh-package.json5
├── .github/workflows/build-hap.yml   # CI build pipeline
├── build-profile.json5               # Project build config
├── oh-package.json5                  # Dependencies
└── README.md
```

---

## Troubleshooting

- **Build fails**: Check the Actions log. Common issues: missing SDK setup, dependency resolution.
- **App won't install**: Ensure your watch UDID is registered and the `.hap` is signed with a matching provisioning profile.
- **HR sensor shows "Unavailable"**: The sensor only works on real hardware, not in the emulator. Make sure `READ_HEALTH_DATA` permission is granted.
- **Watch not detected via HDC**: Try a different USB cable, restart the watch, or re-enable USB debugging.
