# G-Market Villa Android App - Build Instructions

## Project Overview
This is a production-ready Android app for G-Market Villa, a marketplace platform where partners can sell products and buyers can purchase items.

## Features
- User authentication (Buyer, Partner, Admin roles)
- Product marketplace with search and filters
- Partner dashboard with earnings tracking
- Cart and wishlist functionality
- Product reviews and ratings
- Camera functionality for product photos
- Bank withdrawals (GTBank, UBA, Zenith, First Bank, OPay, Kuda, PalmPay, Moniepoint)
- Admin panel for platform management
- WhatsApp complaint center

## Pre-built Project Structure
```
gmarket-villa-app/
├── www/                          # Web assets
│   ├── index.html               # Main app file
│   └── logo.png                 # App icon
├── android/                      # Android native project
│   ├── app/
│   │   ├── src/
│   │   │   ├── main/
│   │   │   │   ├── AndroidManifest.xml
│   │   │   │   ├── assets/
│   │   │   │   ├── java/
│   │   │   │   └── res/         # Icons & splash screens
│   │   │   └── build.gradle
│   │   └── build.gradle
│   ├── gradle/
│   ├── gradlew
│   └── settings.gradle
├── capacitor.config.json        # Capacitor configuration
└── package.json
```

## Build Options

### Option 1: Build Locally with Android Studio (Recommended)

1. **Install Prerequisites:**
   - Android Studio (latest version)
   - Java JDK 17 or higher
   - Node.js 18 or higher

2. **Open Project in Android Studio:**
   ```bash
   # Navigate to android folder
   cd gmarket-villa-app/android
   
   # Open in Android Studio
   studio .
   ```

3. **Build APK:**
   - In Android Studio, go to `Build` → `Build Bundle(s) / APK(s)` → `Build APK(s)`
   - The APK will be generated at: `android/app/build/outputs/apk/debug/app-debug.apk`

### Option 2: Build with Gradle Command Line

1. **Set up environment:**
   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
   ```

2. **Build debug APK:**
   ```bash
   cd gmarket-villa-app/android
   ./gradlew assembleDebug
   ```

3. **Build release APK:**
   ```bash
   ./gradlew assembleRelease
   ```

### Option 3: Build with Capacitor CLI

1. **Install dependencies:**
   ```bash
   cd gmarket-villa-app
   npm install
   ```

2. **Sync web assets:**
   ```bash
   npx cap sync android
   ```

3. **Open in Android Studio:**
   ```bash
   npx cap open android
   ```

## Default Login Credentials

### Demo Accounts:
- **Buyer:** `buyer@demo.com` / `pass`
- **Partner:** `partner@demo.com` / `pass`
- **Admin:** `admin` / `admin123`

## App Configuration

### App ID: `com.gmarketvilla.app`
### App Name: `G-Market Villa`
### Version: 1.0.0

## Permissions Required
- Internet access
- Camera access (for product photos)
- Storage access (for image uploads)

## Customization

### Change App Icon:
Replace files in `android/app/src/main/res/mipmap-*/`

### Change Splash Screen:
Replace files in `android/app/src/main/res/drawable-*/splash.png`

### Change App Colors:
Edit `capacitor.config.json`:
```json
{
  "plugins": {
    "SplashScreen": {
      "backgroundColor": "#1e5631"
    }
  }
}
```

## Troubleshooting

### Issue: Gradle sync fails
**Solution:**
1. File → Invalidate Caches / Restart
2. Sync Project with Gradle Files

### Issue: Build fails with SDK errors
**Solution:**
1. Open SDK Manager in Android Studio
2. Install Android SDK 34
3. Install Build Tools 34.0.0

### Issue: App crashes on launch
**Solution:**
1. Check `capacitor.config.json` is valid JSON
2. Ensure `www/index.html` exists
3. Run `npx cap sync android` again

## Release Build

For production release:

1. **Generate keystore:**
   ```bash
   keytool -genkey -v -keystore gmarket-villa.keystore -alias gmarketvilla -keyalg RSA -keysize 2048 -validity 10000
   ```

2. **Configure signing:**
   Add to `android/app/build.gradle`:
   ```gradle
   android {
       signingConfigs {
           release {
               storeFile file("gmarket-villa.keystore")
               storePassword "your-password"
               keyAlias "gmarketvilla"
               keyPassword "your-password"
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

3. **Build release:**
   ```bash
   ./gradlew assembleRelease
   ```

## Support
For issues or questions, contact support via WhatsApp: +234 901 440 6974

## License
© 2024 G-Market Villa. All rights reserved.
