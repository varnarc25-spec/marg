/// User Profile Model
/// Represents the user's profile data from mock JSON
class UserProfile {
  final String userId;
  final String name;
  final String language; // 'en', 'hi', 'te', 'ta'
  final String experienceLevel; // 'beginner', 'intermediate', 'pro'
  final String riskProfile; // 'low', 'medium', 'high'
  final String accountMode; // 'paper', 'real'

  UserProfile({
    required this.userId,
    required this.name,
    required this.language,
    required this.experienceLevel,
    required this.riskProfile,
    required this.accountMode,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      language: json['language'] as String,
      experienceLevel: json['experience_level'] as String,
      riskProfile: json['risk_profile'] as String,
      accountMode: json['account_mode'] as String,
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
    };
  }

  UserProfile copyWith({
    String? userId,
    String? name,
    String? language,
    String? experienceLevel,
    String? riskProfile,
    String? accountMode,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      language: language ?? this.language,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      riskProfile: riskProfile ?? this.riskProfile,
      accountMode: accountMode ?? this.accountMode,
    );
  }
}
