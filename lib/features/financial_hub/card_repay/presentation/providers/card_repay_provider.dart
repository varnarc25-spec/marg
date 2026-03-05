import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/card_repay_data.dart';

/// In-memory list of saved credit cards for Pay Credit Card Bill flow.
final savedCreditCardsProvider =
    StateNotifierProvider<SavedCreditCardsNotifier, List<SavedCreditCard>>((ref) {
  return SavedCreditCardsNotifier();
});

class SavedCreditCardsNotifier extends StateNotifier<List<SavedCreditCard>> {
  SavedCreditCardsNotifier()
      : super([
          const SavedCreditCard(
            bankName: 'HDFC Bank',
            lastFourDigits: '7791',
            network: 'Mastercard',
          ),
        ]);

  void add(SavedCreditCard card) {
    state = [...state, card];
  }

  void remove(SavedCreditCard card) {
    state = state.where((c) => c != card).toList();
  }
}
