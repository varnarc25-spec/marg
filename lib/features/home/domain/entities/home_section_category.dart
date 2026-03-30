import 'package:flutter/foundation.dart';
import 'service_item.dart';

@immutable
class HomeSectionCategory {
  const HomeSectionCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.displayOrder,
    required this.items,
  });

  final String id;
  final String name;
  final String slug;
  final int displayOrder;
  final List<ServiceItem> items;
}
