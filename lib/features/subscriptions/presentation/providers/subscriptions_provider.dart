import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/subscription_model.dart';
import '../../data/repositories/subscriptions_repository.dart';

final subscriptionsRepositoryProvider = Provider<SubscriptionsRepository>((ref) => SubscriptionsRepository());
final subscriptionsListProvider = FutureProvider<List<SubscriptionModel>>((ref) => ref.read(subscriptionsRepositoryProvider).getSubscriptions());
