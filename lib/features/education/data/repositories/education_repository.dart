import '../models/education_institution.dart';
import '../models/education_bill.dart';
import '../models/education_biller.dart';
import '../models/education_history_item.dart';
import '../models/education_saved_account.dart';
import '../models/education_state.dart';
import '../services/education_api_service.dart';
import '../../../../core/services/firebase_auth_service.dart';

/// Education fees. TODO: BBPS/education biller API.
class EducationRepository {
  EducationRepository([EducationApiService? api, FirebaseAuthService? auth])
      : _api = api ?? EducationApiService(),
        _auth = auth ?? FirebaseAuthService();

  final EducationApiService _api;
  final FirebaseAuthService _auth;

  Future<String?> _token() => _auth.getIdToken(forceRefresh: true);

  Future<List<EducationState>> getStates() async {
    return const [
      EducationState(id: 'maharashtra', name: 'Maharashtra'),
      EducationState(id: 'karnataka', name: 'Karnataka'),
      EducationState(id: 'delhi', name: 'Delhi'),
      EducationState(id: 'tn', name: 'Tamil Nadu'),
    ];
  }

  Future<List<EducationBiller>> getBillers(String stateId) async {
    final all = await _api.getBillers(idToken: await _token());
    final normalized = stateId.toLowerCase().trim();
    final filtered = all.where((b) {
      final sid = b.stateId.toLowerCase().trim();
      if (sid.isEmpty) return true;
      return sid == normalized || sid.contains(normalized) || normalized.contains(sid);
    }).toList();
    return filtered.isEmpty ? all : filtered;
  }

  Future<EducationBill> fetchBill({
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
    required EducationBill bill,
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

  Future<List<EducationHistoryItem>> getHistory() async {
    return _api.getHistory(idToken: await _token());
  }

  Future<List<EducationSavedAccount>> getSavedAccounts() async {
    return _api.getAccounts(idToken: await _token());
  }

  Future<EducationSavedAccount> createAccount({
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

  Future<List<EducationInstitution>> searchInstitutions(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      const EducationInstitution(id: '1', name: 'ABC School', type: 'school'),
      const EducationInstitution(id: '2', name: 'XYZ College', type: 'college'),
    ];
  }

  Future<List<Map<String, dynamic>>> getFeeSchedule(String institutionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {'dueDate': '2025-04-01', 'amount': 25000, 'term': 'Q1 Fee'},
      {'dueDate': '2025-07-01', 'amount': 25000, 'term': 'Q2 Fee'},
    ];
  }
}
