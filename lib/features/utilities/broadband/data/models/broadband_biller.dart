/// Broadband/Landline biller from `GET /api/utilities/broadband-landline/billers`.
class BroadbandBiller {
  final String id;
  final String name;
  final String stateId;

  const BroadbandBiller({
    required this.id,
    required this.name,
    required this.stateId,
  });

  factory BroadbandBiller.fromApiJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['billerId']?.toString() ?? '';
    final name =
        (json['name'] ?? json['billerName'] ?? json['title'] ?? '').toString();
    final state = (json['stateId'] ?? json['state'] ?? json['stateCode'] ?? '')
        .toString();
    return BroadbandBiller(
      id: id.isNotEmpty ? id : 'unknown',
      name: name.isNotEmpty ? name : 'Biller',
      stateId: state,
    );
  }
}
