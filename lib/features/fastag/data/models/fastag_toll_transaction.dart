/// Row from `GET /api/recharges/fastag/toll-history/{vehicleId}`.
class FastagTollTransaction {
  FastagTollTransaction({
    required this.tollName,
    required this.amount,
    this.at,
    this.raw = const {},
  });

  final String tollName;
  final double amount;
  final DateTime? at;
  final Map<String, dynamic> raw;

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  factory FastagTollTransaction.fromApiJson(Map<String, dynamic> json) {
    final toll = (json['toll'] ??
            json['tollName'] ??
            json['plazaName'] ??
            json['location'] ??
            'Toll')
        .toString();
    return FastagTollTransaction(
      tollName: toll,
      amount: _toDouble(json['amount'] ?? json['value']),
      at: DateTime.tryParse(
        (json['date'] ?? json['timestamp'] ?? json['createdAt'] ?? '')
            .toString(),
      ),
      raw: Map<String, dynamic>.from(json),
    );
  }
}
