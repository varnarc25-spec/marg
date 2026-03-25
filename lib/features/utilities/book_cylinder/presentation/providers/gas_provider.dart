import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/shared/providers/app_providers.dart';

import '../../data/models/gas_bill.dart';
import '../../data/models/gas_biller.dart';
import '../../data/models/gas_history_item.dart';
import '../../data/models/gas_saved_account.dart';
import '../../data/models/gas_state.dart';
import '../../data/repositories/gas_repository.dart';
import '../../data/services/gas_api_service.dart';

final gasApiServiceProvider = Provider<GasApiService>((ref) {
  return GasApiService();
});

final gasRepositoryProvider = Provider<GasRepository>((ref) {
  return GasRepository(
    ref.watch(gasApiServiceProvider),
    ref.watch(firebaseAuthServiceProvider),
  );
});

final gasStatesProvider = FutureProvider<List<GasState>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(gasRepositoryProvider).getStates();
});

final gasBillersProvider = FutureProvider.family<List<GasBiller>, String>((ref, stateId) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(gasRepositoryProvider).getBillers(stateId);
});

final gasAllBillersProvider = FutureProvider<List<GasBiller>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(gasRepositoryProvider).getBillers('');
});

final gasHistoryProvider = FutureProvider<List<GasHistoryItem>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(gasRepositoryProvider).getHistory();
});

final gasSavedAccountsProvider = FutureProvider<List<GasSavedAccount>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(gasRepositoryProvider).getSavedAccounts();
});

final selectedGasStateProvider = StateProvider<GasState?>((ref) => null);
final selectedGasBillerProvider = StateProvider<GasBiller?>((ref) => null);
final gasConsumerNumberProvider = StateProvider<String>((ref) => '');
final fetchedGasBillProvider = StateProvider<GasBill?>((ref) => null);

