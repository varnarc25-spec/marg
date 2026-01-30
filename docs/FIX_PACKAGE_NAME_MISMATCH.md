# Fix Package Name Mismatch: com.example.marg vs com.varnarc.marg

## Problem
Your app uses `com.varnarc.marg` but Firebase is configured for `com.example.marg`. This mismatch causes Google Sign-In to fail.

**Current Situation:**
- ✅ **App Package Name**: `com.varnarc.marg` (correct in build.gradle.kts, Xcode)
- ❌ **Firebase Configuration**: `com.example.marg` (wrong in firebase_options.dart, google-services.json)
- ❌ **OAuth Client IDs**: Configured for `com.example.marg` (wrong in Google Cloud Console)

## Solution: Reconfigure Firebase with Correct Package Name

### Option 1: Use FlutterFire CLI (Recommended)

This will update all Firebase configuration files to match your actual app package name.

1. **Navigate to your project:**
   ```bash
   cd /Users/saiporala/Documents/sai/marg
   ```

2. **Run FlutterFire configure:**
   ```bash
   flutterfire configure
   ```

3. **When prompted:**
   - Select project: `marg-af127`
   - Select platforms:
     - ✅ **Android** - When asked for package name, enter: `com.varnarc.marg`
     - ✅ **iOS** - When asked for bundle ID, enter: `com.varnarc.marg`
     - ✅ **Web** (keep existing)
     - ✅ **macOS** (keep existing)
     - ✅ **Windows** (keep existing)

4. **This will:**
   - Update `firebase_options.dart` with correct package/bundle IDs
   - Download new `google-services.json` with `com.varnarc.marg`
   - Download new `GoogleService-Info.plist` with `com.varnarc.marg`
   - Create new OAuth client IDs in Google Cloud Console for `com.varnarc.marg`

### Option 2: Create New Apps in Firebase (Required - Bundle IDs Can't Be Edited)

**⚠️ Important:** Firebase **does not allow** editing bundle IDs or package names after an app is created. You must create **new apps** with the correct bundle ID.

**See detailed guide:** [CREATE_NEW_FIREBASE_APP.md](./CREATE_NEW_FIREBASE_APP.md)

**Quick Steps:**
1. Go to: https://console.firebase.google.com/project/marg-af127/settings/general
2. Click **"Add app"** → **Android**
   - Package name: `com.varnarc.marg`
   - SHA-1: `A3:0C:A1:C5:78:8E:33:71:38:C8:56:69:E2:8D:43:9C:5C:13:D9:BB`
   - Download new `google-services.json`
3. Click **"Add app"** → **iOS**
   - Bundle ID: `com.varnarc.marg`
   - Download new `GoogleService-Info.plist`
4. Run `flutterfire configure` and select the new apps
5. Create new OAuth client IDs in Google Cloud Console

#### Step 3: Update OAuth Client IDs

The OAuth client IDs in Google Cloud Console are currently for `com.example.marg`. You have two options:

**Option A: Create New OAuth Clients (Recommended)**

1. **Go to Google Cloud Console:**
   - Navigate to: https://console.cloud.google.com/apis/credentials?project=marg-af127

2. **Create New Android OAuth Client:**
   - Click "+ Create Credentials" → "OAuth client ID"
   - Application type: **Android**
   - Name: `Android client for com.varnarc.marg`
   - Package name: `com.varnarc.marg`
   - SHA-1 certificate fingerprint: `A3:0C:A1:C5:78:8E:33:71:38:C8:56:69:E2:8D:43:9C:5C:13:D9:BB`
   - Click "Create"

3. **Create New iOS OAuth Client:**
   - Click "+ Create Credentials" → "OAuth client ID"
   - Application type: **iOS**
   - Name: `iOS client for com.varnarc.marg`
   - Bundle ID: `com.varnarc.marg`
   - Click "Create"

4. **Update firebase_options.dart:**
   - Update `androidClientId` with the new Android client ID
   - Update `iosClientId` with the new iOS client ID

**Option B: Edit Existing OAuth Clients**

1. **In Google Cloud Console:**
   - Go to: https://console.cloud.google.com/apis/credentials?project=marg-af127

2. **Edit Android OAuth Client:**
   - Click edit icon on "Android client for com.example.marg"
   - Update package name to `com.varnarc.marg`
   - Update SHA-1 if needed
   - Click "Save"

3. **Edit iOS OAuth Client:**
   - Click edit icon on "iOS client for com.example.marg"
   - Update bundle ID to `com.varnarc.marg`
   - Click "Save"

## Verify the Fix

After updating:

1. **Check firebase_options.dart:**
   ```dart
   // Should show:
   iosBundleId: 'com.varnarc.marg',  // ✅ Correct
   ```

2. **Check google-services.json:**
   ```json
   "package_name": "com.varnarc.marg"  // ✅ Correct
   ```

3. **Check GoogleService-Info.plist:**
   ```xml
   <key>BUNDLE_ID</key>
   <string>com.varnarc.marg</string>  // ✅ Correct
   ```

4. **Check OAuth Client IDs in Google Cloud Console:**
   - Should show clients for `com.varnarc.marg` (not `com.example.marg`)

5. **Test Google Sign-In:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
   - Try "Continue with Google" - should work now!

## Why This Matters

Google Sign-In requires:
1. ✅ OAuth client ID configured for your app's package name
2. ✅ Package name in `google-services.json` matches your app
3. ✅ Bundle ID in `GoogleService-Info.plist` matches your app
4. ✅ SHA-1 fingerprint matches (for Android)

If any of these don't match, Google Sign-In will fail with errors like:
- "DEVELOPER_ERROR"
- "Assertion failed"
- "No valid client ID"

## Quick Command Reference

```bash
# Reconfigure Firebase (easiest method)
cd /Users/saiporala/Documents/sai/marg
flutterfire configure

# Clean and rebuild after changes
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter run
```

## After Fixing

Once everything matches `com.varnarc.marg`:
1. ✅ Google Sign-In should work
2. ✅ Firebase will recognize your app
3. ✅ OAuth client IDs will match your package name

---

**Recommended:** Use Option 1 (FlutterFire CLI) - it's the fastest and ensures everything is synchronized correctly.
