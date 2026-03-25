import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart'
show debugPrint, kDebugMode, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart' show TargetPlatform;
import '../../firebase_options.dart';

class FirebaseAuthService {
  FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;

  FirebaseAuthService() {
    _initializeAuth();
    // Prevent web startup crash when the `google-signin-client_id` meta tag
    // is not configured yet. Google sign-in will still be available after
    // fixing web configuration.
    if (!kIsWeb) _initializeGoogleSignIn();
  }

  // ---------------------------------------------------------------------------
  // Lazy getters — retry if the first constructor-time attempt failed
  // (handles web race conditions where FirebaseAuth.instance may not be ready).
  // ---------------------------------------------------------------------------

  FirebaseAuth? get _firebaseAuth {
    if (_auth != null) return _auth;
    _initializeAuth();
    return _auth;
  }

  GoogleSignIn get _gsi {
    if (_googleSignIn != null) return _googleSignIn!;
    _initializeGoogleSignIn();
    return _googleSignIn!;
  }

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  void _initializeAuth() {
    try {
      if (Firebase.apps.isEmpty) {
        debugPrint('⚠️ FirebaseAuthService: Firebase.apps is empty');
        return;
      }
      _auth = FirebaseAuth.instance;
    } catch (e) {
      debugPrint('❌ FirebaseAuthService: FirebaseAuth.instance threw: $e');
    }
  }

  void _initializeGoogleSignIn() {
    try {
      String? clientId;
      if (!kIsWeb) {
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          clientId = DefaultFirebaseOptions.ios.iosClientId;
        } else if (defaultTargetPlatform == TargetPlatform.macOS) {
          clientId = DefaultFirebaseOptions.macos.iosClientId;
        }
      }
      _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId: clientId,
      );
    } catch (e) {
      debugPrint('⚠️ Could not configure GoogleSignIn: $e');
      _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _requireAuth() {
    if (_firebaseAuth == null) {
      throw Exception(
        'Firebase Auth is not available. '
        'Run "flutterfire configure" and restart the app.',
      );
    }
  }

  User? getCurrentUser() {
    try {
      return _firebaseAuth?.currentUser;
    } catch (_) {
      return null;
    }
  }

  bool isLoggedIn() {
    try {
      return _firebaseAuth?.currentUser != null;
    } catch (_) {
      return false;
    }
  }

  Stream<User?> authStateChanges() {
    if (_firebaseAuth == null) return Stream.value(null);
    return _firebaseAuth!.authStateChanges();
  }

  // ---------------------------------------------------------------------------
  // Phone Auth
  // ---------------------------------------------------------------------------

  Future<String> sendPhoneOTP(String phoneNumber) async {
    _requireAuth();
    if (!phoneNumber.startsWith('+')) {
      throw Exception(
          'Phone number must include country code (e.g., +91XXXXXXXXXX)');
    }
    throw Exception(
        'Use sendPhoneOTPWithCallback for phone verification.');
  }

  Future<String> sendPhoneOTPWithCallback(
    String phoneNumber,
    Function(String verificationId) onCodeSent,
  ) async {
    _requireAuth();
    if (!phoneNumber.startsWith('+')) {
      throw Exception(
          'Phone number must include country code (e.g., +91XXXXXXXXXX)');
    }

    try {
      final completer = Completer<String>();

      await _firebaseAuth!.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _firebaseAuth!.signInWithCredential(credential);
            completer.complete(credential.verificationId ?? '');
          } catch (e) {
            completer.completeError(e);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.completeError(Exception(_getErrorMessage(e)));
        },
        codeSent: (String vid, int? resendToken) {
          onCodeSent(vid);
          completer.complete(vid);
        },
        codeAutoRetrievalTimeout: (_) {},
      );

      return completer.future;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('recaptcha') ||
          msg.contains('argumenterror') ||
          msg.contains('recaptchaverifier')) {
        throw Exception(
          'Phone verification could not start. '
          'On web, ensure you allow the security check. '
          'You can also try Email sign-in.',
        );
      }
      throw Exception(
          'Could not send OTP. Please try again or use Email sign-in.');
    }
  }

  Future<Map<String, dynamic>> verifyPhoneOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    _requireAuth();
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final uc = await _firebaseAuth!.signInWithCredential(credential);
      if (uc.user == null) throw Exception('Authentication failed');
      return {
        'uid': uc.user!.uid,
        'phoneNumber': uc.user!.phoneNumber,
        'email': uc.user!.email,
      };
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // ---------------------------------------------------------------------------
  // Email / Password Auth
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _requireAuth();
    try {
      final uc = await _firebaseAuth!.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (uc.user == null) throw Exception('Authentication failed');
      return {
        'uid': uc.user!.uid,
        'email': uc.user!.email,
        'phoneNumber': uc.user!.phoneNumber,
      };
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<Map<String, dynamic>> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _requireAuth();
    try {
      final uc = await _firebaseAuth!.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (uc.user == null) throw Exception('Registration failed');
      return {
        'uid': uc.user!.uid,
        'email': uc.user!.email,
        'phoneNumber': uc.user!.phoneNumber,
      };
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // ---------------------------------------------------------------------------
  // Google Sign-In
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> signInWithGoogle() async {
    _requireAuth();

    try {
      late final UserCredential userCredential;

      if (kIsWeb) {
        final provider = GoogleAuthProvider()
          ..addScope('email')
          ..addScope('profile');
        userCredential = await _firebaseAuth!.signInWithPopup(provider);
      } else {
        if (_googleSignIn == null) {
          _initializeGoogleSignIn();
        }
        final googleUser = await _gsi.signIn();
        if (googleUser == null) {
          throw Exception('Google Sign-In was cancelled');
        }

        final googleAuth = await googleUser.authentication;
        if (googleAuth.idToken == null) {
          throw Exception(
            'Google Sign-In failed: no ID token received. '
            'Check Firebase Console > Authentication > Google provider.',
          );
        }

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential =
            await _firebaseAuth!.signInWithCredential(credential);
      }

      final user = userCredential.user;
      if (user == null) throw Exception('Authentication failed');

      return {
        'uid': user.uid,
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'displayName': user.displayName,
      };
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Auth Exception: ${e.code} - ${e.message}');
      throw Exception(_getErrorMessage(e));
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Google Sign-In error: $e');
        debugPrint('Stack: $stackTrace');
      }

      final msg = e.toString();
      if (msg.contains('popup_closed') ||
          msg.contains('cancelled') ||
          msg.contains('canceled')) {
        throw Exception('Google Sign-In was cancelled');
      }
      throw Exception('Failed to sign in with Google: $msg');
    }
  }

  // ---------------------------------------------------------------------------
  // Email verification
  // ---------------------------------------------------------------------------

  Future<void> sendEmailVerification() async {
    _requireAuth();
    try {
      final user = _firebaseAuth!.currentUser;
      if (user == null) throw Exception('No user is currently signed in');
      if (user.email == null) {
        throw Exception('User does not have an email address');
      }
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // ---------------------------------------------------------------------------
  // Sign out
  // ---------------------------------------------------------------------------

  Future<void> signOut() async {
    try {
      if (_auth != null) {
        await _auth!.signOut();
      }
      if (_googleSignIn != null) {
        await _googleSignIn!.signOut();
      }
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  /// Get user ID token. Use [forceRefresh] when calling protected APIs after idle.
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final auth = _firebaseAuth;
    if (auth == null) return null;
    try {
      final user = auth.currentUser;
      if (user == null) return null;
      return await user.getIdToken(forceRefresh);
    } catch (e) {
      return null;
    }
  }

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
        return 'This sign-in method is not enabled. '
            'Enable it in Firebase Console > Authentication > Sign-in method.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'invalid-phone-number':
        return 'Invalid phone number. Use a valid 10-digit number with country code.';
      case 'captcha-check-failed':
        return 'Verification check failed. Please try again.';
      case 'missing-client-identifier':
        return 'Phone auth is not set up for this app. Check Firebase configuration.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Try again later or use Email sign-in.';
      case 'app-deleted':
      case 'invalid-app-credential':
        return 'App configuration error. Run: flutterfire configure';
      default:
        return e.message ?? 'An error occurred during authentication.';
    }
  }
}
