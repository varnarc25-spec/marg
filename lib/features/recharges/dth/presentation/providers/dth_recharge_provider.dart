import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/shared/providers/app_providers.dart';

import '../../data/models/dth_operator.dart';
import '../../data/models/dth_plan.dart';
import '../../data/models/dth_recharge_history_item.dart';
import '../../data/models/dth_saved_account.dart';
import '../../data/repositories/dth_recharge_repository.dart';
import '../../data/services/dth_api_service.dart';

final dthApiServiceProvider = Provider<DthApiService>((ref) => DthApiService());

final dthRechargeRepositoryProvider = Provider<DthRechargeRepository>((ref) {
  return DthRechargeRepository(
    ref.watch(dthApiServiceProvider),
    ref.watch(firebaseAuthServiceProvider),
  );
});

/// `GET /api/recharges/dth/operators`
final dthOperatorsProvider =
    FutureProvider.autoDispose<List<DthOperator>>((ref) async {
  final repo = ref.watch(dthRechargeRepositoryProvider);
  return repo.getOperators();
});

/// `GET /api/recharges/dth/saved-accounts`
final dthSavedAccountsProvider =
    FutureProvider.autoDispose<List<DthSavedAccount>>((ref) async {
  final repo = ref.watch(dthRechargeRepositoryProvider);
  return repo.getSavedAccounts();
});

/// `GET /api/recharges/dth/history`
final dthHistoryProvider =
    FutureProvider.autoDispose<List<DthRechargeHistoryItem>>((ref) async {
  final repo = ref.watch(dthRechargeRepositoryProvider);
  return repo.getHistory();
});

/// `POST /api/recharges/dth/plans` — body `{ "operatorId": "..." }` only.
final dthPlansProvider =
    FutureProvider.autoDispose.family<List<DthPlan>, String>((ref, operatorId) async {
  final repo = ref.watch(dthRechargeRepositoryProvider);
  return repo.fetchPlans(operatorId: operatorId);
});

final selectedDthOperatorProvider = StateProvider<DthOperator?>((ref) => null);

/// Subscriber / customer ID for the active DTH flow.
final dthSubscriberIdProvider = StateProvider<String>((ref) => '');

final selectedDthPlanProvider = StateProvider<DthPlan?>((ref) => null);

/// Set after `POST /initiate` for receipt / status.
final dthLastTransactionIdProvider = StateProvider<String?>((ref) => null);
