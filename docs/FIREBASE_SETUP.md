# Firebase Setup Guide

This guide will help you set up Firebase Authentication for the Marg trading app.

## Prerequisites

1. A Firebase project (create one at [Firebase Console](https://console.firebase.google.com/))
2. FlutterFire CLI installed globally:
   ```bash
   dart pub global activate flutterfire_cli
   ```

## Setup Steps

### Option 1: Using FlutterFire CLI (Recommended)

1. **Login to Firebase:**
   ```bash
   flutterfire login
   ```

2. **Configure Firebase for your project:**
   ```bash
   cd /Users/saiporala/Documents/sai/marg
   flutterfire configure
   ```

3. **Select your Firebase project** from the list

4. **Select platforms** (iOS, Android, Web, etc.)

5. **The CLI will automatically:**
   - Generate `lib/firebase_options.dart`
   - Add configuration files to your project
   - Update your project files

### Option 2: Manual Setup

#### Android Setup

1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/google-services.json`
3. Update `android/build.gradle`:
   ```gradle
   buildscript {
       dependencies {
           classpath 'com.google.gms:google-services:4.4.0'
       }
   }
   ```
4. Update `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

#### iOS Setup

1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in `ios/Runner/GoogleService-Info.plist`
3. Add it to Xcode project (drag and drop in Xcode)

#### Web Setup

1. Add Firebase config to `web/index.html`:
   ```html
   <script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-app.js"></script>
   <script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-auth.js"></script>
   <script>
     const firebaseConfig = {
       apiKey: "YOUR_API_KEY",
       authDomain: "YOUR_AUTH_DOMAIN",
       projectId: "YOUR_PROJECT_ID",
       // ... other config
     };
     firebase.initializeApp(firebaseConfig);
   </script>
   ```

## Enable Authentication Methods

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Authentication** > **Sign-in method**
4. Enable the following providers:
   - **Phone** (for OTP authentication)
   - **Email/Password** (for email authentication)

### Phone Authentication Setup

1. Enable **Phone** sign-in method
2. For testing, add test phone numbers in Firebase Console
3. For production, configure reCAPTCHA (Android) or App Check (iOS)

## Update main.dart

If you used FlutterFire CLI, update `main.dart`:

```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(/* ... */);
}
```

## Testing

1. Run the app: `flutter run`
2. Try phone authentication with a test number
3. Check Firebase Console > Authentication to see registered users

## Troubleshooting

### "Firebase not initialized" error
- Make sure `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is in the correct location
- Run `flutter clean` and `flutter pub get`
- Rebuild the app

### Phone authentication not working
- Check if Phone authentication is enabled in Firebase Console
- Verify phone number format includes country code (+91XXXXXXXXXX)
- Check Firebase Console logs for errors

### Build errors
- Make sure all Firebase dependencies are up to date
- Run `flutter pub upgrade`
- Check that `firebase_options.dart` is generated correctly

## Security Rules

For production, set up proper security rules in Firebase Console:
- Authentication: Enable only required methods
- Firestore (if used): Set up proper read/write rules
- Storage (if used): Configure access rules

## Support

For more help, see:
- [Firebase Flutter Documentation](https://firebase.flutter.dev/)
- [Firebase Authentication Guide](https://firebase.google.com/docs/auth)
