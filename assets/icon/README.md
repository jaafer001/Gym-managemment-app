# App Icon Setup

## Icon Requirements

Place your app icon image file here with the name `icon.png`.

### Icon Specifications:
- **Format**: PNG with transparency
- **Size**: At least 1024x1024 pixels (recommended)
- **Background**: Should match the dark background (#000000)
- **Content**: The "Gyment" logo with stylized "G" and barbell design

### Icon Design Description:
The icon should feature:
- A stylized capital letter "G" with rounded edges
- A barbell integrated into the design (horizontal bar with weight plates on ends)
- White color on dark/black background
- Clean, modern aesthetic

## After Adding Your Icon:

1. Make sure the icon file is named `icon.png` and placed in this directory
2. Run the following command to generate all platform icons:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```

This will automatically generate icons for:
- Android (all densities)
- iOS (all sizes)
- Adaptive icons for Android 8.0+

## Current Configuration:
- **App Name**: Gym_membership
- **Adaptive Icon Background**: #000000 (Black)
- **Icon Path**: assets/icon/icon.png
