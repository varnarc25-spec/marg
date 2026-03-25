/// Piped gas biller from `GET /api/utilities/piped-gas/billers`.
class GasBiller {
  final String id;
  final String name;
  final String stateId;

  const GasBiller({
    required this.id,
    required this.name,
    required this.stateId,
  });

  factory GasBiller.fromApiJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['billerId']?.toString() ?? '';
    final name =
        (json['name'] ?? json['billerName'] ?? json['title'] ?? '').toString();
    final state = (json['stateId'] ?? json['state'] ?? json['stateCode'] ?? '')
        .toString();
    return GasBiller(
      id: id.isNotEmpty ? id : 'unknown',
      name: name.isNotEmpty ? name : 'Biller',
      stateId: state,
    );
  }
}
