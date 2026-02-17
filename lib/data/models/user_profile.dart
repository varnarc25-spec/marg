/// User Profile Model
/// Represents the user's profile data from mock JSON
class UserProfile {
  final String userId;
  final String name;
  final String language; // 'en', 'hi', 'te', 'ta'
  final String experienceLevel; // 'beginner', 'intermediate', 'pro'
  final String riskProfile; // 'low', 'medium', 'high'
  final String accountMode; // 'paper', 'real'
  // Personal data (KYC / form)
  final String? dateOfBirth;
  final String? gender;
  final String? fatherName;
  final String? currentAddress;
  final String? permanentAddress;
  final String? nationality;

  UserProfile({
    required this.userId,
    required this.name,
    required this.language,
    required this.experienceLevel,
    required this.riskProfile,
    required this.accountMode,
    this.dateOfBirth,
    this.gender,
    this.fatherName,
    this.currentAddress,
    this.permanentAddress,
    this.nationality,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      language: json['language'] as String,
      experienceLevel: json['experience_level'] as String,
      riskProfile: json['risk_profile'] as String,
      accountMode: json['account_mode'] as String,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String?,
      fatherName: json['father_name'] as String?,
      currentAddress: json['current_address'] as String?,
      permanentAddress: json['permanent_address'] as String?,
      nationality: json['nationality'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'language': language,
      'experience_level': experienceLevel,
      'risk_profile': riskProfile,
      'account_mode': accountMode,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'father_name': fatherName,
      'current_address': currentAddress,
      'permanent_address': permanentAddress,
      'nationality': nationality,
    };
  }

  UserProfile copyWith({
    String? userId,
    String? name,
    String? language,
    String? experienceLevel,
    String? riskProfile,
    String? accountMode,
    String? dateOfBirth,
    String? gender,
    String? fatherName,
    String? currentAddress,
    String? permanentAddress,
    String? nationality,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      language: language ?? this.language,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      riskProfile: riskProfile ?? this.riskProfile,
      accountMode: accountMode ?? this.accountMode,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      fatherName: fatherName ?? this.fatherName,
      currentAddress: currentAddress ?? this.currentAddress,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      nationality: nationality ?? this.nationality,
    );
  }
}
