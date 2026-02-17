// Stub for web: ML Kit has no web implementation.

/// Result of parsing a PAN or Aadhaar card image.
class ExtractedIdData {
  final String? fullName;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? panNumber;
  final String? aadhaarNumber;
  final String? rawText;

  const ExtractedIdData({
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.panNumber,
    this.aadhaarNumber,
    this.rawText,
  });

  /// From API response map (e.g. marg_api POST /api/ocr/id-card).
  factory ExtractedIdData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ExtractedIdData();
    return ExtractedIdData(
      fullName: json['fullName'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      panNumber: json['panNumber'] as String?,
      aadhaarNumber: json['aadhaarNumber'] as String?,
      rawText: json['rawText'] as String?,
    );
  }
}

/// No-op OCR service on web. Use Android/iOS app for ID card scanning.
class IdCardOcrService {
  void close() {}

  Future<ExtractedIdData?> extractFromFile(Object? file) async => null;
}
