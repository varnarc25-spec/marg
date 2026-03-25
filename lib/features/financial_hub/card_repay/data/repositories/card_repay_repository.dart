import 'package:marg/core/services/firebase_auth_service.dart';

import '../models/card_repay_bill.dart';
import '../models/card_repay_biller.dart';
import '../models/card_repay_history_item.dart';
import '../models/card_repay_saved_account.dart';
import '../services/card_repay_api_service.dart';

class CardRepayRepository {
  CardRepayRepository(this._api, this._auth);

  final CardRepayApiService _api;
  final FirebaseAuthService _auth;

  Future<String?> _token() => _auth.getIdToken(forceRefresh: true);

  Future<List<CardRepayBiller>> getBillers() async {
    return _api.getBillers(idToken: await _token());
  }

  Future<CardRepayBill> fetchBill({
    required String billerId,
    required String consumerNumber,
  }) async {
    return _api.fetchBill(
      {
        'billerId': billerId,
        'consumerNumber': consumerNumber,
      },
      idToken: await _token(),
    );
  }

  Future<Map<String, dynamic>> payBill({
    required String billerId,
    required CardRepayBill bill,
    required String paymentMode,
    required String accountId,
  }) async {
    final dueStr = bill.dueDate.toIso8601String().split('T').first;
    final billDate = bill.billDate ?? bill.dueDate;
    final billDateStr = billDate.toIso8601String().split('T').first;
    final amount = bill.amount;
    return _api.pay(
      {
        'billerId': billerId,
        'consumerNumber': bill.consumerNumber,
        'amount': amount % 1 == 0 ? amount.toInt() : amount,
        'consumerName': bill.consumerName,
        'dueDate': dueStr,
        'billPeriod': bill.billPeriod,
        'billDate': billDateStr,
        'lateFee': bill.lateFee % 1 == 0 ? bill.lateFee.toInt() : bill.lateFee,
        'convenienceFee':
            bill.convenienceFee % 1 == 0 ? bill.convenienceFee.toInt() : bill.convenienceFee,
        'billDetails': bill.billDetails,
        'paymentMode': paymentMode,
        'accountId': accountId,
      },
      idToken: await _token(),
    );
  }

  Future<List<CardRepayHistoryItem>> getHistory() async {
    return _api.getHistory(idToken: await _token());
  }

  Future<List<CardRepaySavedAccount>> getSavedAccounts() async {
    return _api.getAccounts(idToken: await _token());
  }

  Future<CardRepaySavedAccount> createAccount({
    required String accountNumber,
    required String label,
    required String billerId,
    required String billerName,
    required String consumerName,
    bool isAutopay = false,
  }) async {
    return _api.createAccount(
      {
        'accountNumber': accountNumber,
        'label': label,
        'billerId': billerId,
        'billerName': billerName,
        'consumerName': consumerName,
        'isAutopay': isAutopay,
      },
      idToken: await _token(),
    );
  }

  Future<void> deleteSavedAccount(String id) async {
    await _api.deleteAccount(id, idToken: await _token());
  }
}
