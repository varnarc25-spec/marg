/// Saved account from `GET/POST/PUT/DELETE /api/utilities/book-cylinder/accounts`.
class GasSavedAccount {
  GasSavedAccount({
    required this.id,
    required this.accountNumber,
    this.label,
    this.billerId,
    this.billerName,
    this.consumerName,
    this.isAutopay = false,
    this.raw = const {},
  });

  final String id;
  final String accountNumber;
  final String? label;
  final String? billerId;
  final String? billerName;
  final String? consumerName;
  final bool isAutopay;
  final Map<String, dynamic> raw;

  factory GasSavedAccount.fromApiJson(Map<String, dynamic> json) {
    return GasSavedAccount(
      id: json['id']?.toString() ?? json['accountId']?.toString() ?? '',
      accountNumber:
          (json['accountNumber'] ?? json['consumerNumber'] ?? json['accountNo'] ?? '')
              .toString(),
      label: json['label']?.toString(),
      billerId: json['billerId']?.toString(),
      billerName: json['billerName']?.toString(),
      consumerName: json['consumerName']?.toString(),
      isAutopay: json['isAutopay'] == true,
      raw: Map<String, dynamic>.from(json),
    );
  }
}

