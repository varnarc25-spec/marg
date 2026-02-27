import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/credit_card_model.dart';
import '../../data/repositories/credit_card_repository.dart';

final creditCardRepositoryProvider = Provider<CreditCardRepository>((ref) => CreditCardRepository());
final creditCardsProvider = FutureProvider<List<CreditCardModel>>((ref) => ref.read(creditCardRepositoryProvider).getCards());
final selectedCreditCardProvider = StateProvider<CreditCardModel?>((ref) => null);
