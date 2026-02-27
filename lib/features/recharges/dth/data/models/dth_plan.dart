/// DTH recharge plan. TODO: Align with BBPS plan response.
class DthPlan {
  final String id;
  final String name;
  final double amount;
  final String validity;
  final bool isBestValue;
  const DthPlan({
    required this.id,
    required this.name,
    required this.amount,
    this.validity = '',
    this.isBestValue = false,
  });
  factory DthPlan.fromJson(Map<String, dynamic> json) => DthPlan(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        validity: json['validity'] as String? ?? '',
        isBestValue: json['isBestValue'] as bool? ?? false,
      );
}
