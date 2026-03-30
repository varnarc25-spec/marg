import 'package:flutter/foundation.dart';

/// One row from [GET /api/services/menu-items?section_slug=].
class HubMenuItem {
  const HubMenuItem({
    required this.name,
    required this.slug,
    this.iconName,
    this.categorySlug,
    this.categoryName,
    this.catalogCategory,
    this.categoryDisplayOrder = _kUnorderedCategory,
    this.subcategoryDisplayOrder = 0,
    this.displayOrder = 0,
  });

  /// Sentinel: categories without master row sort after explicit orders.
  static const int _kUnorderedCategory = 1 << 20;

  /// Same as [_kUnorderedCategory]; use when comparing category sort keys from API.
  static const int unorderedCategorySortKey = _kUnorderedCategory;

  final String name;
  final String slug;
  final String? iconName;
  final String? categorySlug;
  final String? categoryName;

  /// Legacy `services.category` string when hierarchy fields are null.
  final String? catalogCategory;

  /// From `service_categories.display_order` (lower = earlier).
  final int categoryDisplayOrder;
  final int subcategoryDisplayOrder;
  final int displayOrder;

  factory HubMenuItem.fromJson(Map<String, dynamic> json) {
    return HubMenuItem(
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      iconName: json['icon_name']?.toString(),
      categorySlug: json['category_slug']?.toString(),
      categoryName: json['category_name']?.toString(),
      catalogCategory: json['category']?.toString(),
      categoryDisplayOrder: _intFrom(
        json['category_display_order'],
        ifNull: HubMenuItem._kUnorderedCategory,
      ),
      subcategoryDisplayOrder: _intFrom(json['subcategory_display_order']),
      displayOrder: _intFrom(json['display_order']),
    );
  }
}

int _intFrom(dynamic v, {int ifNull = 0}) {
  if (v == null) return ifNull;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? ifNull;
}

/// Parsed `data` from menu-items API.
class MenuItemsBySection {
  const MenuItemsBySection({required this.sectionSlug, required this.items});

  final String sectionSlug;
  final List<HubMenuItem> items;

  factory MenuItemsBySection.fromJson(Map<String, dynamic> json) {
    final raw = json['items'];
    final list = raw is List
        ? raw
              .whereType<Map>()
              .map((e) => HubMenuItem.fromJson(Map<String, dynamic>.from(e)))
              .where((e) => e.slug.isNotEmpty)
              .toList()
        : <HubMenuItem>[];
    return MenuItemsBySection(
      sectionSlug: json['section_slug']?.toString() ?? '',
      items: list,
    );
  }
}

/// Groups [items] by category, sorts **categories** by [HubMenuItem.categoryDisplayOrder]
/// then title; within each category sorts by [displayOrder] then name.
List<HubMenuCategoryGroup> groupHubMenuItemsByCategory(
  List<HubMenuItem> items,
) {
  final slugToItems = <String, List<HubMenuItem>>{};
  for (final item in items) {
    final slug =
        (item.categorySlug?.trim().isNotEmpty == true
                ? item.categorySlug!
                : (item.catalogCategory?.trim().isNotEmpty == true
                      ? item.catalogCategory!
                      : 'others'))
            .toLowerCase();
    slugToItems.putIfAbsent(slug, () => []).add(item);
  }

  for (final e in slugToItems.entries) {
    final names = e.value.map((i) => i.name).join(', ');
    debugPrint('  [${e.key}] (${e.value.length}): $names');
  }

  for (final list in slugToItems.values) {
    list.sort((a, b) {
      final bySub = a.subcategoryDisplayOrder.compareTo(
        b.subcategoryDisplayOrder,
      );
      if (bySub != 0) return bySub;
      final bySvc = a.displayOrder.compareTo(b.displayOrder);
      if (bySvc != 0) return bySvc;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  int categorySortKey(List<HubMenuItem> list) {
    var minO = HubMenuItem._kUnorderedCategory;
    for (final e in list) {
      if (e.categoryDisplayOrder < minO) minO = e.categoryDisplayOrder;
    }
    return minO;
  }

  final entries = slugToItems.entries.toList();
  entries.sort((a, b) {
    final byCat = categorySortKey(a.value).compareTo(categorySortKey(b.value));
    if (byCat != 0) return byCat;
    final ta = _groupTitle(a.key, a.value);
    final tb = _groupTitle(b.key, b.value);
    final byName = ta.toLowerCase().compareTo(tb.toLowerCase());
    if (byName != 0) return byName;
    return a.key.compareTo(b.key);
  });

  return entries.map((e) {
    final slug = e.key;
    final list = e.value;
    final title = _groupTitle(slug, list);
    final order = categorySortKey(list);
    return HubMenuCategoryGroup(
      slug: slug,
      title: title,
      categoryDisplayOrder: order,
      items: list,
    );
  }).toList();
}

String _groupTitle(String slug, List<HubMenuItem> list) {
  final fromApi = list.first.categoryName?.trim();
  if (fromApi != null && fromApi.isNotEmpty) return fromApi;
  return _titleCaseSlug(slug);
}

String _titleCaseSlug(String slug) {
  if (slug.isEmpty) return 'Others';
  return slug
      .split(RegExp(r'[-_]'))
      .where((p) => p.isNotEmpty)
      .map((p) => p[0].toUpperCase() + p.substring(1).toLowerCase())
      .join(' ');
}

class HubMenuCategoryGroup {
  const HubMenuCategoryGroup({
    required this.slug,
    required this.title,
    required this.categoryDisplayOrder,
    required this.items,
  });

  final String slug;
  final String title;

  /// Min `categoryDisplayOrder` among items in this group (matches sort key).
  final int categoryDisplayOrder;
  final List<HubMenuItem> items;
}
