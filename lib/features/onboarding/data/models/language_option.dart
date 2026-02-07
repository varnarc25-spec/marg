import 'package:flutter/material.dart';

/// Language option: code, native script, English name, pastel color.
/// Parsed from onboarding/data languages.json.
class LanguageOption {
  final String code;
  final String nativeName;
  final String englishName;
  final Color color;

  const LanguageOption({
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.color,
  });

  factory LanguageOption.fromJson(Map<String, dynamic> json) {
    final colorHex = json['color'] as String? ?? '#E8E8E8';
    return LanguageOption(
      code: json['code'] as String? ?? '',
      nativeName: json['nativeName'] as String? ?? '',
      englishName: json['englishName'] as String? ?? '',
      color: _colorFromHex(colorHex),
    );
  }

  static Color _colorFromHex(String hex) {
    final clean = hex.replaceAll('#', '');
    if (clean.length == 6) {
      return Color(int.parse('FF$clean', radix: 16));
    }
    return const Color(0xFFE8E8E8);
  }
}
