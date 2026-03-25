import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/shared/providers/app_providers.dart';

import '../../data/models/water_bill.dart';
import '../../data/models/water_biller.dart';
import '../../data/models/water_history_item.dart';
import '../../data/models/water_saved_account.dart';
import '../../data/models/water_state.dart';
import '../../data/repositories/water_repository.dart';
import '../../data/services/water_api_service.dart';

final waterApiServiceProvider = Provider<WaterApiService>((ref) {
  return WaterApiService();
});

final waterRepositoryProvider = Provider<WaterRepository>((ref) {
  return WaterRepository(
    ref.watch(waterApiServiceProvider),
    ref.watch(firebaseAuthServiceProvider),
  );
});

final waterStatesProvider = FutureProvider<List<WaterState>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(waterRepositoryProvider).getStates();
});

final waterBillersProvider =
    FutureProvider.family<List<WaterBiller>, String>((ref, stateId) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(waterRepositoryProvider).getBillers(stateId);
});

final waterAllBillersProvider = FutureProvider<List<WaterBiller>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(waterRepositoryProvider).getBillers('');
});

final waterHistoryProvider =
    FutureProvider<List<WaterHistoryItem>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(waterRepositoryProvider).getHistory();
});

final waterSavedAccountsProvider =
    FutureProvider<List<WaterSavedAccount>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(waterRepositoryProvider).getSavedAccounts();
});

final selectedWaterStateProvider = StateProvider<WaterState?>((ref) => null);
final selectedWaterBillerProvider = StateProvider<WaterBiller?>((ref) => null);
final waterConsumerNumberProvider = StateProvider<String>((ref) => '');
final fetchedWaterBillProvider = StateProvider<WaterBill?>((ref) => null);
