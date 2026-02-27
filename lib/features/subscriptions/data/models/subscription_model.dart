/// Subscription item. TODO: API model.
class SubscriptionModel {
  final String id;
  final String name;
  final double amount;
  final String cycle; // monthly, yearly
  final DateTime nextRenewal;
  final bool isPaused;
  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.amount,
    this.cycle = 'monthly',
    required this.nextRenewal,
    this.isPaused = false,
  });
}
