import '../../../../core/config/api_config.dart';
import '../../domain/entities/service_item.dart';

String _stringField(Map<String, dynamic> json, String key) {
  final v = json[key];
  if (v == null) return '';
  return v.toString();
}

String? _nullableString(Map<String, dynamic> json, String key) {
  final v = json[key];
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

/// App-data / services APIs use [icon_url]; resolve root-relative paths against [ApiConfig.baseUrl].
String? _resolvedIconUrl(Map<String, dynamic> json) {
  final raw = _nullableString(json, 'icon_url');
  if (raw == null) return null;
  if (raw.startsWith('http://') ||
      raw.startsWith('https://') ||
      raw.startsWith('//')) {
    return raw.startsWith('//') ? 'https:$raw' : raw;
  }
  if (raw.startsWith('/')) {
    final base = ApiConfig.baseUrl.replaceAll(RegExp(r'/$'), '');
    return '$base$raw';
  }
  return raw;
}

class ServiceItemModel {
  const ServiceItemModel({
    required this.name,
    required this.slug,
    required this.icon,
    required this.flowType,
    this.badge,
    this.iconUrl,
  });

  final String name;
  final String slug;
  final String icon;
  final String flowType;
  final String? badge;
  final String? iconUrl;

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) {
    final fromIconName = _stringField(json, 'icon_name').trim();
    final fromLegacyIcon = _stringField(json, 'icon').trim();
    return ServiceItemModel(
      name: _stringField(json, 'name'),
      slug: _stringField(json, 'slug'),
      icon: fromIconName.isNotEmpty ? fromIconName : fromLegacyIcon,
      flowType: _stringField(json, 'flow_type'),
      badge: _nullableString(json, 'badge_text') ?? _nullableString(json, 'badge'),
      iconUrl: _resolvedIconUrl(json),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'slug': slug,
      'icon': icon,
      'flow_type': flowType,
      'badge': badge,
      'icon_url': iconUrl,
    };
  }

  ServiceItem toEntity() {
    return ServiceItem(
      name: name,
      slug: slug,
      icon: icon,
      flowType: flowType,
      badge: badge,
      iconUrl: iconUrl,
    );
  }
}
