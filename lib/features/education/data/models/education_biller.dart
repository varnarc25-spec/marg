class EducationBiller {
  final String id;
  final String name;
  final String stateId;

  const EducationBiller({
    required this.id,
    required this.name,
    required this.stateId,
  });

  factory EducationBiller.fromApiJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['billerId']?.toString() ?? '';
    final name =
        (json['name'] ?? json['billerName'] ?? json['title'] ?? '').toString();
    final state = (json['stateId'] ?? json['state'] ?? json['stateCode'] ?? '')
        .toString();
    return EducationBiller(
      id: id.isNotEmpty ? id : 'unknown',
      name: name.isNotEmpty ? name : 'Biller',
      stateId: state,
    );
  }
}
