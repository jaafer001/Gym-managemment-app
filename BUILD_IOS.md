# Building for iOS - Gym_membership App

## ⚠️ Important Prerequisites

### Requirements:
1. **macOS** - iOS development requires a Mac (macOS 10.15 or later)
2. **Xcode** - Latest version installed from App Store
3. **Apple Developer Account** - Free account for development, paid ($99/year) for App Store distribution
4. **CocoaPods** - iOS dependency manager

### ❌ Can't Build on Linux
If you're currently on Linux, you **cannot build iOS apps directly**. You would need:
- Access to a Mac computer, OR
- Use cloud Mac services (MacStadium, AWS Mac instances, etc.), OR
- Use CI/CD services with Mac runners

---

## If You Have a Mac

### Step 1: Install Xcode
```bash
# Install from App Store or download from Apple Developer
# Make sure to also install Command Line Tools:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

### Step 2: Install CocoaPods
```bash
sudo gem install cocoapods
```

### Step 3: Install iOS Dependencies
```bash
cd ~/StudioProjects/gym2/ios
pod install
cd ..
```

### Step 4: Open in Xcode (Recommended for First Setup)
```bash
open ios/Runner.xcworkspace
```

In Xcode:
1. Select your development team in "Signing & Capabilities"
2. Connect your iPhone via USB
3. Select your device from the device list
4. Click the Play button to build and run

### Step 5: Build via Command Line
```bash
# Check available iOS devices/simulators
flutter devices

# Run on connected iPhone
flutter run

# Or build for iOS device
flutter build ios --release
```

---

## Build Options

### 1. Development Build (for Testing)
```bash
flutter run -d <ios-device-id>
```

### 2. Release Build (for App Store/TestFlight)
```bash
flutter build ios --release
```

This creates an `.app` file that can be:
- Uploaded to App Store Connect
- Installed via TestFlight
- Archived in Xcode for distribution

### 3. Build IPA (for Distribution)
Requires Xcode and proper signing:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Product → Archive
3. Distribute App → Choose distribution method
4. Follow the wizard

### 4. Build for Simulator
```bash
flutter run -d iPhone
# Or specify simulator
flutter run -d "iPhone 15 Pro"
```

---

## Code Signing Setup

### For Development (Free Apple Developer Account):
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner project → Signing & Capabilities
3. Enable "Automatically manage signing"
4. Select your Team (your Apple ID)

### For App Store Distribution:
1. Need paid Apple Developer account ($99/year)
2. Create App ID in Apple Developer portal
3. Configure signing with distribution certificates
4. Create provisioning profiles

---

## Current iOS Configuration

- **Bundle Identifier**: com.example.gym2
- **Display Name**: Gym_membership
- **Version**: 1.0.0
- **Supported iOS Versions**: Check `ios/Podfile` for minimum iOS version

### To Update Bundle ID (if needed):
1. Open `ios/Runner.xcodeproj` in Xcode
2. Change Bundle Identifier in project settings
3. Or update `ios/Runner/Info.plist` CFBundleIdentifier

---

## Troubleshooting

### "No devices found"
- Make sure iPhone is connected via USB
- Unlock your iPhone
- Trust the computer when prompted
- Check: Settings → General → Device Management

### "Signing for Runner requires a development team"
- Open project in Xcode
- Add your Apple ID as development team
- Or configure signing manually

### CocoaPods Issues
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### Xcode Build Errors
1. Clean build folder: Xcode → Product → Clean Build Folder
2. Delete DerivedData
3. Reinstall pods: `pod install`
4. Update Flutter: `flutter upgrade`

---

## Using Cloud Mac Services (If No Mac Available)

### Option 1: MacStadium / AWS Mac Instances
- Rent a cloud Mac
- Remote into Mac
- Build iOS app there

### Option 2: GitHub Actions / CI/CD
```yaml
# Example GitHub Actions workflow
jobs:
  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter build ios --release
```

### Option 3: Codemagic / AppCircle
- CI/CD services with Mac builders
- Upload code, they build iOS app
- Download IPA file

---

## Alternative: Build APK Only

If you only have Android phone and no Mac:
- Build APK (already configured)
- Install APK directly on Android phone
- iOS build would need to wait until you have Mac access

---

## Next Steps if You Have Mac

1. **Connect iPhone via USB**
2. **Open project**: `open ios/Runner.xcworkspace`
3. **Configure signing** in Xcode
4. **Build and run**: `flutter run`

If you're on Linux/Windows, you'll need Mac access (physical or cloud) to build iOS apps.

