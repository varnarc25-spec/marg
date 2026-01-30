import 'dart:math';

/// Mock Firebase Auth Service
/// Simulates Firebase Authentication without actual backend calls
/// All operations are mocked with delays to simulate network calls
class MockFirebaseAuthService {
  static final MockFirebaseAuthService _instance = MockFirebaseAuthService._internal();
  factory MockFirebaseAuthService() => _instance;
  MockFirebaseAuthService._internal();

  // Mock session storage
  String? _currentUserId;
  String? _currentEmail;
  String? _currentPhoneNumber;
  bool _isLoggedIn = false;

  // Mock OTP storage
  final Map<String, String> _otpStore = {}; // phone -> otp
  final Map<String, String> _emailOtpStore = {}; // email -> otp

  /// Generate mock Firebase UID
  String _generateMockUid() {
    return 'mock_uid_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  /// Generate 6-digit OTP
  String _generateOTP() {
    return (100000 + Random().nextInt(900000)).toString();
  }

  /// Send OTP to phone (mocked)
  /// Returns verification ID (mocked)
  Future<String> sendPhoneOTP(String phoneNumber) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate and store OTP
    final otp = _generateOTP();
    _otpStore[phoneNumber] = otp;

    // In real app, this would be the verification ID from Firebase
    final verificationId = 'mock_verification_id_${DateTime.now().millisecondsSinceEpoch}';

    // Log OTP for testing (in production, this would be sent via SMS)
    print('📱 Mock OTP for $phoneNumber: $otp');

    return verificationId;
  }

  /// Verify phone OTP (mocked)
  Future<Map<String, dynamic>> verifyPhoneOTP({
    required String phoneNumber,
    required String otp,
    required String verificationId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if OTP matches
    final storedOtp = _otpStore[phoneNumber];
    if (storedOtp == null || storedOtp != otp) {
      throw Exception('Invalid OTP. Please try again.');
    }

    // Clear OTP after successful verification
    _otpStore.remove(phoneNumber);

    // Create mock user session
    final uid = _generateMockUid();
    _currentUserId = uid;
    _currentPhoneNumber = phoneNumber;
    _isLoggedIn = true;

    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'email': null,
    };
  }

  /// Send OTP to email (mocked)
  Future<String> sendEmailOTP(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate and store OTP
    final otp = _generateOTP();
    _emailOtpStore[email] = otp;

    // In real app, this would be the verification ID from Firebase
    final verificationId = 'mock_verification_id_${DateTime.now().millisecondsSinceEpoch}';

    // Log OTP for testing (in production, this would be sent via email)
    print('📧 Mock OTP for $email: $otp');

    return verificationId;
  }

  /// Verify email OTP (mocked)
  Future<Map<String, dynamic>> verifyEmailOTP({
    required String email,
    required String otp,
    required String verificationId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if OTP matches
    final storedOtp = _emailOtpStore[email];
    if (storedOtp == null || storedOtp != otp) {
      throw Exception('Invalid OTP. Please try again.');
    }

    // Clear OTP after successful verification
    _emailOtpStore.remove(email);

    // Create mock user session
    final uid = _generateMockUid();
    _currentUserId = uid;
    _currentEmail = email;
    _isLoggedIn = true;

    return {
      'uid': uid,
      'email': email,
      'phoneNumber': null,
    };
  }

  /// Sign in with email and password (mocked)
  Future<Map<String, dynamic>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation (accept any email/password for demo)
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    // Create mock user session
    final uid = _generateMockUid();
    _currentUserId = uid;
    _currentEmail = email;
    _isLoggedIn = true;

    return {
      'uid': uid,
      'email': email,
      'phoneNumber': null,
    };
  }

  /// Sign up with email and password (mocked)
  Future<Map<String, dynamic>> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Create mock user session
    final uid = _generateMockUid();
    _currentUserId = uid;
    _currentEmail = email;
    _isLoggedIn = true;

    return {
      'uid': uid,
      'email': email,
      'phoneNumber': null,
    };
  }

  /// Get current user
  Map<String, dynamic>? getCurrentUser() {
    if (!_isLoggedIn || _currentUserId == null) {
      return null;
    }

    return {
      'uid': _currentUserId,
      'email': _currentEmail,
      'phoneNumber': _currentPhoneNumber,
    };
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _isLoggedIn;
  }

  /// Sign out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUserId = null;
    _currentEmail = null;
    _currentPhoneNumber = null;
    _isLoggedIn = false;
  }

  /// Get auth state stream (mocked)
  Stream<Map<String, dynamic>?> authStateChanges() {
    // Return a stream that emits current user
    return Stream.value(getCurrentUser());
  }
}
