/// Response from `GET /api/insurance/health/pincode/{pincode}`.
class HealthPincodeResult {
  const HealthPincodeResult({
    required this.isValid,
    this.city,
    this.state,
    this.message,
  });

  factory HealthPincodeResult.valid({String? city, String? state}) {
    return HealthPincodeResult(isValid: true, city: city, state: state);
  }

  factory HealthPincodeResult.invalid([String? message]) {
    return HealthPincodeResult(isValid: false, message: message);
  }

  factory HealthPincodeResult.fromJson(Map<String, dynamic> json) {
    final validRaw = json['valid'] ?? json['isValid'] ?? json['success'];
    // If backend omits a boolean, assume serviceable (avoid blocking quote).
    final isValid = validRaw == null
        ? true
        : validRaw == true ||
            validRaw == 'true' ||
            validRaw == 1 ||
            json['status']?.toString().toLowerCase() == 'valid';

    return HealthPincodeResult(
      isValid: isValid,
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      message: json['message']?.toString() ?? json['error']?.toString(),
    );
  }

  final bool isValid;
  final String? city;
  final String? state;
  final String? message;
}
