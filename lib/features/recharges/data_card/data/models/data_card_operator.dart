/// Data card operator. TODO: API when BBPS integrated.
class DataCardOperator {
  final String id;
  final String name;
  const DataCardOperator({required this.id, required this.name});
  factory DataCardOperator.fromJson(Map<String, dynamic> json) =>
      DataCardOperator(id: json['id'] as String? ?? '', name: json['name'] as String? ?? '');
}
