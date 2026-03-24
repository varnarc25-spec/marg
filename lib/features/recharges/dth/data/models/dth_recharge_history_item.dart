/// Single mobile recharge history entry.
/// TODO: Replace with API model when history is fetched from backend.
class DthRechargeHistoryItem {
  final String id;
  final String number;
  final String operatorName;
  final String alias; // Display name e.g. "Krishna", "hema mam"
  final double amount;
  final DateTime date;
  final String status;
  final String planName;

  /// Contact initials for avatar (e.g. "Kr"). Falls back to operator initials if null.
  final String? contactInitials;

  /// Masked number for secure display (e.g. "******2974").
  final String? maskedNumber;

  const DthRechargeHistoryItem({
    required this.id,
    required this.number,
    required this.operatorName,
    this.alias = '',
    required this.amount,
    required this.date,
    this.status = 'Success',
    this.planName = '',
    this.contactInitials,
    this.maskedNumber,
  });

  String get displayName => alias.isNotEmpty ? alias : number;

  /// Avatar text: contact initials if set, else first 2 chars of operator name.
  String get avatarText =>
      (contactInitials != null && contactInitials!.isNotEmpty)
      ? contactInitials!
      : (operatorName.length >= 2
            ? operatorName.substring(0, 2)
            : operatorName);

  factory DthRechargeHistoryItem.fromJson(Map<String, dynamic> json) {
    return DthRechargeHistoryItem(
      id: json['id'] as String? ?? '',
      number: json['number'] as String? ?? '',
      operatorName: json['operatorName'] as String? ?? '',
      alias: json['alias'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] as String? ?? 'Success',
      planName: json['planName'] as String? ?? '',
      contactInitials: json['contactInitials'] as String?,
      maskedNumber: json['maskedNumber'] as String?,
    );
  }

  /// From sample/API transaction JSON (transactionId, contactDisplayName, lastRechargeDate, etc.).
  factory DthRechargeHistoryItem.fromTransactionJson(
    Map<String, dynamic> json,
  ) {
    final dateStr = json['lastRechargeDate'] as String?;
    return DthRechargeHistoryItem(
      id: json['transactionId'] as String? ?? '',
      number: json['mobileNumber'] as String? ?? '',
      operatorName: json['operatorName'] as String? ?? '',
      alias: json['contactDisplayName'] as String? ?? '',
      amount: (json['lastRechargeAmount'] as num?)?.toDouble() ?? 0,
      date: dateStr != null
          ? DateTime.tryParse(dateStr) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] as String? ?? 'Success',
      planName: json['planName'] as String? ?? '',
      contactInitials: json['contactInitials'] as String?,
      maskedNumber: json['maskedNumber'] as String?,
    );
  }

  /// DTH history row from `GET /api/recharges/dth/history`.
  factory DthRechargeHistoryItem.fromApiJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['transactionId'] ?? json['_id'] ?? '').toString();
    final number = (json['subscriberId'] ??
            json['customerId'] ??
            json['accountNumber'] ??
            json['number'] ??
            '')
        .toString();
    final operatorName = (json['operatorName'] ?? json['operator'] ?? '').toString();
    final amount = (json['amount'] ?? json['rechargeAmount'] ?? json['planAmount']);
    double amt = 0;
    if (amount is num) {
      amt = amount.toDouble();
    } else if (amount != null) {
      amt = double.tryParse(amount.toString().replaceAll(RegExp(r'[^0-9.]'), '')) ??
          0;
    }
    final dateStr = json['createdAt'] ?? json['date'] ?? json['rechargedAt'];
    DateTime date = DateTime.now();
    if (dateStr != null) {
      date = DateTime.tryParse(dateStr.toString()) ?? date;
    }
    return DthRechargeHistoryItem(
      id: id.isEmpty ? '${number}_$operatorName' : id,
      number: number,
      operatorName: operatorName.isEmpty ? 'DTH' : operatorName,
      alias: (json['subscriberName'] ?? json['name'] ?? '').toString(),
      amount: amt,
      date: date,
      status: (json['status'] ?? 'Success').toString(),
      planName: (json['planName'] ?? '').toString(),
    );
  }
}
