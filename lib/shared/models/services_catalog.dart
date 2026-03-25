/// Single service entry from GET /api/services/catalog.
class CatalogItem {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? iconName;
  final String? iconUrl;
  final String? badgeText;
  final String? flowType;

  const CatalogItem({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.iconName,
    this.iconUrl,
    this.badgeText,
    this.flowType,
  });

  factory CatalogItem.fromJson(Map<String, dynamic> json) {
    return CatalogItem(
      id: _intFrom(json['id']),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      iconName: json['icon_name']?.toString(),
      iconUrl: json['icon_url']?.toString(),
      badgeText: json['badge_text']?.toString(),
      flowType: json['flow_type']?.toString(),
    );
  }
}

int _intFrom(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

/// Category group from catalog (e.g. Recharges, Utilities, Others).
class CatalogCategory {
  final String name;
  final String slug;
  final List<CatalogItem> items;

  const CatalogCategory({
    required this.name,
    required this.slug,
    required this.items,
  });

  factory CatalogCategory.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'];
    final list = itemsList is List
        ? itemsList
              .whereType<Map<String, dynamic>>()
              .map((e) => CatalogItem.fromJson(e))
              .toList()
        : <CatalogItem>[];
    return CatalogCategory(
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      items: list,
    );
  }
}

/// Full response from GET /api/services/catalog.
class ServicesCatalog {
  final List<CatalogItem> suggested;
  final List<CatalogCategory> categories;

  const ServicesCatalog({required this.suggested, required this.categories});

  factory ServicesCatalog.fromJson(Map<String, dynamic> json) {
    final suggestedList = json['suggested'];
    final suggested = suggestedList is List
        ? suggestedList
              .whereType<Map<String, dynamic>>()
              .map((e) => CatalogItem.fromJson(e))
              .toList()
        : <CatalogItem>[];
    final categoriesList = json['categories'];
    final categories = categoriesList is List
        ? categoriesList
              .whereType<Map<String, dynamic>>()
              .map((e) => CatalogCategory.fromJson(e))
              .toList()
        : <CatalogCategory>[];
    return ServicesCatalog(suggested: suggested, categories: categories);
  }
}
