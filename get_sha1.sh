#!/bin/bash

# Script to get SHA-1 fingerprint for Firebase Google Sign-In on Mac M2
# Usage: ./get_sha1.sh

echo "🔐 Getting SHA-1 Fingerprint for Firebase Google Sign-In"
echo "=========================================================="
echo ""

# Check if we're in the project directory
if [ ! -d "android" ]; then
    echo "❌ Error: Please run this script from the marg project root directory"
    echo "   Current directory: $(pwd)"
    exit 1
fi

echo "📱 Method 1: Using Keytool (Debug Keystore)"
echo "--------------------------------------------"

# Try to find keytool in common locations (Mac M2/Apple Silicon)
KEYTOOL_PATH=""
if [ -f "/opt/homebrew/opt/openjdk/bin/keytool" ]; then
    KEYTOOL_PATH="/opt/homebrew/opt/openjdk/bin/keytool"
elif [ -f "/usr/libexec/java_home" ]; then
    JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
    if [ -n "$JAVA_HOME" ] && [ -f "$JAVA_HOME/bin/keytool" ]; then
        KEYTOOL_PATH="$JAVA_HOME/bin/keytool"
    fi
elif command -v keytool &> /dev/null; then
    KEYTOOL_PATH="keytool"
fi

if [ -n "$KEYTOOL_PATH" ]; then
    echo "Getting SHA-1 from debug keystore..."
    SHA1=$($KEYTOOL_PATH -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android 2>/dev/null | grep -A 5 "Certificate fingerprints:" | grep SHA1 | sed 's/.*SHA1: //' | xargs)
    
    if [ -n "$SHA1" ]; then
        SHA256=$($KEYTOOL_PATH -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android 2>/dev/null | grep -A 5 "Certificate fingerprints:" | grep SHA256 | sed 's/.*SHA256: //' | xargs)
        echo ""
        echo "✅ SHA-1 Fingerprint (REQUIRED for Google Sign-In):"
        echo "   $SHA1"
        echo ""
        if [ -n "$SHA256" ]; then
            echo "✅ SHA-256 Fingerprint (Optional but recommended):"
            echo "   $SHA256"
            echo ""
        fi
        echo "📋 Copy SHA-1 (and optionally SHA-256) and add to Firebase Console"
    else
        echo "⚠️  Could not read debug keystore. It might not exist yet."
        echo "   This is normal if you haven't built the app yet."
        echo ""
    fi
else
    echo "❌ keytool not found. Make sure Java is installed."
    echo "   Try: brew install openjdk"
    echo ""
fi

echo "📱 Method 2: Using Gradle (Alternative)"
echo "----------------------------------------"
if [ -f "android/gradlew" ]; then
    echo "Running Gradle signing report..."
    cd android
    ./gradlew signingReport 2>/dev/null | grep -A 10 "Variant: debug" | grep SHA1 | head -1 | sed 's/.*SHA1: //' | sed 's/ //g'
    cd ..
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ SHA-1 copied above ↑"
        echo ""
    fi
else
    echo "⚠️  Gradle wrapper not found."
    echo ""
fi

echo "📋 Instructions:"
echo "1. Copy the SHA-1 fingerprint shown above"
echo "2. Go to: https://console.firebase.google.com/project/marg-af127/settings/general"
echo "3. Find your Android app (com.varnarc.marg)"
echo "4. Click on it and scroll to 'SHA certificate fingerprints'"
echo "5. Click 'Add fingerprint' and paste the SHA-1"
echo "6. Click 'Save'"
echo ""
echo "🔗 Quick Links:"
echo "   - Firebase Console: https://console.firebase.google.com/project/marg-af127"
echo "   - Project Settings: https://console.firebase.google.com/project/marg-af127/settings/general"
echo ""
