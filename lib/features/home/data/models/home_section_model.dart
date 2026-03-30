import '../../domain/entities/home_section.dart';
import 'home_section_category_model.dart';
import 'service_item_model.dart';

class HomeSectionModel {
  const HomeSectionModel({
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
  final List<HomeSectionCategoryModel> categories;

  factory HomeSectionModel.fromJson(Map<String, dynamic> json) {
    final rawCategories = json['categories'];
    final rawItems = json['items'];
    final List<HomeSectionCategoryModel> categories;
    if (rawCategories is List && rawCategories.isNotEmpty) {
      categories = rawCategories
          .whereType<Map>()
          .map(
            (m) => HomeSectionCategoryModel.fromJson(
              m.cast<String, dynamic>(),
            ),
          )
          .toList();
    } else if (rawItems is List && rawItems.isNotEmpty) {
      final flat = rawItems
          .whereType<Map>()
          .map(
            (item) =>
                ServiceItemModel.fromJson(item.cast<String, dynamic>()),
          )
          .toList();
      categories = [
        HomeSectionCategoryModel(
          id: '',
          name: '',
          slug: '',
          displayOrder: 0,
          items: flat,
        ),
      ];
    } else {
      categories = const <HomeSectionCategoryModel>[];
    }

    return HomeSectionModel(
      title: ((json['title'] ?? json['name']) ?? '') as String,
      slug: (json['slug'] ?? '') as String,
      layout: (json['layout'] ?? 'grid') as String,
      viewAll: (json['view_all'] ?? false) as bool,
      categories: categories,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'slug': slug,
      'layout': layout,
      'view_all': viewAll,
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }

  HomeSection toEntity() {
    return HomeSection(
      title: title,
      slug: slug,
      layout: layout,
      viewAll: viewAll,
      categories: categories.map((e) => e.toEntity()).toList(growable: false),
    );
  }
}
