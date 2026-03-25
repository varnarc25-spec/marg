/// Water biller from `GET /api/utilities/water/billers`.
class WaterBiller {
  final String id;
  final String name;
  final String stateId;

  const WaterBiller({
    required this.id,
    required this.name,
    required this.stateId,
  });

  factory WaterBiller.fromApiJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['billerId']?.toString() ?? '';
    final name =
        (json['name'] ?? json['billerName'] ?? json['title'] ?? '').toString();
    final state = (json['stateId'] ??
            json['state'] ??
            json['stateCode'] ??
            '')
        .toString();
    return WaterBiller(
      id: id.isNotEmpty ? id : 'unknown',
      name: name.isNotEmpty ? name : 'Biller',
      stateId: state,
    );
  }
}
