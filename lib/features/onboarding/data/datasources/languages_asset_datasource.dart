import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/language_option.dart';

/// Loads language options from assets/onboarding/data/languages.json.
class LanguagesAssetDatasource {
  LanguagesAssetDatasource._();

  static const String _assetPath = 'assets/onboarding/data/languages.json';

  /// Loads and parses the languages JSON; returns list of [LanguageOption].
  static Future<List<LanguageOption>> loadLanguages() async {
    final jsonString = await rootBundle.loadString(_assetPath);
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = json['languages'] as List<dynamic>? ?? [];
    return list
        .map((e) => LanguageOption.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
