import 'package:marg/core/services/firebase_auth_service.dart';

import '../models/electricity_bill.dart';
import '../models/electricity_biller.dart';
import '../models/electricity_history_item.dart';
import '../models/electricity_saved_account.dart';
import '../models/electricity_state.dart';
import '../services/electricity_api_service.dart';

/// Electricity: Marg `/api/utilities/electricity/*`.
class ElectricityRepository {
  ElectricityRepository(this._api, this._auth);

  final ElectricityApiService _api;
  final FirebaseAuthService _auth;

  Future<String?> _token() => _auth.getIdToken(forceRefresh: false);

  Future<List<ElectricityState>> getStates() async {
    return const [
      ElectricityState(id: 'maharashtra', name: 'Maharashtra'),
      ElectricityState(id: 'karnataka', name: 'Karnataka'),
      ElectricityState(id: 'delhi', name: 'Delhi'),
      ElectricityState(id: 'tn', name: 'Tamil Nadu'),
    ];
  }

  Future<List<ElectricityBiller>> getBillers(String stateId) async {
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
  Future<ElectricityBill> fetchBill({
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

  /// POST `/pay` — full body per API contract.
  Future<Map<String, dynamic>> payBill({
    required String billerId,
    required ElectricityBill bill,
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
        'billPeriod': bill.billPeriod.isNotEmpty ? bill.billPeriod : '—',
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

  Future<List<ElectricityHistoryItem>> getHistory() async {
    return _api.getHistory(idToken: await _token());
  }

  Future<List<ElectricitySavedAccount>> getSavedAccounts() async {
    return _api.getAccounts(idToken: await _token());
  }

  /// POST `/accounts`
  Future<ElectricitySavedAccount> createAccount({
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

  Future<ElectricitySavedAccount> updateAccount(
    String id,
    Map<String, dynamic> body,
  ) async {
    return _api.updateAccount(id, body, idToken: await _token());
  }

  Future<void> deleteSavedAccount(String id) async {
    await _api.deleteAccount(id, idToken: await _token());
  }
}
