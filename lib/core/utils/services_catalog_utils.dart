import '../../shared/models/services_catalog.dart';

/// Returns catalog items for the given [categorySlugs], deduplicated by item `slug`.
///
/// Note: This function only filters `catalog.categories`; it does not include `catalog.suggested`.
List<CatalogItem> catalogItemsByCategorySlugs(
  ServicesCatalog catalog, {
  required Set<String> categorySlugs,
}) {
  final seen = <String>{};
  final list = <CatalogItem>[];

  for (final c in catalog.categories.where(
    (c) => categorySlugs.contains(c.slug),
  )) {
    for (final i in c.items) {
      if (seen.add(i.slug)) list.add(i);
    }
  }

  return list;
}

List<CatalogItem> catalogItemsByCategory(
  ServicesCatalog catalog, {
  required Set<String> category,
}) {
  final seen = <String>{};
  final list = <CatalogItem>[];

  for (final c in catalog.categories.where((c) => category.contains(c.slug))) {
    for (final i in c.items) {
      if (seen.add(i.slug)) list.add(i);
    }
  }

  return list;
}

/// Maps catalog items under a single [categorySlug] into a target type [T].
///
/// Returns `null` when:
/// - [catalog] is `null`
/// - `catalog.categories` is empty
/// - there are no matching category items
///
/// Note: This function only filters `catalog.categories`; it does not include `catalog.suggested`.
List<T>? mappedCatalogItemsByCategorySlug<T>(
  ServicesCatalog? catalog, {
  required String categorySlug,
  required T Function(CatalogItem item) itemMapper,
}) {
  if (catalog == null) return null;
  if (catalog.categories.isEmpty) return null;

  final items = catalogItemsByCategorySlugs(
    catalog,
    categorySlugs: {categorySlug},
  );
  print(categorySlug + 'items : ${items.length}');
  if (items.isEmpty) return null;
  return items.map(itemMapper).toList();
}

List<T>? mappedCatalogItemsByCategory<T>(
  ServicesCatalog? catalog, {
  required String category,
  required T Function(CatalogItem item) itemMapper,
}) {
  if (catalog == null) return null;
  if (catalog.categories.isEmpty) return null;

  final items = catalogItemsByCategory(catalog, category: {category});
  print(category + ' : items : ${items.length}');
  if (items.isEmpty) return null;
  return items.map(itemMapper).toList();
}
