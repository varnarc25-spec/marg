import 'package:marg/core/services/firebase_auth_service.dart';

import '../loan_repayment_api_exceptions.dart';
import '../models/loan_repayment_bill.dart';
import '../models/loan_repayment_biller.dart';
import '../models/loan_repayment_history_item.dart';
import '../models/loan_repayment_saved_account.dart';
import '../services/loan_repayment_api_service.dart';

class LoanRepaymentRepository {
  LoanRepaymentRepository(this._api, this._auth);

  final LoanRepaymentApiService _api;
  final FirebaseAuthService _auth;

  Future<String?> _token() => _auth.getIdToken(forceRefresh: true);

  Future<List<LoanRepaymentBiller>> getBillers() async {
    return _api.getBillers(idToken: await _token());
  }

  Future<LoanRepaymentBill> fetchBill({
    required String billerId,
    required String consumerNumber,
  }) async {
    final bill = await _api.fetchBill(
      {
        'billerId': billerId,
        'consumerNumber': consumerNumber,
      },
      idToken: await _token(),
    );
    if (bill.consumerNumber.trim().isEmpty || bill.amount <= 0) {
      throw LoanRepaymentApiException('Data not available or invalid details');
    }
    return bill;
  }

  Future<Map<String, dynamic>> payBill({
    required String billerId,
    required LoanRepaymentBill bill,
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
        'amount': amount,
        'consumerName': bill.consumerName,
        'dueDate': dueStr,
        'billPeriod': bill.billPeriod,
        'billDate': billDateStr,
        'lateFee': bill.lateFee,
        'convenienceFee': bill.convenienceFee,
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

  Future<List<LoanRepaymentHistoryItem>> getHistory() async {
    return _api.getHistory(idToken: await _token());
  }

  Future<List<LoanRepaymentSavedAccount>> getSavedAccounts() async {
    return _api.getAccounts(idToken: await _token());
  }

  Future<LoanRepaymentSavedAccount> createAccount({
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

  Future<LoanRepaymentSavedAccount> updateAccount({
    required String accountId,
    required String label,
    required String consumerName,
    bool? isAutopay,
  }) async {
    return _api.updateAccount(
      accountId,
      {
        'label': label,
        'consumerName': consumerName,
        if (isAutopay != null) 'isAutopay': isAutopay,
      },
      idToken: await _token(),
    );
  }

  Future<void> deleteSavedAccount(String id) async {
    await _api.deleteAccount(id, idToken: await _token());
  }
}
