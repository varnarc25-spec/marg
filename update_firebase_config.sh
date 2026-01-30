#!/bin/bash

# Script to update Firebase configuration files after adding SHA-1 fingerprint
# This regenerates google-services.json and firebase_options.dart with latest config

echo "🔥 Updating Firebase Configuration Files"
echo "=========================================="
echo ""
echo "This will regenerate your Firebase config files with the latest"
echo "settings from Firebase Console (including OAuth client info for Google Sign-In)"
echo ""

cd /Users/saiporala/Documents/sai/marg

# Check if FlutterFire CLI is installed
if ! dart pub global list | grep -q flutterfire_cli; then
    echo "📦 Installing FlutterFire CLI..."
    dart pub global activate flutterfire_cli
fi

echo "✅ FlutterFire CLI is ready"
echo ""

# Run FlutterFire configure
echo "⚙️  Running flutterfire configure..."
echo "   Select project: marg-af127"
echo "   Select platforms: Android (and others you need)"
echo ""

flutterfire configure

echo ""
echo "✅ Configuration updated!"
echo ""
echo "📝 What was updated:"
echo "   - android/app/google-services.json (now includes OAuth client for Google Sign-In)"
echo "   - lib/firebase_options.dart (regenerated)"
echo "   - ios/Runner/GoogleService-Info.plist (if iOS selected)"
echo ""
echo "🎉 You can now test Google Sign-In in your app!"
