class LoanRepaymentHistoryItem {
  LoanRepaymentHistoryItem({
    required this.id,
    required this.amount,
    this.status,
    this.billerName,
    this.paidAt,
    this.raw = const {},
  });

  final String id;
  final double amount;
  final String? status;
  final String? billerName;
  final DateTime? paidAt;
  final Map<String, dynamic> raw;

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  factory LoanRepaymentHistoryItem.fromApiJson(Map<String, dynamic> json) {
    return LoanRepaymentHistoryItem(
      id: json['id']?.toString() ?? json['transactionId']?.toString() ?? '',
      amount: _toDouble(json['amount'] ?? json['value']),
      status: json['status']?.toString(),
      billerName: json['billerName']?.toString(),
      paidAt: DateTime.tryParse((json['paidAt'] ?? json['createdAt'] ?? '').toString()),
      raw: Map<String, dynamic>.from(json),
    );
  }
}
