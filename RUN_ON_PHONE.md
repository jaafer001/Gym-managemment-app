# Run App on Android Phone - Step by Step Guide

## Prerequisites

### 1. Enable USB Debugging on Your Phone
1. Go to **Settings** → **About Phone**
2. Tap **Build Number** 7 times to enable Developer Options
3. Go to **Settings** → **Developer Options**
4. Enable **USB Debugging**
5. Connect your phone to your computer via USB cable

### 2. Verify Phone Connection

```bash
# Check if ADB can see your device
adb devices
```

You should see your device listed. If not:
- Make sure USB debugging is enabled
- Accept the "Allow USB debugging" prompt on your phone
- Try a different USB cable/port

## Run the App

### Step 1: Check Connected Devices
```bash
cd ~/StudioProjects/gym2
flutter devices
```

This will show all available devices (connected phones/emulators).

### Step 2: Run on Your Phone
```bash
flutter run
```

Or to run in release mode:
```bash
flutter run --release
```

### Step 3: If Multiple Devices are Connected
If you have multiple devices, specify which one:
```bash
flutter devices  # List devices and note the device ID
flutter run -d <device-id>
```

## Troubleshooting

### Phone Not Detected?
1. **Install ADB drivers** (if on Windows):
   - Download Android SDK Platform Tools
   - Or install device manufacturer drivers

2. **Check USB connection mode**:
   - Change USB mode to "File Transfer" or "MTP" mode
   - Don't use "Charge only" mode

3. **Restart ADB server**:
   ```bash
   adb kill-server
   adb start-server
   adb devices
   ```

### "Waiting for device" issue?
- Make sure USB debugging is enabled and authorized
- Unplug and replug the USB cable
- Restart ADB: `adb kill-server && adb start-server`

### Flutter Not Found?
If flutter command is not found, add it to PATH or use full path:
```bash
/opt/flutter/bin/flutter run
```

Or add to your `.bashrc` or `.zshrc`:
```bash
export PATH="$PATH:/opt/flutter/bin"
```

## Quick Commands Summary

```bash
# Navigate to project
cd ~/StudioProjects/gym2

# Check devices
flutter devices

# Run app
flutter run

# Run in release mode (optimized)
flutter run --release

# Hot reload: Press 'r' in terminal
# Hot restart: Press 'R' in terminal
# Quit: Press 'q' in terminal
```

## Wireless Debugging (Alternative)

If you prefer wireless debugging:

1. Connect phone via USB first
2. Enable wireless debugging in Developer Options
3. Connect to same WiFi network
4. Run: `adb tcpip 5555`
5. Disconnect USB
6. Connect wirelessly: `adb connect <phone-ip-address>:5555`
7. Run: `flutter run`

---

**Note**: Make sure your phone is unlocked and you've accepted the USB debugging authorization prompt!
