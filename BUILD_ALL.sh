#!/bin/bash

# G-Market Villa - Build Script for Android and iOS
# Usage: ./BUILD_ALL.sh [android|ios|all]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}  G-Market Villa Build Script${NC}"
    echo -e "${BLUE}==========================================${NC}"
    echo ""
}

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Check directory
if [ ! -f "capacitor.config.json" ]; then
    print_error "Please run this script from the gmarket-villa-app directory"
    exit 1
fi

print_header

# Function to build Android
build_android() {
    echo -e "${BLUE}--- Building Android APK ---${NC}"
    echo ""
    
    # Check for Docker
    if command -v docker &> /dev/null; then
        print_info "Docker found. Using Docker for build..."
        
        # Create output directory
        mkdir -p output
        
        # Build using Docker
        print_info "Building Docker image (this may take a while)..."
        if docker-compose build android-build 2>&1; then
            print_info "Running build container..."
            if docker-compose up android-build 2>&1; then
                if [ -f "output/G-Market-Villa.apk" ]; then
                    print_success "Android APK built successfully!"
                    print_info "APK Location: $(pwd)/output/G-Market-Villa.apk"
                    ls -lh output/G-Market-Villa.apk
                else
                    print_error "Build completed but APK not found"
                    return 1
                fi
            else
                print_error "Docker build failed"
                return 1
            fi
        else
            print_warn "Docker build failed. Falling back to local build..."
            build_android_local
        fi
    else
        print_warn "Docker not found. Using local build..."
        build_android_local
    fi
}

# Function to build Android locally
build_android_local() {
    print_info "Building Android APK locally..."
    
    # Check for Java
    if ! command -v java &> /dev/null; then
        print_error "Java is not installed. Please install Java 17+."
        print_info "Download: https://adoptium.net/"
        return 1
    fi
    
    # Check for Android SDK
    if [ -z "$ANDROID_HOME" ]; then
        # Try common locations
        for loc in "$HOME/Android/Sdk" "$HOME/Library/Android/sdk" "/usr/local/android-sdk"; do
            if [ -d "$loc" ]; then
                export ANDROID_HOME="$loc"
                print_info "Found Android SDK at: $loc"
                break
            fi
        done
        
        if [ -z "$ANDROID_HOME" ]; then
            print_error "Android SDK not found. Please install Android SDK."
            print_info "Download: https://developer.android.com/studio"
            return 1
        fi
    fi
    
    export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"
    
    # Sync Capacitor
    print_info "Syncing Capacitor..."
    npx cap sync android
    
    # Build APK
    print_info "Building APK..."
    cd android
    
    if [ -f "./gradlew" ]; then
        chmod +x ./gradlew
        if ./gradlew assembleDebug; then
            print_success "Build successful!"
            print_info "APK: $(pwd)/app/build/outputs/apk/debug/app-debug.apk"
        else
            print_error "Gradle build failed"
            return 1
        fi
    elif command -v gradle &> /dev/null; then
        if gradle assembleDebug; then
            print_success "Build successful!"
            print_info "APK: $(pwd)/app/build/outputs/apk/debug/app-debug.apk"
        else
            print_error "Gradle build failed"
            return 1
        fi
    else
        print_error "Gradle not found. Please install Gradle."
        print_info "Download: https://gradle.org/install/"
        return 1
    fi
    
    cd ..
}

# Function to setup iOS
setup_ios() {
    echo -e "${BLUE}--- Setting up iOS Build ---${NC}"
    echo ""
    
    # Check if running on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_warn "iOS builds require macOS. Skipping iOS setup."
        print_info "To build iOS app, you need:"
        print_info "  - A Mac computer"
        print_info "  - Xcode installed"
        print_info "  - iOS provisioning profile"
        return 1
    fi
    
    # Check for Xcode
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode not found. Please install Xcode from the App Store."
        return 1
    fi
    
    # Install iOS platform if not already installed
    if [ ! -d "ios" ]; then
        print_info "Installing iOS platform..."
        npm install @capacitor/ios
        npx cap add ios
    fi
    
    # Sync Capacitor
    print_info "Syncing Capacitor..."
    npx cap sync ios
    
    # Open in Xcode
    print_info "Opening project in Xcode..."
    npx cap open ios
    
    print_success "iOS project setup complete!"
    print_info "Build the app in Xcode:"
    print_info "  1. Select your team in Signing & Capabilities"
    print_info "  2. Choose a device or simulator"
    print_info "  3. Click Build (Cmd+B) or Run (Cmd+R)"
}

# Function to show manual build instructions
show_manual_instructions() {
    echo ""
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}  Manual Build Instructions${NC}"
    echo -e "${BLUE}==========================================${NC}"
    echo ""
    
    echo -e "${GREEN}Option 1: Using Android Studio (Recommended)${NC}"
    echo "  1. Open the 'android' folder in Android Studio"
    echo "  2. Wait for Gradle sync to complete"
    echo "  3. Go to Build → Build Bundle(s) / APK(s) → Build APK(s)"
    echo "  4. APK will be at: android/app/build/outputs/apk/debug/app-debug.apk"
    echo ""
    
    echo -e "${GREEN}Option 2: Using Docker${NC}"
    echo "  1. Install Docker: https://docs.docker.com/get-docker/"
    echo "  2. Run: docker-compose up --build"
    echo "  3. APK will be in the 'output' folder"
    echo ""
    
    echo -e "${GREEN}Option 3: Online Build Services${NC}"
    echo "  - Use GitHub Actions with Android build workflow"
    echo "  - Use Bitrise.io for CI/CD builds"
    echo "  - Use Codemagic for Flutter/Capacitor builds"
    echo ""
    
    echo -e "${GREEN}Option 4: Using Buildozer (Python-for-Android)${NC}"
    echo "  This is an alternative build system for Python apps"
    echo ""
}

# Main script
TARGET=${1:-all}

case "$TARGET" in
    android)
        build_android
        ;;
    ios)
        setup_ios
        ;;
    all)
        build_android
        echo ""
        setup_ios
        ;;
    help|--help|-h)
        echo "Usage: $0 [android|ios|all|help]"
        echo ""
        echo "  android - Build Android APK only"
        echo "  ios     - Setup iOS project only"
        echo "  all     - Build both Android and setup iOS (default)"
        echo "  help    - Show this help message"
        echo ""
        show_manual_instructions
        ;;
    *)
        print_error "Unknown target: $TARGET"
        echo "Usage: $0 [android|ios|all|help]"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}==========================================${NC}"
echo -e "${GREEN}  Build process completed!${NC}"
echo -e "${BLUE}==========================================${NC}"
