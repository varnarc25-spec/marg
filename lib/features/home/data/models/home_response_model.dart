import '../../domain/entities/home_response.dart';
import 'home_section_model.dart';

class HomeResponseModel {
  const HomeResponseModel({required this.status, required this.sections});

  final String status;
  final List<HomeSectionModel> sections;

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final dynamic rawSections = rawData is Map ? rawData['sections'] : rawData;
    final normalizedStatus = (json['status'] ?? (json['success'] == true ? 'success' : 'error')).toString();
    return HomeResponseModel(
      status: normalizedStatus,
      sections: rawSections is List
          ? rawSections
                .whereType<Map>()
                .map(
                  (item) =>
                      HomeSectionModel.fromJson(item.cast<String, dynamic>()),
                )
                .toList()
          : const <HomeSectionModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status,
      'data': sections.map((e) => e.toJson()).toList(),
    };
  }

  HomeResponse toEntity() {
    return HomeResponse(
      status: status,
      sections: sections.map((e) => e.toEntity()).toList(growable: false),
    );
  }
}
