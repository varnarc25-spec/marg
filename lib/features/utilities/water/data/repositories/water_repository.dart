import 'package:marg/core/services/firebase_auth_service.dart';

import '../models/water_bill.dart';
import '../models/water_biller.dart';
import '../models/water_history_item.dart';
import '../models/water_saved_account.dart';
import '../models/water_state.dart';
import '../services/water_api_service.dart';

/// Water: Marg `/api/utilities/water/*`.
class WaterRepository {
  WaterRepository(this._api, this._auth);

  final WaterApiService _api;
  final FirebaseAuthService _auth;

  Future<String?> _token() => _auth.getIdToken(forceRefresh: false);

  Future<List<WaterState>> getStates() async {
    return const [
      WaterState(id: 'maharashtra', name: 'Maharashtra'),
      WaterState(id: 'karnataka', name: 'Karnataka'),
      WaterState(id: 'delhi', name: 'Delhi'),
      WaterState(id: 'tn', name: 'Tamil Nadu'),
    ];
  }

  Future<List<WaterBiller>> getBillers(String stateId) async {
    final all = await _api.getBillers(idToken: await _token());
    final normalized = stateId.toLowerCase().trim();
    final filtered = all.where((b) {
      final sid = b.stateId.toLowerCase().trim();
      if (sid.isEmpty) return true;
      return sid == normalized ||
          sid.contains(normalized) ||
          normalized.contains(sid);
    }).toList();
    return filtered.isEmpty ? all : filtered;
  }

  /// POST `/fetch-bill` — `{ billerId, consumerNumber }`.
  Future<WaterBill> fetchBill({
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

  /// POST `/pay`
  Future<Map<String, dynamic>> payBill({
    required String billerId,
    required WaterBill bill,
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
        'convenienceFee': bill.convenienceFee % 1 == 0
            ? bill.convenienceFee.toInt()
            : bill.convenienceFee,
        'billDetails': bill.billDetails,
        'paymentMode': paymentMode,
        'accountId': accountId,
      },
      idToken: await _token(),
    );
  }

  Future<Map<String, dynamic>> getPaymentStatus(String id) async {
    return _api.getPaymentStatus(id, idToken: await _token());
  }

  Future<List<WaterHistoryItem>> getHistory() async {
    return _api.getHistory(idToken: await _token());
  }

  Future<List<WaterSavedAccount>> getSavedAccounts() async {
    return _api.getAccounts(idToken: await _token());
  }

  Future<WaterSavedAccount> createAccount({
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

  Future<WaterSavedAccount> updateAccount(
    String id,
    Map<String, dynamic> body,
  ) async {
    return _api.updateAccount(id, body, idToken: await _token());
  }

  Future<void> deleteSavedAccount(String id) async {
    await _api.deleteAccount(id, idToken: await _token());
  }
}
