/// DTH operator from `GET /api/recharges/dth/operators`.
class DthOperator {
  const DthOperator({
    required this.id,
    required this.name,
    this.logoUrl,
  });

  final String id;
  final String name;
  final String? logoUrl;

  factory DthOperator.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ??
            json['operatorId'] ??
            json['operatorCode'] ??
            json['code'] ??
            '')
        .toString();
    final name = (json['name'] ??
            json['operatorName'] ??
            json['title'] ??
            json['label'] ??
            '')
        .toString();
    final logo = json['logoUrl'] ?? json['logo'] ?? json['imageUrl'];
    return DthOperator(
      id: id,
      name: name.isEmpty ? 'Operator' : name,
      logoUrl: logo?.toString(),
    );
  }
}
