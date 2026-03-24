class LoanRepaymentSavedAccount {
  LoanRepaymentSavedAccount({
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

  factory LoanRepaymentSavedAccount.fromApiJson(Map<String, dynamic> json) {
    return LoanRepaymentSavedAccount(
      id: json['id']?.toString() ?? json['accountId']?.toString() ?? '',
      accountNumber:
          (json['accountNumber'] ?? json['consumerNumber'] ?? json['loanAccountNumber'] ?? '')
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
