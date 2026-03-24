/// Row from `GET /api/recharges/fastag/recharge/history`.
class FastagRechargeHistoryItem {
  FastagRechargeHistoryItem({
    required this.id,
    required this.amount,
    this.status,
    this.vehicleLabel,
    this.createdAt,
    this.raw = const {},
  });

  final String id;
  final double amount;
  final String? status;
  final String? vehicleLabel;
  final DateTime? createdAt;
  final Map<String, dynamic> raw;

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }

  factory FastagRechargeHistoryItem.fromApiJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ??
        json['transactionId']?.toString() ??
        json['_id']?.toString() ??
        '';
    return FastagRechargeHistoryItem(
      id: id.isNotEmpty ? id : '—',
      amount: _toDouble(json['amount'] ?? json['value']),
      status: json['status']?.toString(),
      vehicleLabel: json['vehicleNumber']?.toString() ??
          json['registrationNumber']?.toString(),
      createdAt: _parseDate(
        json['createdAt'] ?? json['timestamp'] ?? json['date'],
      ),
      raw: Map<String, dynamic>.from(json),
    );
  }
}
