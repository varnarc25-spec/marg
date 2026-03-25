/// Electricity biller (discom) from `GET /api/utilities/electricity/billers`.
class ElectricityBiller {
  final String id;
  final String name;
  /// Used when filtering by state in the UI; may be empty if API omits it.
  final String stateId;

  const ElectricityBiller({
    required this.id,
    required this.name,
    required this.stateId,
  });

  factory ElectricityBiller.fromApiJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['billerId']?.toString() ?? '';
    final name = (json['name'] ?? json['billerName'] ?? json['title'] ?? '').toString();
    final state = (json['stateId'] ??
            json['state'] ??
            json['stateCode'] ??
            '')
        .toString();
    return ElectricityBiller(
      id: id.isNotEmpty ? id : 'unknown',
      name: name.isNotEmpty ? name : 'Biller',
      stateId: state,
    );
  }
}
