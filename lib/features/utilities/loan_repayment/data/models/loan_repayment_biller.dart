class LoanRepaymentBiller {
  const LoanRepaymentBiller({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory LoanRepaymentBiller.fromApiJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['billerId']?.toString() ?? '';
    final name = (json['name'] ?? json['billerName'] ?? json['title'] ?? '').toString();
    return LoanRepaymentBiller(
      id: id.isNotEmpty ? id : 'unknown',
      name: name.isNotEmpty ? name : 'Biller',
    );
  }
}
