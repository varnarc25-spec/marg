/// Personal data from API (GET/PUT /api/user/personal-data).
class PersonalData {
  final String? fullName;
  final String? dateOfBirth;
  final String? gender;
  final String? fatherName;
  final String? mobileNumber;
  final String? email;
  final String? currentAddress;
  final String? permanentAddress;
  final String? nationality;

  const PersonalData({
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.fatherName,
    this.mobileNumber,
    this.email,
    this.currentAddress,
    this.permanentAddress,
    this.nationality,
  });

  factory PersonalData.fromJson(Map<String, dynamic> json) {
    return PersonalData(
      fullName: json['fullName'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      fatherName: json['fatherName'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      email: json['email'] as String?,
      currentAddress: json['currentAddress'] as String?,
      permanentAddress: json['permanentAddress'] as String?,
      nationality: json['nationality'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) 'fullName': fullName,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (gender != null) 'gender': gender,
      if (fatherName != null) 'fatherName': fatherName,
      if (mobileNumber != null) 'mobileNumber': mobileNumber,
      if (email != null) 'email': email,
      if (currentAddress != null) 'currentAddress': currentAddress,
      if (permanentAddress != null) 'permanentAddress': permanentAddress,
      if (nationality != null) 'nationality': nationality,
    };
  }

  PersonalData copyWith({
    String? fullName,
    String? dateOfBirth,
    String? gender,
    String? fatherName,
    String? mobileNumber,
    String? email,
    String? currentAddress,
    String? permanentAddress,
    String? nationality,
  }) {
    return PersonalData(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      fatherName: fatherName ?? this.fatherName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      currentAddress: currentAddress ?? this.currentAddress,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      nationality: nationality ?? this.nationality,
    );
  }
}
