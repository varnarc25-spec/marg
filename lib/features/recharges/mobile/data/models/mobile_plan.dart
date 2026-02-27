/// Mobile recharge plan (prepaid / data / top-up).
/// TODO: Align with BBPS plan response when integrated.
class MobilePlan {
  final String id;
  final String name;
  final String description;
  final double amount;
  final String validity;
  final String dataAllowance;
  final String talktime;
  final String planType; // 'prepaid' | 'data' | 'topup' | 'full_talktime'
  final bool isBestValue;

  const MobilePlan({
    required this.id,
    required this.name,
    required this.amount,
    this.description = '',
    this.validity = '',
    this.dataAllowance = '',
    this.talktime = '',
    this.planType = 'prepaid',
    this.isBestValue = false,
  });

  factory MobilePlan.fromJson(Map<String, dynamic> json) {
    return MobilePlan(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      validity: json['validity'] as String? ?? '',
      dataAllowance: json['dataAllowance'] as String? ?? '',
      talktime: json['talktime'] as String? ?? '',
      planType: json['planType'] as String? ?? 'prepaid',
      isBestValue: json['isBestValue'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'amount': amount,
        'validity': validity,
        'dataAllowance': dataAllowance,
        'talktime': talktime,
        'planType': planType,
        'isBestValue': isBestValue,
      };
}
