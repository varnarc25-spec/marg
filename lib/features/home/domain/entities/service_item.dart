import 'package:flutter/foundation.dart';

@immutable
class ServiceItem {
  const ServiceItem({
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
}
