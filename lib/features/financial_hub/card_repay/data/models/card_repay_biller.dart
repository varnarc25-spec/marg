class CardRepayBiller {
  final String id;
  final String name;

  const CardRepayBiller({
    required this.id,
    required this.name,
  });

  factory CardRepayBiller.fromApiJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['billerId']?.toString() ?? '';
    final name =
        (json['name'] ?? json['billerName'] ?? json['title'] ?? '').toString();
    return CardRepayBiller(
      id: id.isNotEmpty ? id : 'unknown',
      name: name.isNotEmpty ? name : 'Biller',
    );
  }
}
