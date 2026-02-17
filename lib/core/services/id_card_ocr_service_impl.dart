import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

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

/// Runs OCR on an image file (Android/iOS only). Use stub on web.
class IdCardOcrService {
  final TextRecognizer _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  void close() {
    _recognizer.close();
  }

  Future<ExtractedIdData?> extractFromImage(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) return null;

    final inputImage = InputImage.fromFilePath(imagePath);
    RecognizedText recognized;
    try {
      recognized = await _recognizer.processImage(inputImage);
    } catch (e) {
      rethrow;
    }

    final String fullText = recognized.text.trim();
    if (fullText.isEmpty) return null;

    return _parseRecognizedText(fullText);
  }

  Future<ExtractedIdData?> extractFromFile(File file) async {
    return extractFromImage(file.path);
  }

  ExtractedIdData? _parseRecognizedText(String text) {
    final lines = text
        .split(RegExp(r'\n'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (lines.isEmpty) return null;

    final dobMatch = RegExp(
      r'(0?[1-9]|[12][0-9]|3[01])[-/](0?[1-9]|1[0-2])[-/](19|20)\d{2}',
    ).firstMatch(text);
    String? dateOfBirth;
    if (dobMatch != null) {
      final d = dobMatch.group(1)!;
      final m = dobMatch.group(2)!;
      final y = dobMatch.group(3)!;
      dateOfBirth = '$y-${m.padLeft(2, '0')}-${d.padLeft(2, '0')}';
    }

    final panMatch = RegExp(r'[A-Z]{5}[0-9]{4}[A-Z]').firstMatch(text);
    final String? panNumber = panMatch?.group(0);

    final aadhaarMatch = RegExp(r'\d{4}\s?\d{4}\s?\d{4}').firstMatch(text);
    final String? aadhaarNumber = aadhaarMatch?.group(0)?.replaceAll(' ', '');

    String? fullName;
    String? gender;
    String? address;

    if (panNumber != null) {
      fullName = _extractNameFromPanLines(lines, text);
    }

    if (aadhaarNumber != null) {
      final aadhaar = _parseAadhaarLines(lines, text);
      fullName = fullName ?? aadhaar.name;
      gender = aadhaar.gender;
      address = aadhaar.address;
    }

    if (fullName == null && dateOfBirth == null && gender == null && address == null && panNumber == null && aadhaarNumber == null) {
      return null;
    }

    return ExtractedIdData(
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: address,
      panNumber: panNumber,
      aadhaarNumber: aadhaarNumber,
      rawText: text,
    );
  }

  static const _panHeaders = [
    'income tax',
    'government of india',
    'govt of india',
    'permanent account number',
    'pan',
    'account number',
    'signature',
    'father',
    'father\'s name',
    'date of birth',
    'dob',
  ];

  String? _extractNameFromPanLines(List<String> lines, String fullText) {
    String? best;
    for (final line in lines) {
      final t = line.trim();
      if (t.length < 3) continue;
      final lower = t.toLowerCase();
      if (_panHeaders.any((h) => lower.contains(h))) continue;
      if (RegExp(r'^[A-Z\s]+$').hasMatch(t) && t.length >= 4 && t.length <= 80) {
        if (best == null || t.length > best.length) best = t;
      }
    }
    return best;
  }

  _AadhaarParsed _parseAadhaarLines(List<String> lines, String fullText) {
    String? name;
    String? gender;
    final addressLines = <String>[];

    final dobPattern = RegExp(r'(0?[1-9]|[12][0-9]|3[01])[-/](0?[1-9]|1[0-2])[-/](19|20)\d{2}');
    final aadhaarPattern = RegExp(r'\d{4}\s?\d{4}\s?\d{4}');
    final genderPattern = RegExp(r'\b(Male|Female|M|F|MALE|FEMALE)\b', caseSensitive: false);

    const skipWords = ['government', 'india', 'unique', 'identification', 'authority', 'uidai', 'aadhaar', 'your', 'number'];

    bool passedDob = false;
    bool seenAadhaar = false;

    for (final line in lines) {
      final t = line.trim();
      if (t.isEmpty) continue;

      if (aadhaarPattern.hasMatch(t)) seenAadhaar = true;
      if (dobPattern.hasMatch(t)) passedDob = true;

      if (skipWords.any((w) => t.toLowerCase().contains(w))) continue;

      if (gender == null && genderPattern.hasMatch(t)) {
        final m = genderPattern.firstMatch(t);
        if (m != null) {
          final g = m.group(1)!.toLowerCase();
          if (g == 'm' || g == 'male') gender = 'Male';
          else if (g == 'f' || g == 'female') gender = 'Female';
        }
      }

      if (passedDob && !seenAadhaar && addressLines.length < 8) {
        if (!dobPattern.hasMatch(t) && !RegExp(r'^\d{4}\s?\d{4}\s?\d{4}$').hasMatch(t)) {
          addressLines.add(t);
        }
      }

      if (!passedDob && name == null && t.length >= 3 && t.length <= 80) {
        if (!dobPattern.hasMatch(t) && !RegExp(r'^[\d\s/-]+$').hasMatch(t)) {
          name = t;
        }
      }
    }

    return _AadhaarParsed(
      name: name,
      gender: gender,
      address: addressLines.isEmpty ? null : addressLines.join(', '),
    );
  }
}

class _AadhaarParsed {
  final String? name;
  final String? gender;
  final String? address;

  _AadhaarParsed({this.name, this.gender, this.address});
}
