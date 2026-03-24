class LoanRepaymentBill {
  LoanRepaymentBill({
    required this.consumerNumber,
    required this.consumerName,
    required this.amount,
    required this.dueDate,
    this.billPeriod = '',
    this.billDate,
    this.lateFee = 0,
    this.convenienceFee = 0,
    this.billDetails = const {},
    this.breakdown = '',
    this.raw = const {},
  });

  final String consumerNumber;
  final String consumerName;
  final double amount;
  final DateTime dueDate;
  final String billPeriod;
  final DateTime? billDate;
  final double lateFee;
  final double convenienceFee;
  final Map<String, dynamic> billDetails;
  final String breakdown;
  final Map<String, dynamic> raw;

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  factory LoanRepaymentBill.fromApiJson(Map<String, dynamic> json) {
    final consumer =
        (json['consumerNumber'] ?? json['consumerId'] ?? json['loanAccountNumber'] ?? '').toString();
    final name =
        (json['consumerName'] ?? json['name'] ?? json['customerName'] ?? 'Customer').toString();
    final amount = _toDouble(json['amount'] ?? json['billAmount'] ?? json['payableAmount']);

    var due = DateTime.now().add(const Duration(days: 10));
    final dueRaw = json['dueDate'] ?? json['billDueDate'];
    if (dueRaw != null) {
      due = DateTime.tryParse(dueRaw.toString()) ?? due;
    }

    DateTime? billDate;
    final billDateRaw = json['billDate'];
    if (billDateRaw != null) {
      billDate = DateTime.tryParse(billDateRaw.toString());
    }

    Map<String, dynamic> details = {};
    final detailsMap = json['billDetails'];
    if (detailsMap is Map) {
      details = Map<String, dynamic>.from(detailsMap);
    }

    return LoanRepaymentBill(
      consumerNumber: consumer,
      consumerName: name,
      amount: amount,
      dueDate: due,
      billPeriod: (json['billPeriod'] ?? '').toString(),
      billDate: billDate,
      lateFee: _toDouble(json['lateFee']),
      convenienceFee: _toDouble(json['convenienceFee']),
      billDetails: details,
      breakdown: (json['breakdown'] ?? json['summary'] ?? json['description'] ?? '').toString(),
      raw: Map<String, dynamic>.from(json),
    );
  }
}
