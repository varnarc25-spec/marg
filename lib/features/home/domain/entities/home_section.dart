import 'package:flutter/foundation.dart';
import 'service_item.dart';

@immutable
class HomeSection {
  const HomeSection({
    required this.title,
    required this.slug,
    required this.layout,
    required this.viewAll,
    required this.items,
  });

  final String title;
  final String slug;
  final String layout;
  final bool viewAll;
  final List<ServiceItem> items;
}
