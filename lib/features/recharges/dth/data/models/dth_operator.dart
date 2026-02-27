/// DTH operator model. TODO: Replace with API when BBPS integrated.
class DthOperator {
  final String id;
  final String name;
  const DthOperator({required this.id, required this.name});
  factory DthOperator.fromJson(Map<String, dynamic> json) =>
      DthOperator(id: json['id'] as String? ?? '', name: json['name'] as String? ?? '');
}
