/// From `GET / PUT /api/recharges/fastag/auto-recharge/{vehicleId}`.
class FastagAutoRechargeRule {
  const FastagAutoRechargeRule({
    this.enabled = false,
    this.thresholdAmount,
    this.rechargeAmount,
    this.raw = const {},
  });

  final bool enabled;
  final double? thresholdAmount;
  final double? rechargeAmount;
  final Map<String, dynamic> raw;

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  factory FastagAutoRechargeRule.fromApiJson(Map<String, dynamic> json) {
    final enabled = json['enabled'] == true ||
        json['active'] == true ||
        json['isEnabled'] == true;
    return FastagAutoRechargeRule(
      enabled: enabled,
      thresholdAmount: _toDouble(
        json['thresholdAmount'] ?? json['minBalance'] ?? json['threshold'],
      ),
      rechargeAmount: _toDouble(
        json['rechargeAmount'] ?? json['topUpAmount'] ?? json['amount'],
      ),
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toApiBody() {
    return {
      'enabled': enabled,
      if (thresholdAmount != null) 'thresholdAmount': thresholdAmount,
      if (rechargeAmount != null) 'rechargeAmount': rechargeAmount,
    };
  }
}
