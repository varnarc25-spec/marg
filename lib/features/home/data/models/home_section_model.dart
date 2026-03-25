import '../../domain/entities/home_section.dart';
import 'service_item_model.dart';

class HomeSectionModel {
  const HomeSectionModel({
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
  final List<ServiceItemModel> items;

  factory HomeSectionModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return HomeSectionModel(
      title: ((json['title'] ?? json['name']) ?? '') as String,
      slug: (json['slug'] ?? '') as String,
      layout: (json['layout'] ?? 'grid') as String,
      viewAll: (json['view_all'] ?? false) as bool,
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
      'title': title,
      'slug': slug,
      'layout': layout,
      'view_all': viewAll,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  HomeSection toEntity() {
    return HomeSection(
      title: title,
      slug: slug,
      layout: layout,
      viewAll: viewAll,
      items: items.map((e) => e.toEntity()).toList(growable: false),
    );
  }
}
