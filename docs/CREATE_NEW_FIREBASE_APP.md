# Create New Firebase App with Correct Bundle ID

## Problem
Firebase doesn't allow editing bundle IDs or package names after an app is created. You need to create a **new app** with the correct bundle ID `com.varnarc.marg`.

## Solution: Create New Apps in Firebase Console

Since you can't edit the existing apps (`com.example.marg`), you'll create new ones with the correct bundle ID.

### Step 1: Create New Android App

1. **Go to Firebase Console:**
   - Navigate to: https://console.firebase.google.com/project/marg-af127/settings/general

2. **Add New Android App:**
   - Scroll to **"Your apps"** section
   - Click **"Add app"** → **Android** (the Android icon)

3. **Register the App:**
   - **Package name**: `com.varnarc.marg` ⚠️ **Important: Use this exact package name**
   - **App nickname**: `Marg Android` (optional, for your reference)
   - **Debug signing certificate SHA-1**: 
     ```
     A3:0C:A1:C5:78:8E:33:71:38:C8:56:69:E2:8D:43:9C:5C:13:D9:BB
     ```
   - Click **"Register app"**

4. **Download Configuration File:**
   - Click **"Download google-services.json"**
   - Save the file
   - **Replace** the existing file: `android/app/google-services.json`

### Step 2: Create New iOS App

1. **In Firebase Console:**
   - Still in **"Your apps"** section
   - Click **"Add app"** → **iOS** (the iOS icon)

2. **Register the App:**
   - **Bundle ID**: `com.varnarc.marg` ⚠️ **Important: Use this exact bundle ID**
   - **App nickname**: `Marg iOS` (optional, for your reference)
   - Click **"Register app"**

3. **Download Configuration File:**
   - Click **"Download GoogleService-Info.plist"**
   - Save the file
   - **Replace** the existing file: `ios/Runner/GoogleService-Info.plist`
   - **Also replace**: `macos/Runner/GoogleService-Info.plist` (use the same file)

### Step 3: Update FlutterFire Configuration

After creating the new apps, run FlutterFire configure to sync everything:

```bash
cd /Users/saiporala/Documents/sai/marg
flutterfire configure
```

**When prompted:**
1. Select project: `marg-af127`
2. Select platforms:
   - ✅ **Android** - Select the app with `com.varnarc.marg` (not `com.example.marg`)
   - ✅ **iOS** - Select the app with `com.varnarc.marg` (not `com.example.marg`)
   - ✅ **Web** (keep existing)
   - ✅ **macOS** (keep existing)
   - ✅ **Windows** (keep existing)

This will:
- Update `firebase_options.dart` with the new app IDs
- Ensure all configuration files match

### Step 4: Create New OAuth Client IDs

The OAuth clients in Google Cloud Console are for `com.example.marg`. Create new ones for `com.varnarc.marg`:

1. **Go to Google Cloud Console:**
   - Navigate to: https://console.cloud.google.com/apis/credentials?project=marg-af127

2. **Create New Android OAuth Client:**
   - Click **"+ Create Credentials"** → **"OAuth client ID"**
   - **Application type**: Select **Android**
   - **Name**: `Android client for com.varnarc.marg`
   - **Package name**: `com.varnarc.marg`
   - **SHA-1 certificate fingerprint**: 
     ```
     A3:0C:A1:C5:78:8E:33:71:38:C8:56:69:E2:8D:43:9C:5C:13:D9:BB
     ```
   - Click **"Create"**
   - **Copy the Client ID** (you'll need it)

3. **Create New iOS OAuth Client:**
   - Click **"+ Create Credentials"** → **"OAuth client ID"**
   - **Application type**: Select **iOS**
   - **Name**: `iOS client for com.varnarc.marg`
   - **Bundle ID**: `com.varnarc.marg`
   - Click **"Create"**
   - **Copy the Client ID** (you'll need it)

4. **Update firebase_options.dart:**
   - Open: `lib/firebase_options.dart`
   - Find the `androidClientId` and `iosClientId` fields
   - Update them with the new Client IDs you just created
   - Save the file

### Step 5: Clean and Rebuild

After all changes:

```bash
cd /Users/saiporala/Documents/sai/marg

# Clean everything
flutter clean
cd android && ./gradlew clean && cd ..

# Get dependencies
flutter pub get

# Rebuild
flutter run
```

## What About the Old Apps?

You can **keep the old apps** (`com.example.marg`) in Firebase Console - they won't interfere. Or you can delete them if you want:

1. Go to: https://console.firebase.google.com/project/marg-af127/settings/general
2. Find the old apps (`com.example.marg`)
3. Click the ⚙️ icon → **"Remove app"** (if you want to clean up)

**Note:** Deleting old apps is optional - they won't cause issues if left alone.

## Verify Everything is Correct

After setup, verify:

1. **Check firebase_options.dart:**
   ```dart
   iosBundleId: 'com.varnarc.marg',  // ✅ Should be com.varnarc.marg
   ```

2. **Check google-services.json:**
   ```json
   "package_name": "com.varnarc.marg"  // ✅ Should be com.varnarc.marg
   ```

3. **Check GoogleService-Info.plist:**
   ```xml
   <key>BUNDLE_ID</key>
   <string>com.varnarc.marg</string>  // ✅ Should be com.varnarc.marg
   ```

4. **Check OAuth Client IDs:**
   - In Google Cloud Console, you should see clients for `com.varnarc.marg`
   - The Client IDs in `firebase_options.dart` should match these

5. **Test Google Sign-In:**
   - Run the app
   - Click "Continue with Google"
   - Should work now! ✅

## Quick Summary

1. ✅ Create new Android app in Firebase with `com.varnarc.marg`
2. ✅ Create new iOS app in Firebase with `com.varnarc.marg`
3. ✅ Download and replace configuration files
4. ✅ Run `flutterfire configure` to sync
5. ✅ Create new OAuth client IDs in Google Cloud Console
6. ✅ Update `firebase_options.dart` with new Client IDs
7. ✅ Clean and rebuild

## Troubleshooting

### Issue: "App already exists" error

**Solution:** 
- Make sure you're creating a NEW app, not trying to edit the old one
- The old app is `com.example.marg` - you're creating `com.varnarc.marg` (different!)

### Issue: OAuth client creation fails

**Solution:**
- Make sure you have proper permissions in Google Cloud Console
- Verify the SHA-1 fingerprint is correct
- Check that the bundle ID matches exactly (case-sensitive)

### Issue: Still seeing old package name

**Solution:**
- Make sure you replaced `google-services.json` and `GoogleService-Info.plist`
- Run `flutter clean` and rebuild
- Check that `flutterfire configure` selected the correct apps

---

**After completing these steps, Google Sign-In should work correctly!** 🎉
