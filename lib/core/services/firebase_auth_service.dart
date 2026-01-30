import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode, defaultTargetPlatform;
import 'package:flutter/material.dart' show TargetPlatform;
import '../../firebase_options.dart';

/// Real Firebase Auth Service
/// Handles authentication using Firebase Authentication
class FirebaseAuthService {
  FirebaseAuth? _auth;
  late final GoogleSignIn _googleSignIn;

  FirebaseAuthService() {
    _initializeAuth();
    _initializeGoogleSignIn();
  }

  void _initializeGoogleSignIn() {
    try {
      // Configure GoogleSignIn with client ID from firebase_options if available
      String? clientId;
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        clientId = DefaultFirebaseOptions.ios.iosClientId;
      } else if (defaultTargetPlatform == TargetPlatform.macOS) {
        clientId = DefaultFirebaseOptions.macos.iosClientId;
      }
      // For Android, client ID is usually in google-services.json
      // GoogleSignIn will use it automatically, so we don't need to set it

      if (clientId != null) {
        _googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
          clientId: clientId,
        );
      } else {
        _googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
        );
      }
    } catch (e) {
      // Fallback to default initialization if configuration fails
      debugPrint('⚠️ Could not configure GoogleSignIn with client ID: $e');
      _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
    }
  }

  void _initializeAuth() {
    try {
      // Check if Firebase is initialized before accessing FirebaseAuth
      if (Firebase.apps.isEmpty) {
        return; // Firebase not initialized, _auth will remain null
      }
      _auth = FirebaseAuth.instance;
    } catch (e) {
      // If FirebaseAuth.instance throws an error, _auth will remain null
      // This is expected if Firebase is not properly initialized
    }
  }

  /// Get current user
  User? getCurrentUser() {
    if (_auth == null) return null;
    try {
      return _auth!.currentUser;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    if (_auth == null) return false;
    try {
      return _auth!.currentUser != null;
    } catch (e) {
      // If Firebase isn't initialized or there's an error, return false
      return false;
    }
  }

  /// Send OTP to phone number
  /// Returns verification ID for OTP verification
  Future<String> sendPhoneOTP(String phoneNumber) async {
    if (_auth == null) {
      throw Exception(
        'Firebase is not initialized. Please configure Firebase first.\n\n'
        'To fix this:\n'
        '1. Run: flutterfire configure\n'
        '2. Or add GoogleService-Info.plist (iOS) and google-services.json (Android)',
      );
    }
    try {
      // Verify phone number format (should include country code)
      if (!phoneNumber.startsWith('+')) {
        throw Exception('Phone number must include country code (e.g., +91XXXXXXXXXX)');
      }

      // Send verification code
      final confirmationResult = await _auth!.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-verification completed (Android only)
          // This is handled automatically by Firebase
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception(_getErrorMessage(e));
        },
        codeSent: (String verificationId, int? resendToken) {
          // Code sent successfully - verificationId is returned via Future
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout
        },
      );

      // Wait for code to be sent and return verification ID
      // Note: In real implementation, we need to handle this differently
      // For now, we'll use a completer pattern or return the verification ID
      // from the codeSent callback
      throw Exception('Phone verification requires callback handling. Use verifyPhoneNumberWithCallback instead.');
    } catch (e) {
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  /// Send OTP to phone number with callback
  /// Returns verification ID via callback
  Future<String> sendPhoneOTPWithCallback(
    String phoneNumber,
    Function(String verificationId) onCodeSent,
  ) async {
    if (_auth == null) {
      throw Exception(
        'Firebase is not initialized. Please configure Firebase first.\n\n'
        'To fix this:\n'
        '1. Run: flutterfire configure\n'
        '2. Or add GoogleService-Info.plist (iOS) and google-services.json (Android)',
      );
    }
    try {
      if (!phoneNumber.startsWith('+')) {
        throw Exception('Phone number must include country code (e.g., +91XXXXXXXXXX)');
      }

      String? verificationId;
      final completer = Completer<String>();

      await _auth!.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed (Android only)
          try {
            await _auth!.signInWithCredential(credential);
            completer.complete(credential.verificationId ?? '');
          } catch (e) {
            completer.completeError(e);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.completeError(Exception(_getErrorMessage(e)));
        },
        codeSent: (String vid, int? resendToken) {
          verificationId = vid;
          onCodeSent(vid);
          completer.complete(vid);
        },
        codeAutoRetrievalTimeout: (String vid) {
          verificationId = vid;
        },
      );

      return completer.future;
    } catch (e) {
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  /// Verify phone OTP
  Future<Map<String, dynamic>> verifyPhoneOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    if (_auth == null) {
      throw Exception(
        'Firebase is not initialized. Please configure Firebase first.\n\n'
        'To fix this:\n'
        '1. Run: flutterfire configure\n'
        '2. Or add GoogleService-Info.plist (iOS) and google-services.json (Android)',
      );
    }
    try {
      // Create phone auth credential
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Sign in with credential
      final userCredential = await _auth!.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('Authentication failed: No user returned');
      }

      return {
        'uid': userCredential.user!.uid,
        'phoneNumber': userCredential.user!.phoneNumber,
        'email': userCredential.user!.email,
      };
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    } catch (e) {
      throw Exception('Failed to verify OTP: ${e.toString()}');
    }
  }

  /// Sign in with email and password
  Future<Map<String, dynamic>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (_auth == null) {
      throw Exception(
        'Firebase is not initialized. Please configure Firebase first.\n\n'
        'To fix this:\n'
        '1. Run: flutterfire configure\n'
        '2. Or add GoogleService-Info.plist (iOS) and google-services.json (Android)',
      );
    }
    try {
      final userCredential = await _auth!.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Authentication failed: No user returned');
      }

      return {
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'phoneNumber': userCredential.user!.phoneNumber,
      };
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  /// Sign up with email and password
  Future<Map<String, dynamic>> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (_auth == null) {
      throw Exception(
        'Firebase is not initialized. Please configure Firebase first.\n\n'
        'To fix this:\n'
        '1. Run: flutterfire configure\n'
        '2. Or add GoogleService-Info.plist (iOS) and google-services.json (Android)',
      );
    }
    try {
      final userCredential = await _auth!.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Registration failed: No user returned');
      }

      return {
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'phoneNumber': userCredential.user!.phoneNumber,
      };
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    } catch (e) {
      throw Exception('Failed to sign up: ${e.toString()}');
    }
  }

  /// Sign in with Google
  Future<Map<String, dynamic>> signInWithGoogle() async {
    // Check if Firebase is initialized
    if (_auth == null || Firebase.apps.isEmpty) {
      throw Exception(
        'Firebase is not initialized. Please configure Firebase first.\n\n'
        'To fix this:\n'
        '1. Run: flutterfire configure\n'
        '2. Or add GoogleService-Info.plist (iOS) and google-services.json (Android)',
      );
    }

    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google Sign-In was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Validate that we have the required tokens
      if (googleAuth.idToken == null && googleAuth.accessToken == null) {
        throw Exception(
          'Google Sign-In failed: No authentication tokens received.\n\n'
          'This may be due to:\n'
          '1. Missing Google Sign-In configuration\n'
          '2. Incorrect OAuth client ID setup\n'
          '3. Network connectivity issues\n\n'
          'Please check your Firebase console and ensure Google Sign-In is properly configured.',
        );
      }

      // idToken is required for Firebase Auth
      if (googleAuth.idToken == null) {
        throw Exception(
          'Google Sign-In failed: ID token is missing.\n\n'
          'This usually means the OAuth client ID is not properly configured.\n\n'
          'To fix:\n'
          '1. Check Firebase Console > Authentication > Sign-in method > Google\n'
          '2. Ensure the OAuth client ID matches your app configuration\n'
          '3. Run: flutterfire configure\n'
          '4. Restart the app',
        );
      }

      // Create a new credential
      // Note: idToken is required for Firebase Auth, accessToken is optional
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth!.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('Authentication failed: No user returned');
      }

      return {
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'phoneNumber': userCredential.user!.phoneNumber,
      };
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Auth Exception: ${e.code} - ${e.message}');
      throw Exception(_getErrorMessage(e));
    } catch (e, stackTrace) {
      debugPrint('❌ Google Sign-In error: $e');
      if (kDebugMode) {
        debugPrint('Stack trace: $stackTrace');
      }
      
      // Check if it's an assertion error
      if (e.toString().contains('assertion') || 
          e.toString().contains('AssertionError')) {
        throw Exception(
          'Google Sign-In configuration error.\n\n'
          'This usually means:\n'
          '1. Missing or incorrect OAuth client ID configuration\n'
          '2. Google Sign-In not enabled in Firebase Console\n'
          '3. Missing configuration files (GoogleService-Info.plist or google-services.json)\n\n'
          'To fix:\n'
          '1. Ensure Google Sign-In is enabled in Firebase Console\n'
          '2. Run: flutterfire configure\n'
          '3. Restart the app',
        );
      }
      
      // Check if it's a Firebase initialization error
      if (e.toString().contains('no firebase app') || 
          e.toString().contains('Firebase is not initialized')) {
        throw Exception(
          'Firebase is not configured. Please set up Firebase first.\n\n'
          'Quick fix:\n'
          '1. Run: flutterfire configure\n'
          '2. Restart the app',
        );
      }
      
      throw Exception('Failed to sign in with Google: ${e.toString()}');
    }
  }

  /// Send email verification link
  Future<void> sendEmailVerification() async {
    if (_auth == null) {
      throw Exception(
        'Firebase is not initialized. Please configure Firebase first.\n\n'
        'To fix this:\n'
        '1. Run: flutterfire configure\n'
        '2. Or add GoogleService-Info.plist (iOS) and google-services.json (Android)',
      );
    }
    try {
      final user = _auth!.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      if (user.email == null) {
        throw Exception('User does not have an email address');
      }

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    } catch (e) {
      throw Exception('Failed to send verification email: ${e.toString()}');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      if (_auth != null) {
        await _auth!.signOut();
      }
      await _googleSignIn.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  /// Get auth state changes stream
  Stream<User?> authStateChanges() {
    if (_auth == null) {
      return Stream.value(null);
    }
    return _auth!.authStateChanges();
  }

  /// Get user ID token
  Future<String?> getIdToken() async {
    if (_auth == null) return null;
    try {
      final user = _auth!.currentUser;
      if (user == null) return null;
      return await user.getIdToken();
    } catch (e) {
      return null;
    }
  }

  /// Get error message from Firebase Auth Exception
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'invalid-verification-code':
        return 'Invalid verification code.';
      case 'invalid-verification-id':
        return 'Invalid verification ID.';
      case 'session-expired':
        return 'The SMS code has expired. Please request a new one.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return e.message ?? 'An error occurred during authentication.';
    }
  }
}
