import '../models/subscription_model.dart';

/// Subscriptions management. TODO: API for list, pause, cancel.
class SubscriptionsRepository {
  Future<List<SubscriptionModel>> getSubscriptions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      SubscriptionModel(id: '1', name: 'Netflix', amount: 649, cycle: 'monthly', nextRenewal: DateTime.now().add(const Duration(days: 12))),
      SubscriptionModel(id: '2', name: 'Spotify', amount: 119, cycle: 'monthly', nextRenewal: DateTime.now().add(const Duration(days: 5))),
      SubscriptionModel(id: '3', name: 'Amazon Prime', amount: 1499, cycle: 'yearly', nextRenewal: DateTime.now().add(const Duration(days: 90))),
    ];
  }
}
