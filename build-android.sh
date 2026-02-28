#!/bin/bash

# G-Market Villa Android Build Script
# This script builds the Android APK

set -e

echo "=========================================="
echo "  G-Market Villa Android Build Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running in the correct directory
if [ ! -f "capacitor.config.json" ]; then
    print_error "Please run this script from the gmarket-villa-app directory"
    exit 1
fi

# Check for Java
if ! command -v java &> /dev/null; then
    print_error "Java is not installed. Please install Java 17 or higher."
    print_info "Download from: https://adoptium.net/"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    print_warn "Java version is $JAVA_VERSION. Recommended: 17 or higher"
fi

print_info "Java version: $(java -version 2>&1 | head -n 1)"

# Check for Android SDK
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
    print_warn "ANDROID_HOME or ANDROID_SDK_ROOT is not set"
    print_info "Trying to find Android SDK..."
    
    # Common Android SDK locations
    SDK_LOCATIONS=(
        "$HOME/Android/Sdk"
        "$HOME/Library/Android/sdk"
        "/usr/local/android-sdk"
        "/opt/android-sdk"
        "$HOME/android-sdk"
    )
    
    for loc in "${SDK_LOCATIONS[@]}"; do
        if [ -d "$loc" ]; then
            export ANDROID_HOME="$loc"
            print_info "Found Android SDK at: $loc"
            break
        fi
    done
    
    if [ -z "$ANDROID_HOME" ]; then
        print_error "Android SDK not found. Please install Android SDK."
        print_info "Download from: https://developer.android.com/studio"
        exit 1
    fi
fi

# Add Android SDK tools to PATH
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"

# Check for Android build tools
if ! command -v sdkmanager &> /dev/null && ! command -v avdmanager &> /dev/null; then
    print_warn "Android command line tools not found in PATH"
    print_info "Make sure cmdline-tools are installed and in PATH"
fi

# Sync Capacitor
print_info "Syncing Capacitor with Android platform..."
npx cap sync android

# Build APK
print_info "Building Android APK..."
cd android

# Check if gradlew exists and is executable
if [ ! -f "./gradlew" ]; then
    print_error "Gradle wrapper not found. Trying to use system gradle..."
    
    if command -v gradle &> /dev/null; then
        print_info "Using system gradle"
        gradle assembleDebug
    else
        print_error "Gradle not found. Please install Gradle."
        print_info "Download from: https://gradle.org/install/"
        exit 1
    fi
else
    chmod +x ./gradlew
    ./gradlew assembleDebug
fi

# Check if build was successful
APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK_PATH" ]; then
    echo ""
    print_info "=========================================="
    print_info "  BUILD SUCCESSFUL!"
    print_info "=========================================="
    echo ""
    print_info "APK Location: $(pwd)/$APK_PATH"
    print_info "APK Size: $(du -h $APK_PATH | cut -f1)"
    echo ""
    print_info "To install on your device:"
    print_info "  adb install $APK_PATH"
    echo ""
    print_info "To build release APK:"
    print_info "  ./gradlew assembleRelease"
    echo ""
else
    print_error "Build failed. APK not found."
    exit 1
fi
