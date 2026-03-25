import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/shared/providers/app_providers.dart';

import '../../data/models/fastag_auto_recharge_rule.dart';
import '../../data/models/fastag_recharge_history_item.dart';
import '../../data/models/fastag_toll_transaction.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/repositories/fastag_repository.dart';
import '../../data/services/fastag_api_service.dart';

final fastagApiServiceProvider = Provider<FastagApiService>((ref) {
  return FastagApiService();
});

final fastagRepositoryProvider = Provider<FastagRepository>((ref) {
  return FastagRepository(
    ref.watch(fastagApiServiceProvider),
    ref.watch(firebaseAuthServiceProvider),
  );
});

/// `GET /api/recharges/fastag/vehicles`
final fastagVehiclesProvider =
    FutureProvider.autoDispose<List<VehicleModel>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  final repo = ref.watch(fastagRepositoryProvider);
  return repo.getVehicles();
});

final selectedFastagVehicleProvider = StateProvider<VehicleModel?>((ref) => null);

/// `GET /api/recharges/fastag/recharge/history`
final fastagRechargeHistoryProvider =
    FutureProvider.autoDispose<List<FastagRechargeHistoryItem>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  final repo = ref.watch(fastagRepositoryProvider);
  return repo.getRechargeHistory();
});

/// `GET /api/recharges/fastag/toll-history/{vehicleId}`
final fastagTollHistoryProvider = FutureProvider.autoDispose
    .family<List<FastagTollTransaction>, String>((ref, vehicleId) async {
  ref.watch(firebaseAuthUserProvider);
  final repo = ref.watch(fastagRepositoryProvider);
  return repo.getTollHistory(vehicleId);
});

/// `GET /api/recharges/fastag/auto-recharge/{vehicleId}`
final fastagAutoRechargeProvider = FutureProvider.autoDispose
    .family<FastagAutoRechargeRule, String>((ref, vehicleId) async {
  ref.watch(firebaseAuthUserProvider);
  final repo = ref.watch(fastagRepositoryProvider);
  return repo.getAutoRechargeRule(vehicleId);
});

/// Extract recharge / txn id from initiate response for status polling.
String? fastagTransactionIdFromResponse(Map<String, dynamic> data) {
  final v = data['id'] ??
      data['transactionId'] ??
      data['rechargeId'] ??
      data['orderId'];
  return v?.toString();
}
