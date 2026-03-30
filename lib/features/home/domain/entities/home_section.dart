import 'package:flutter/foundation.dart';
import 'home_section_category.dart';
import 'service_item.dart';

@immutable
class HomeSection {
  const HomeSection({
    required this.title,
    required this.slug,
    required this.layout,
    required this.viewAll,
    required this.categories,
  });

  final String title;
  final String slug;
  final String layout;
  final bool viewAll;

  /// API: `sections[].categories[]`; each has nested `items`.
  final List<HomeSectionCategory> categories;

  /// Flat list in category order (for grids that expect a single list).
  List<ServiceItem> get items =>
      categories.expand((c) => c.items).toList(growable: false);
}
