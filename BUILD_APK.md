# Building APK for Gym_membership App

## Quick Build Commands

### Option 1: Standard APK (Recommended)
```bash
flutter clean
flutter pub get
flutter build apk --release
```

The APK will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

### Option 2: Split APKs (smaller file sizes)
```bash
flutter build apk --split-per-abi --release
```

This creates separate APKs for different architectures:
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-x86_64-release.apk`

### Option 3: App Bundle (for Google Play Store)
```bash
flutter build appbundle --release
```

The AAB will be located at:
```
build/app/outputs/bundle/release/app-release.aab
```

## Current Configuration

- **App Name**: Gym_membership
- **Package ID**: com.example.gym2
- **Signing**: Using debug signing (for testing only)
- **Min SDK**: Determined by Flutter defaults
- **Target SDK**: Determined by Flutter defaults

## Important Notes

⚠️ **Icon Warning**: If you haven't added the icon yet, the build will still work but will use default Flutter icons.

To add your custom icon:
1. Place `icon.png` in `assets/icon/`
2. Run: `flutter pub run flutter_launcher_icons`
3. Then build the APK

⚠️ **Signing**: The current build uses debug signing. For production release, you need to:
1. Create a keystore file
2. Configure signing in `android/app/build.gradle.kts`
3. Add signing configuration

## Troubleshooting

If build fails:
1. Clean build: `flutter clean`
2. Get dependencies: `flutter pub get`
3. Check Flutter doctor: `flutter doctor`
4. Try building again: `flutter build apk --release`

## File Size Optimization

To reduce APK size:
- Use `--split-per-abi` flag (Option 2)
- Enable ProGuard/R8 in release builds
- Remove unused assets and dependencies
