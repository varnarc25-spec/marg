/// Saved credit card. TODO: Replace with secure API model.
class CreditCardModel {
  final String id;
  final String lastFour;
  final String bankName;
  final double totalDue;
  final double minimumDue;
  final DateTime dueDate;
  const CreditCardModel({
    required this.id,
    required this.lastFour,
    required this.bankName,
    this.totalDue = 0,
    this.minimumDue = 0,
    required this.dueDate,
  });
}
