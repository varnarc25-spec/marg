/// Fetched electricity bill. TODO: BBPS fetch bill response.
class ElectricityBill {
  final String consumerId;
  final String name;
  final double amount;
  final DateTime dueDate;
  final String breakdown; // JSON or summary
  const ElectricityBill({
    required this.consumerId,
    required this.name,
    required this.amount,
    required this.dueDate,
    this.breakdown = '',
  });
}
