class EducationBill {
  EducationBill({
    required this.consumerNumber,
    required this.consumerName,
    required this.amount,
    required this.dueDate,
    this.billPeriod = '',
    this.billDate,
    this.lateFee = 0,
    this.convenienceFee = 0,
    this.billDetails = const {},
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
  final Map<String, dynamic> raw;

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  factory EducationBill.fromApiJson(Map<String, dynamic> json) {
    final consumer = (json['consumerNumber'] ??
            json['consumerId'] ??
            json['accountNumber'] ??
            '')
        .toString();
    final nm = (json['consumerName'] ??
            json['name'] ??
            json['studentName'] ??
            'Student')
        .toString();
    final amt = _toDouble(
      json['amount'] ?? json['billAmount'] ?? json['payableAmount'],
    );
    DateTime due = DateTime.now().add(const Duration(days: 15));
    final dueRaw = json['dueDate'] ?? json['billDueDate'];
    if (dueRaw != null) {
      due = DateTime.tryParse(dueRaw.toString()) ?? due;
    }
    DateTime? bDate;
    final bd = json['billDate'];
    if (bd != null) {
      bDate = DateTime.tryParse(bd.toString());
    }
    Map<String, dynamic> details = {};
    final bdMap = json['billDetails'];
    if (bdMap is Map) {
      details = Map<String, dynamic>.from(bdMap);
    }

    return EducationBill(
      consumerNumber: consumer,
      consumerName: nm,
      amount: amt,
      dueDate: due,
      billPeriod: (json['billPeriod'] ?? '').toString(),
      billDate: bDate,
      lateFee: _toDouble(json['lateFee']),
      convenienceFee: _toDouble(json['convenienceFee']),
      billDetails: details,
      raw: Map<String, dynamic>.from(json),
    );
  }
}
