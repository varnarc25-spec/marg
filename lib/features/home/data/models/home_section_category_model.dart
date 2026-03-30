import '../../domain/entities/home_section_category.dart';
import 'service_item_model.dart';

class HomeSectionCategoryModel {
  const HomeSectionCategoryModel({
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
  final List<ServiceItemModel> items;

  factory HomeSectionCategoryModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return HomeSectionCategoryModel(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      slug: (json['slug'] ?? '') as String,
      displayOrder: _int(json['display_order']),
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map(
                  (item) =>
                      ServiceItemModel.fromJson(item.cast<String, dynamic>()),
                )
                .toList()
          : const <ServiceItemModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'slug': slug,
      'display_order': displayOrder,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  HomeSectionCategory toEntity() {
    return HomeSectionCategory(
      id: id,
      name: name,
      slug: slug,
      displayOrder: displayOrder,
      items: items.map((e) => e.toEntity()).toList(growable: false),
    );
  }
}

int _int(dynamic v, [int fallback = 0]) {
  if (v == null) return fallback;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? fallback;
}
