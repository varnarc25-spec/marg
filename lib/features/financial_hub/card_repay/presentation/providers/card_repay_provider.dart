import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/shared/providers/app_providers.dart';

import '../../data/models/card_repay_bill.dart';
import '../../data/models/card_repay_biller.dart';
import '../../data/models/card_repay_history_item.dart';
import '../../data/models/card_repay_saved_account.dart';
import '../../data/repositories/card_repay_repository.dart';
import '../../data/services/card_repay_api_service.dart';

final cardRepayApiServiceProvider = Provider<CardRepayApiService>((ref) {
  return CardRepayApiService();
});

final cardRepayRepositoryProvider = Provider<CardRepayRepository>((ref) {
  return CardRepayRepository(
    ref.watch(cardRepayApiServiceProvider),
    ref.watch(firebaseAuthServiceProvider),
  );
});

final cardRepayBillersProvider = FutureProvider<List<CardRepayBiller>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(cardRepayRepositoryProvider).getBillers();
});

final cardRepayHistoryProvider = FutureProvider<List<CardRepayHistoryItem>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(cardRepayRepositoryProvider).getHistory();
});

final cardRepaySavedAccountsProvider =
    FutureProvider<List<CardRepaySavedAccount>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(cardRepayRepositoryProvider).getSavedAccounts();
});

final selectedCardRepayBillerProvider = StateProvider<CardRepayBiller?>((ref) => null);
final cardRepayConsumerNumberProvider = StateProvider<String>((ref) => '');
final fetchedCardRepayBillProvider = StateProvider<CardRepayBill?>((ref) => null);

/// Selected saved-card account id for the final payment step.
final selectedCardRepaySavedAccountIdProvider =
    StateProvider<String?>((ref) => null);
