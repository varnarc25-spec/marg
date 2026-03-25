import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/shared/providers/app_providers.dart';

import '../../data/models/electricity_bill.dart';
import '../../data/models/electricity_biller.dart';
import '../../data/models/electricity_history_item.dart';
import '../../data/models/electricity_saved_account.dart';
import '../../data/models/electricity_state.dart';
import '../../data/repositories/electricity_repository.dart';
import '../../data/services/electricity_api_service.dart';

final electricityApiServiceProvider = Provider<ElectricityApiService>((ref) {
  return ElectricityApiService();
});

final electricityRepositoryProvider = Provider<ElectricityRepository>((ref) {
  return ElectricityRepository(
    ref.watch(electricityApiServiceProvider),
    ref.watch(firebaseAuthServiceProvider),
  );
});

final electricityStatesProvider =
    FutureProvider<List<ElectricityState>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(electricityRepositoryProvider).getStates();
});

/// `GET /billers` filtered by state in repository.
final electricityBillersProvider =
    FutureProvider.family<List<ElectricityBiller>, String>((ref, stateId) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(electricityRepositoryProvider).getBillers(stateId);
});

/// All available discoms, used by single-screen flow.
final electricityAllBillersProvider = FutureProvider<List<ElectricityBiller>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(electricityRepositoryProvider).getBillers('');
});

/// `GET /history`
final electricityHistoryProvider =
    FutureProvider<List<ElectricityHistoryItem>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(electricityRepositoryProvider).getHistory();
});

/// `GET /accounts`
final electricitySavedAccountsProvider =
    FutureProvider<List<ElectricitySavedAccount>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(electricityRepositoryProvider).getSavedAccounts();
});

final selectedElectricityStateProvider = StateProvider<ElectricityState?>((ref) => null);
final selectedElectricityBillerProvider = StateProvider<ElectricityBiller?>((ref) => null);
/// Consumer number used in `fetch-bill` / display (`consumerNumber` in API).
final electricityConsumerNumberProvider = StateProvider<String>((ref) => '');
final fetchedElectricityBillProvider = StateProvider<ElectricityBill?>((ref) => null);
