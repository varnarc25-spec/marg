/// Mock KYC Service
/// Handles KYC verification flows (PAN, Aadhaar, Bank)
/// All validations are mocked for UI demonstration
class MockKycService {
  static final MockKycService _instance = MockKycService._internal();
  factory MockKycService() => _instance;
  MockKycService._internal();

  /// Verify PAN number (mocked)
  /// PAN format: ABCDE1234F (5 letters, 4 digits, 1 letter)
  Future<bool> verifyPAN(String panNumber) async {
    await Future.delayed(const Duration(seconds: 2));

    // Mock validation
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(panNumber.toUpperCase())) {
      throw Exception('Invalid PAN format. Please enter a valid PAN number.');
    }

    // Mock successful verification
    return true;
  }

  /// Verify Aadhaar number (mocked)
  /// Aadhaar format: 12 digits
  Future<String> sendAadhaarOTP(String aadhaarNumber) async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    final aadhaarRegex = RegExp(r'^\d{12}$');
    if (!aadhaarRegex.hasMatch(aadhaarNumber)) {
      throw Exception('Invalid Aadhaar format. Please enter 12-digit Aadhaar number.');
    }

    // Generate mock OTP
    final otp = (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
    print('🆔 Mock Aadhaar OTP: $otp');

    return otp;
  }

  /// Verify Aadhaar OTP (mocked)
  Future<bool> verifyAadhaarOTP(String aadhaarNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation (accept any 6-digit OTP for demo)
    if (otp.length != 6) {
      throw Exception('Invalid OTP format');
    }

    // Mock successful verification
    return true;
  }

  /// Verify bank account (mocked penny drop)
  /// Validates account number and IFSC, then performs mock penny drop
  Future<bool> verifyBankAccount({
    required String accountNumber,
    required String ifscCode,
  }) async {
    await Future.delayed(const Duration(seconds: 3));

    // Mock validation
    if (accountNumber.isEmpty || accountNumber.length < 9) {
      throw Exception('Invalid account number');
    }

    final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (!ifscRegex.hasMatch(ifscCode.toUpperCase())) {
      throw Exception('Invalid IFSC code format');
    }

    // Mock successful penny drop verification
    return true;
  }
}
