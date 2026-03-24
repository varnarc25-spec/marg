import 'package:marg/core/services/firebase_auth_service.dart';

import '../models/dth_operator.dart';
import '../models/dth_plan.dart';
import '../models/dth_recharge_history_item.dart';
import '../models/dth_saved_account.dart';
import '../services/dth_api_service.dart';

/// DTH recharge: Marg `/api/recharges/dth/*` APIs.
class DthRechargeRepository {
  DthRechargeRepository(this._api, this._auth);

  final DthApiService _api;
  final FirebaseAuthService _auth;

  Future<String?> _token() => _auth.getIdToken(forceRefresh: false);

  Future<List<DthOperator>> getOperators() async {
    return _api.getOperators(idToken: await _token());
  }

  /// `POST /plans` body: `{ "operatorId": "tataplay" }` only.
  Future<List<DthPlan>> fetchPlans({required String operatorId}) async {
    return _api.postPlans(
      {'operatorId': operatorId},
      idToken: await _token(),
    );
  }

  /// `POST /initiate` — full plan + subscriber fields.
  Future<Map<String, dynamic>> initiateRecharge({
    required String operatorId,
    required String subscriberId,
    required DthPlan plan,
  }) async {
    final planType =
        plan.planType.trim().isNotEmpty ? plan.planType.trim() : 'DTH';
    return _api.initiate(
      {
        'subscriberId': subscriberId,
        'operatorId': operatorId,
        'amount': plan.amount,
        'planId': plan.id,
        'planName': plan.name,
        'planType': planType,
        'validity': plan.validity,
      },
      idToken: await _token(),
    );
  }

  Future<Map<String, dynamic>> getRechargeStatus(String id) async {
    return _api.getStatus(id, idToken: await _token());
  }

  Future<List<DthRechargeHistoryItem>> getHistory() async {
    return _api.getHistory(idToken: await _token());
  }

  Future<List<DthSavedAccount>> getSavedAccounts() async {
    return _api.getSavedAccounts(idToken: await _token());
  }

  Future<void> deleteSavedAccount(String id) async {
    await _api.deleteSavedAccount(id, idToken: await _token());
  }

  /// `POST /saved-accounts` body.
  Future<DthSavedAccount> saveAccount({
    required String subscriberId,
    required String label,
    required String operatorCode,
    required String operatorName,
    bool isPrimary = false,
  }) async {
    return _api.postSavedAccount(
      {
        'subscriberId': subscriberId,
        'label': label,
        'operatorCode': operatorCode,
        'operatorName': operatorName,
        'isPrimary': isPrimary,
      },
      idToken: await _token(),
    );
  }
}
