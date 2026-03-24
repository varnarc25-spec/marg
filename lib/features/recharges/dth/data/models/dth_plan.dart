/// DTH recharge plan from `POST /api/recharges/dth/plans`.
class DthPlan {
  const DthPlan({
    required this.id,
    required this.name,
    required this.amount,
    this.validity = '',
    this.planType = '',
    this.isBestValue = false,
  });

  final String id;
  final String name;
  final double amount;
  /// Sent to `POST /initiate` as `validity`.
  final String validity;
  /// Sent to `POST /initiate` as `planType`.
  final String planType;
  final bool isBestValue;

  factory DthPlan.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['planId'] ?? json['_id'] ?? '').toString();
    final name = (json['name'] ??
            json['planName'] ??
            json['description'] ??
            json['title'] ??
            'Plan')
        .toString();
    final rawAmount = json['amount'] ??
        json['price'] ??
        json['rechargeAmount'] ??
        json['mrp'] ??
        json['rupees'];
    double amount = 0;
    if (rawAmount is num) {
      amount = rawAmount.toDouble();
    } else if (rawAmount != null) {
      amount = double.tryParse(rawAmount.toString().replaceAll(RegExp(r'[^0-9.]'), '')) ??
          0;
    }
    final validity = (json['validity'] ??
            json['validityLabel'] ??
            json['validityDays'] ??
            '')
        .toString();
    final planType = (json['planType'] ?? json['type'] ?? json['category'] ?? '')
        .toString();
    return DthPlan(
      id: id.isEmpty ? name.hashCode.toString() : id,
      name: name,
      amount: amount,
      validity: validity,
      planType: planType,
      isBestValue: json['isBestValue'] == true || json['best'] == true,
    );
  }
}
