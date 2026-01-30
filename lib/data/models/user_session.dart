/// User Session Model
/// Represents the authenticated user's session state
/// Includes Firebase auth state and trading permissions
class UserSession {
  final String firebaseUid;
  final bool isLoggedIn;
  final bool paperTradingEnabled;
  final bool realTradingEnabled;
  final KycStatus kycStatus;
  final bool deviceTrusted;
  final String? email;
  final String? phoneNumber;
  final bool mpinSet;
  final String? mpinHash; // Hashed MPIN (mock)

  UserSession({
    required this.firebaseUid,
    required this.isLoggedIn,
    required this.paperTradingEnabled,
    required this.realTradingEnabled,
    required this.kycStatus,
    required this.deviceTrusted,
    this.email,
    this.phoneNumber,
    this.mpinSet = false,
    this.mpinHash,
  });

  /// Create default session after Firebase login
  factory UserSession.afterLogin({
    required String firebaseUid,
    String? email,
    String? phoneNumber,
  }) {
    return UserSession(
      firebaseUid: firebaseUid,
      isLoggedIn: true,
      paperTradingEnabled: true, // Enabled by default
      realTradingEnabled: false, // Locked until KYC
      kycStatus: KycStatus.notStarted,
      deviceTrusted: true,
      email: email,
      phoneNumber: phoneNumber,
      mpinSet: false,
    );
  }

  /// Copy with method for immutable updates
  UserSession copyWith({
    String? firebaseUid,
    bool? isLoggedIn,
    bool? paperTradingEnabled,
    bool? realTradingEnabled,
    KycStatus? kycStatus,
    bool? deviceTrusted,
    String? email,
    String? phoneNumber,
    bool? mpinSet,
    String? mpinHash,
  }) {
    return UserSession(
      firebaseUid: firebaseUid ?? this.firebaseUid,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      paperTradingEnabled: paperTradingEnabled ?? this.paperTradingEnabled,
      realTradingEnabled: realTradingEnabled ?? this.realTradingEnabled,
      kycStatus: kycStatus ?? this.kycStatus,
      deviceTrusted: deviceTrusted ?? this.deviceTrusted,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      mpinSet: mpinSet ?? this.mpinSet,
      mpinHash: mpinHash ?? this.mpinHash,
    );
  }

  /// Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'firebase_uid': firebaseUid,
      'is_logged_in': isLoggedIn,
      'paper_trading_enabled': paperTradingEnabled,
      'real_trading_enabled': realTradingEnabled,
      'kyc_status': kycStatus.name,
      'device_trusted': deviceTrusted,
      'email': email,
      'phone_number': phoneNumber,
      'mpin_set': mpinSet,
      'mpin_hash': mpinHash,
    };
  }

  /// Create from JSON
  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      firebaseUid: json['firebase_uid'] as String? ?? '',
      isLoggedIn: json['is_logged_in'] as bool? ?? false,
      paperTradingEnabled: json['paper_trading_enabled'] as bool? ?? false,
      realTradingEnabled: json['real_trading_enabled'] as bool? ?? false,
      kycStatus: json['kyc_status'] != null
          ? KycStatus.values.firstWhere(
              (e) => e.name == json['kyc_status'],
              orElse: () => KycStatus.notStarted,
            )
          : KycStatus.notStarted,
      deviceTrusted: json['device_trusted'] as bool? ?? true,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      mpinSet: json['mpin_set'] as bool? ?? false,
      mpinHash: json['mpin_hash'] as String?,
    );
  }
}

/// KYC Status Enum
enum KycStatus {
  notStarted,
  panVerified,
  aadhaarVerified,
  bankVerified,
  completed,
}

extension KycStatusExtension on KycStatus {
  String get displayName {
    switch (this) {
      case KycStatus.notStarted:
        return 'Not Started';
      case KycStatus.panVerified:
        return 'PAN Verified';
      case KycStatus.aadhaarVerified:
        return 'Aadhaar Verified';
      case KycStatus.bankVerified:
        return 'Bank Verified';
      case KycStatus.completed:
        return 'KYC Completed';
    }
  }
}
