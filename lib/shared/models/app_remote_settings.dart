import 'dart:convert';

/// Remote singleton app config from `GET /api/app-settings` (marg_api).
/// Cached locally as JSON via [AppRemoteSettingsNotifier].
class AppRemoteSettings {
  const AppRemoteSettings({
    this.appName,
    this.logoUrl,
    this.shortDescription,
    this.primaryColor,
    this.accentColor,
    this.maintenanceMode = false,
    this.forceUpdate = false,
    this.defaultLanguage,
  });

  final String? appName;
  final String? logoUrl;
  final String? shortDescription;
  final String? primaryColor;
  final String? accentColor;
  final bool maintenanceMode;
  final bool forceUpdate;
  final String? defaultLanguage;

  /// Display name for UI when API returns a non-empty value; otherwise use l10n / "Marg".
  String? get displayAppName {
    final t = appName?.trim();
    if (t == null || t.isEmpty) return null;
    return t;
  }

  static AppRemoteSettings fallback() => const AppRemoteSettings();

  factory AppRemoteSettings.fromJson(Map<String, dynamic> json) {
    return AppRemoteSettings(
      appName: _str(json['appName'] ?? json['app_name']),
      logoUrl: _str(json['logoUrl'] ?? json['logo_url']),
      shortDescription: _str(json['shortDescription'] ?? json['short_description']),
      primaryColor: _str(json['primaryColor'] ?? json['primary_color']),
      accentColor: _str(json['accentColor'] ?? json['accent_color']),
      maintenanceMode:
          json['maintenanceMode'] == true || json['maintenance_mode'] == true,
      forceUpdate: json['forceUpdate'] == true || json['force_update'] == true,
      defaultLanguage: _str(json['defaultLanguage'] ?? json['default_language']),
    );
  }

  Map<String, dynamic> toJson() => {
        'appName': appName,
        'logoUrl': logoUrl,
        'shortDescription': shortDescription,
        'primaryColor': primaryColor,
        'accentColor': accentColor,
        'maintenanceMode': maintenanceMode,
        'forceUpdate': forceUpdate,
        'defaultLanguage': defaultLanguage,
      };

  static String? _str(Object? v) {
    if (v == null) return null;
    if (v is String) {
      final t = v.trim();
      return t.isEmpty ? null : t;
    }
    return v.toString();
  }

  static AppRemoteSettings? tryDecodeCached(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw);
      if (map is Map<String, dynamic>) {
        return AppRemoteSettings.fromJson(map);
      }
    } catch (_) {}
    return null;
  }
}
