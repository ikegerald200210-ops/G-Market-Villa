# G-Market Villa - Build Guide

This guide explains how to build the Android APK and iOS IPA for G-Market Villa.

## Quick Start

### Option 1: GitHub Actions (Easiest - Recommended)

1. **Push to GitHub:**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/YOUR_USERNAME/gmarket-villa.git
   git push -u origin main
   ```

2. **GitHub will automatically build:**
   - Go to Actions tab in your GitHub repository
   - Wait for the build to complete
   - Download the APK from the Artifacts section

### Option 2: Using Docker

```bash
# Build using Docker
docker-compose up --build

# APK will be in the output folder
ls output/G-Market-Villa.apk
```

### Option 3: Using Build Scripts

```bash
# Make scripts executable
chmod +x BUILD_ALL.sh build-android.sh

# Build Android
./BUILD_ALL.sh android

# Setup iOS (macOS only)
./BUILD_ALL.sh ios

# Build both
./BUILD_ALL.sh all
```

### Option 4: Android Studio (Most Reliable)

1. Open the `android` folder in Android Studio
2. Wait for Gradle sync
3. Build → Build Bundle(s) / APK(s) → Build APK(s)
4. APK: `android/app/build/outputs/apk/debug/app-debug.apk`

---

## Detailed Instructions

## Android Build

### Prerequisites

- **Java JDK 17+** - [Download](https://adoptium.net/)
- **Android SDK** - [Download Android Studio](https://developer.android.com/studio)
- **Node.js 18+** - [Download](https://nodejs.org/)
- **Gradle** (optional, wrapper included)

### Step-by-Step Build

1. **Install Dependencies:**
   ```bash
   npm install
   ```

2. **Sync Capacitor:**
   ```bash
   npx cap sync android
   ```

3. **Build APK:**
   ```bash
   cd android
   ./gradlew assembleDebug
   ```

4. **Find APK:**
   ```bash
   ls app/build/outputs/apk/debug/app-debug.apk
   ```

### Build Release APK (Signed)

1. **Generate Keystore:**
   ```bash
   keytool -genkey -v \
     -keystore gmarket-villa.keystore \
     -alias gmarketvilla \
     -keyalg RSA \
     -keysize 2048 \
     -validity 10000
   ```

2. **Configure Signing:**
   Create `android/app/keystore.properties`:
   ```properties
   storePassword=YOUR_PASSWORD
   keyPassword=YOUR_PASSWORD
   keyAlias=gmarketvilla
   storeFile=../../gmarket-villa.keystore
   ```

3. **Build Release:**
   ```bash
   cd android
   ./gradlew assembleRelease
   ```

---

## iOS Build

### Prerequisites

- **macOS** (required for iOS builds)
- **Xcode 14+** - [Download from App Store](https://apps.apple.com/us/app/xcode/id497799835)
- **Node.js 18+**
- **iOS Developer Account** (for device testing)

### Step-by-Step Build

1. **Install iOS Platform:**
   ```bash
   npm install @capacitor/ios
   npx cap add ios
   ```

2. **Sync Capacitor:**
   ```bash
   npx cap sync ios
   ```

3. **Open in Xcode:**
   ```bash
   npx cap open ios
   ```

4. **Configure Signing:**
   - Select your Apple ID in Xcode → Preferences → Accounts
   - Select the project in navigator
   - Go to Signing & Capabilities
   - Select your team
   - Update Bundle Identifier if needed

5. **Build:**
   - Select a device or simulator
   - Press Cmd+B to build
   - Press Cmd+R to run

### Create IPA for Distribution

1. **Archive:**
   - Product → Archive
   - Wait for archive to complete

2. **Distribute:**
   - Click "Distribute App"
   - Select distribution method (App Store, Ad Hoc, etc.)
   - Follow prompts to sign and export

---

## Online Build Services

### Using Bitrise.io

1. Sign up at [bitrise.io](https://bitrise.io)
2. Add your GitHub repository
3. Select "Capacitor" as the project type
4. Follow the setup wizard
5. Builds will run automatically on each push

### Using Codemagic

1. Sign up at [codemagic.io](https://codemagic.io)
2. Connect your GitHub repository
3. Add build configuration for Android/iOS
4. Trigger builds manually or automatically

---

## Troubleshooting

### Android Build Issues

**Issue: Gradle sync fails**
```bash
# Solution 1: Clear Gradle cache
./gradlew clean
rm -rf ~/.gradle/caches

# Solution 2: Invalidate caches in Android Studio
File → Invalidate Caches / Restart
```

**Issue: SDK not found**
```bash
# Set ANDROID_HOME
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

**Issue: Build fails with memory error**
```bash
# Increase Gradle heap size
export GRADLE_OPTS="-Xmx4g -XX:MaxMetaspaceSize=512m"
```

### iOS Build Issues

**Issue: Signing errors**
- Ensure you have a valid Apple ID in Xcode
- Check that Bundle Identifier is unique
- Verify provisioning profile is set correctly

**Issue: Capacitor sync fails**
```bash
# Reinstall iOS platform
rm -rf ios
npx cap add ios
npx cap sync ios
```

---

## Build Outputs

### Android
- **Debug APK:** `android/app/build/outputs/apk/debug/app-debug.apk`
- **Release APK:** `android/app/build/outputs/apk/release/app-release-unsigned.apk`
- **AAB:** `android/app/build/outputs/bundle/release/app-release.aab`

### iOS
- **Simulator:** `ios/App/build/Build/Products/Debug-iphonesimulator/App.app`
- **Device:** `ios/App/build/Build/Products/Debug-iphoneos/App.app`
- **IPA:** Exported from Xcode Organizer

---

## App Information

| Property | Value |
|----------|-------|
| App ID | `com.gmarketvilla.app` |
| App Name | `G-Market Villa` |
| Version | 1.0.0 |
| Min Android SDK | 22 (Android 5.1) |
| Target Android SDK | 34 (Android 14) |
| Min iOS Version | 13.0 |

---

## Need Help?

- **WhatsApp:** +234 901 440 6974
- **GitHub Issues:** Create an issue in your repository
- **Capacitor Docs:** https://capacitorjs.com/docs

---

## License

© 2024 G-Market Villa. All rights reserved.
