import '../models/credit_card_model.dart';

/// Credit card bill payment. TODO: Payment gateway & card linking API.
class CreditCardRepository {
  Future<List<CreditCardModel>> getCards() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      CreditCardModel(
        id: '1',
        lastFour: '4242',
        bankName: 'HDFC Bank',
        totalDue: 25000,
        minimumDue: 2500,
        dueDate: DateTime.now().add(const Duration(days: 12)),
      ),
      CreditCardModel(
        id: '2',
        lastFour: '8888',
        bankName: 'ICICI Bank',
        totalDue: 15000,
        minimumDue: 1500,
        dueDate: DateTime.now().add(const Duration(days: 8)),
      ),
    ];
  }

  Future<bool> payBill({required String cardId, required double amount}) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
