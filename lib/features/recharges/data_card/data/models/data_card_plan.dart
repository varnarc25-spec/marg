/// Data card plan. TODO: Align with API.
class DataCardPlan {
  final String id;
  final String name;
  final double amount;
  final String dataAllowance;
  final String validity;
  const DataCardPlan({
    required this.id,
    required this.name,
    required this.amount,
    this.dataAllowance = '',
    this.validity = '',
  });
  factory DataCardPlan.fromJson(Map<String, dynamic> json) => DataCardPlan(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        dataAllowance: json['dataAllowance'] as String? ?? '',
        validity: json['validity'] as String? ?? '',
      );
}
