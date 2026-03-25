/// Saved DTH account from `GET /api/recharges/dth/saved-accounts`.
class DthSavedAccount {
  const DthSavedAccount({
    required this.id,
    required this.subscriberId,
    required this.operatorId,
    required this.operatorName,
    this.subscriberName,
    this.logoUrl,
    this.planAmount,
    this.planExpiresOn,
    this.createdAt,
  });

  final String id;
  final String subscriberId;
  final String operatorId;
  final String operatorName;
  final String? subscriberName;
  final String? logoUrl;
  final double? planAmount;
  final DateTime? planExpiresOn;
  final DateTime? createdAt;

  String get displayTitle =>
      (subscriberName != null && subscriberName!.trim().isNotEmpty)
          ? subscriberName!.trim()
          : subscriberId;

  String get subtitleLine => '$subscriberId · $operatorName';

  factory DthSavedAccount.fromJson(Map<String, dynamic> json) {
    final id = _str(json['id'] ?? json['_id'] ?? json['savedAccountId']);
    final subId = _str(
      json['subscriberId'] ??
          json['customerId'] ??
          json['vcNumber'] ??
          json['accountNumber'] ??
          json['number'],
    );
    final opId = _str(
      json['operatorCode'] ??
          json['operatorId'] ??
          json['operator'] ??
          json['billerId'],
    );
    final opName = _str(
      json['operatorName'] ??
          json['operator'] ??
          json['billerName'] ??
          json['providerName'],
    );
    return DthSavedAccount(
      id: id.isEmpty ? subId + opId : id,
      subscriberId: subId,
      operatorId: opId,
      operatorName: opName.isEmpty ? 'DTH' : opName,
      subscriberName: _nullableStr(
        json['label'] ??
            json['name'] ??
            json['subscriberName'] ??
            json['displayName'],
      ),
      logoUrl: _nullableStr(json['logoUrl'] ?? json['logo'] ?? json['imageUrl']),
      planAmount: _num(json['planAmount'] ?? json['lastPlanAmount'] ?? json['amount']),
      planExpiresOn: _parseDate(
        json['planExpiresOn'] ?? json['expiryDate'] ?? json['validTill'],
      ),
      createdAt: _parseDate(
        json['createdAt'] ?? json['addedOn'] ?? json['created_at'],
      ),
    );
  }

  static String _str(dynamic v) => v?.toString().trim() ?? '';
  static String? _nullableStr(dynamic v) {
    final s = v?.toString().trim();
    return s == null || s.isEmpty ? null : s;
  }

  static double? _num(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString().replaceAll(RegExp(r'[^0-9.]'), ''));
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}
