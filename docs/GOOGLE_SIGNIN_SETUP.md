# Google Sign-In Setup Guide for Mac M2

This guide will help you configure Google Sign-In in Firebase Console for your Marg app on Mac M2.

## Prerequisites

- Firebase project: `marg-af127`
- Android package: `com.varnarc.marg`
- iOS bundle: `com.varnarc.marg`
- Mac M2 with Flutter installed

## ⚠️ Important: Check Package Name Mismatch

**Before proceeding, verify your Firebase configuration matches your app:**

1. **Check your app's package name:**
   - Android: Check `android/app/build.gradle.kts` → `applicationId`
   - iOS: Check Xcode project → Bundle Identifier

2. **Check Firebase configuration:**
   - Look at `lib/firebase_options.dart` → `iosBundleId`
   - Look at `android/app/google-services.json` → `package_name`

3. **If they don't match:**
   - See [FIX_PACKAGE_NAME_MISMATCH.md](./FIX_PACKAGE_NAME_MISMATCH.md)
   - Run `flutterfire configure` to fix the mismatch
   - **Google Sign-In will NOT work if package names don't match!**

## Step 1: Enable Google Sign-In in Firebase Console

1. **Open Firebase Console:**
   - Go to: https://console.firebase.google.com/project/marg-af127

2. **Navigate to Authentication:**
   - Click on **Authentication** in the left sidebar
   - Click on **Sign-in method** tab

3. **Enable Google Provider:**
   - Find **Google** in the list of sign-in providers
   - Click on **Google**
   - Toggle **Enable** to ON
   - Enter a **Project support email** (your email address)
   - Click **Save**

## Step 2: Get SHA-1 Fingerprint for Android (Mac M2)

Google Sign-In requires SHA-1 fingerprint for Android. Here's how to get it on Mac M2:

### Option A: Using Keytool (Debug Keystore)

1. **Open Terminal** on your Mac M2

2. **Navigate to your project:**
   ```bash
   cd /Users/saiporala/Documents/sai/marg
   ```

3. **Get SHA-1 for debug keystore:**
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

4. **Copy the SHA-1 fingerprint** (it looks like: `AA:BB:CC:DD:EE:FF:...`)

### Option B: Using Gradle (Alternative)

If keytool doesn't work, use this command:
```bash
cd android
./gradlew signingReport
```

Look for the SHA1 value under `Variant: debug` → `Config: debug`

### Option C: For Release Build (When Publishing)

For release builds, you'll need the release keystore SHA-1:
```bash
keytool -list -v -keystore android/app/upload-keystore.jks -alias upload
```

## Step 3: Add SHA-1 to Firebase Console

1. **Go to Firebase Console:**
   - Navigate to: https://console.firebase.google.com/project/marg-af127/settings/general

2. **Find Your Android App:**
   - Scroll down to **"Your apps"** section
   - Find the Android app: `com.varnarc.marg`
   - Click on the **Android app** or the **⚙️** icon

3. **Add SHA Certificate Fingerprints:**
   - Scroll down to **"SHA certificate fingerprints"** section
   - Click **Add fingerprint**
   - Paste your SHA-1 fingerprint (from Step 2)
   - Click **Save**

4. **Update Configuration Files:**
   
   **Option A: Using FlutterFire CLI (Recommended)**
   ```bash
   cd /Users/saiporala/Documents/sai/marg
   flutterfire configure
   ```
   - Select project: `marg-af127`
   - Select platforms: Android (and others you need)
   - This will automatically regenerate `google-services.json` with OAuth client info
   
   **Option B: Manual Download**
   - After adding SHA-1, download the updated `google-services.json` from Firebase Console
   - Replace: `android/app/google-services.json` with the new file

## Step 4: Configure OAuth Consent Screen (Google Cloud Console)

### Important: Accessing Google Cloud Console

If the project `marg-af127` doesn't appear in Google Cloud Console:

1. **Use Direct URL** (Recommended):
   - Go directly to: https://console.cloud.google.com/home/dashboard?project=marg-af127
   - This will force-load the project even if it doesn't appear in the project list

2. **Or via Firebase Console:**
   - Go to: https://console.firebase.google.com/project/marg-af127/settings/general
   - Scroll to "Project management" section
   - Click "Open in Google Cloud Console"

3. **For detailed troubleshooting**, see: [GOOGLE_CLOUD_CONSOLE_ACCESS.md](./GOOGLE_CLOUD_CONSOLE_ACCESS.md)

### Configure OAuth Consent Screen:

1. **Open Google Cloud Console:**
   - Go to: https://console.cloud.google.com/apis/credentials/consent?project=marg-af127
   - Or use direct URL: https://console.cloud.google.com/home/dashboard?project=marg-af127
   - Then navigate to: **APIs & Services** → **OAuth consent screen**

2. **Navigate to OAuth Consent Screen:**
   - Go to **APIs & Services** → **OAuth consent screen**

3. **Configure OAuth Consent Screen:**
   - **User Type:** Select **External** (unless you have Google Workspace)
   - Click **Create**

4. **Fill in App Information:**
   - **App name:** Marg Trading App
   - **User support email:** Your email
   - **Developer contact information:** Your email
   - Click **Save and Continue**

5. **Scopes (Optional):**
   - Click **Add or Remove Scopes**
   - Ensure these are selected:
     - `.../auth/userinfo.email`
     - `.../auth/userinfo.profile`
   - Click **Update** → **Save and Continue**

6. **Test Users (For Testing):**
   - Add test users (your email addresses) if app is in testing mode
   - Click **Save and Continue**

7. **Summary:**
   - Review and click **Back to Dashboard**

## Step 5: Enable Google Sign-In API

1. **In Google Cloud Console:**
   - Go to **APIs & Services** → **Library**

2. **Search for "Google Sign-In API":**
   - Search: `Google Sign-In API`
   - Click on it and ensure it's **Enabled**

   **OR** search for:
   - `Google+ API` (if available)
   - `Identity Toolkit API` (should be enabled automatically)

## Step 6: iOS Configuration (Optional - if testing on iOS)

1. **In Firebase Console:**
   - Go to: https://console.firebase.google.com/project/marg-af127/settings/general
   - Find your iOS app: `com.varnarc.marg`

2. **Download GoogleService-Info.plist:**
   - Click on iOS app
   - Download `GoogleService-Info.plist`
   - Replace: `ios/Runner/GoogleService-Info.plist`

3. **Configure URL Scheme in Xcode:**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select **Runner** in project navigator
   - Go to **Info** tab
   - Under **URL Types**, add:
     - **Identifier:** `REVERSED_CLIENT_ID`
     - **URL Schemes:** (Get this from `GoogleService-Info.plist` → `REVERSED_CLIENT_ID`)

## Step 7: Verify Configuration

1. **Check Firebase Console:**
   - Authentication → Sign-in method → Google should be **Enabled**

2. **Test in Your App:**
   ```bash
   cd /Users/saiporala/Documents/sai/marg
   flutter pub get
   flutter run
   ```

3. **Try Google Sign-In:**
   - Tap "Continue with Google" button
   - Should open Google sign-in flow

## Troubleshooting

### Issue: "DEVELOPER_ERROR" on Android

**Solution:**
- Make sure SHA-1 fingerprint is added correctly in Firebase Console
- Download fresh `google-services.json` after adding SHA-1
- Clean and rebuild:
  ```bash
  cd android
  ./gradlew clean
  cd ..
  flutter clean
  flutter pub get
  flutter run
  ```

### Issue: "Sign in cancelled" 

**Solution:**
- Check OAuth consent screen is configured
- Ensure test users are added (if app is in testing mode)
- Verify Google Sign-In API is enabled

### Issue: "Network error" or "Connection failed"

**Solution:**
- Check internet connection
- Verify Firebase project is active
- Ensure `google-services.json` is in `android/app/` directory

### Issue: iOS - "No valid client ID"

**Solution:**
- Verify `GoogleService-Info.plist` is correct
- Check URL scheme is configured in Xcode
- Ensure bundle ID matches Firebase Console

## Quick Command Reference

```bash
# Get SHA-1 (Debug)
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Get SHA-1 (Gradle)
cd android && ./gradlew signingReport

# Clean and rebuild
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter run
```

## Firebase Console Links

- **Project Dashboard:** https://console.firebase.google.com/project/marg-af127
- **Authentication:** https://console.firebase.google.com/project/marg-af127/authentication
- **Project Settings:** https://console.firebase.google.com/project/marg-af127/settings/general
- **OAuth Consent Screen:** https://console.cloud.google.com/apis/credentials/consent?project=marg-af127

## Next Steps

After completing this setup:
1. Test Google Sign-In in your app
2. If everything works, you're done! ✅
3. For production, add release SHA-1 fingerprint
4. Publish OAuth consent screen when ready for production

---

**Note:** The SHA-1 fingerprint is required for Google Sign-In to work on Android. Make sure to add both debug and release SHA-1 fingerprints before publishing your app.
