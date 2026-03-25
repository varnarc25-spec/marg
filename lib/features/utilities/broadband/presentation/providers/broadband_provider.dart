import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/shared/providers/app_providers.dart';

import '../../data/models/broadband_bill.dart';
import '../../data/models/broadband_biller.dart';
import '../../data/models/broadband_history_item.dart';
import '../../data/models/broadband_saved_account.dart';
import '../../data/models/broadband_state.dart';
import '../../data/repositories/broadband_repository.dart';
import '../../data/services/broadband_api_service.dart';

final broadbandApiServiceProvider = Provider<BroadbandApiService>((ref) {
  return BroadbandApiService();
});

final broadbandRepositoryProvider = Provider<BroadbandRepository>((ref) {
  return BroadbandRepository(
    ref.watch(broadbandApiServiceProvider),
    ref.watch(firebaseAuthServiceProvider),
  );
});

final broadbandStatesProvider = FutureProvider<List<BroadbandState>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(broadbandRepositoryProvider).getStates();
});

final broadbandBillersProvider =
    FutureProvider.family<List<BroadbandBiller>, String>((ref, stateId) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(broadbandRepositoryProvider).getBillers(stateId);
});

final broadbandAllBillersProvider = FutureProvider<List<BroadbandBiller>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(broadbandRepositoryProvider).getBillers('');
});

final broadbandHistoryProvider = FutureProvider<List<BroadbandHistoryItem>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(broadbandRepositoryProvider).getHistory();
});

final broadbandSavedAccountsProvider =
    FutureProvider<List<BroadbandSavedAccount>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(broadbandRepositoryProvider).getSavedAccounts();
});

final selectedBroadbandStateProvider = StateProvider<BroadbandState?>((ref) => null);
final selectedBroadbandBillerProvider = StateProvider<BroadbandBiller?>((ref) => null);
final broadbandConsumerNumberProvider = StateProvider<String>((ref) => '');
final fetchedBroadbandBillProvider = StateProvider<BroadbandBill?>((ref) => null);
