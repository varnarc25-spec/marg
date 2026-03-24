import 'package:marg/core/services/firebase_auth_service.dart';

import '../models/fastag_auto_recharge_rule.dart';
import '../models/fastag_recharge_history_item.dart';
import '../models/fastag_toll_transaction.dart';
import '../models/vehicle_model.dart';
import '../services/fastag_api_service.dart';

/// FASTag: Marg `/api/recharges/fastag/*`.
class FastagRepository {
  FastagRepository(this._api, this._auth);

  final FastagApiService _api;
  final FirebaseAuthService _auth;

  Future<String?> _token() => _auth.getIdToken(forceRefresh: false);

  Future<List<VehicleModel>> getVehicles() async {
    return _api.listVehicles(idToken: await _token());
  }

  /// `POST /vehicles` — body per API contract.
  Future<VehicleModel> addVehicle({
    required String vehicleNumber,
    required String tagId,
    required String vehicleType,
    required String label,
    required String issuerBank,
    required bool isPrimary,
  }) async {
    return _api.createVehicle(
      {
        'vehicleNumber': vehicleNumber,
        'tagId': tagId,
        'vehicleType': vehicleType,
        'label': label,
        'issuerBank': issuerBank,
        'isPrimary': isPrimary,
      },
      idToken: await _token(),
    );
  }

  Future<VehicleModel> getVehicle(String id) async {
    return _api.getVehicle(id, idToken: await _token());
  }

  Future<VehicleModel> updateVehicle(
    String id,
    Map<String, dynamic> body,
  ) async {
    return _api.updateVehicle(id, body, idToken: await _token());
  }

  Future<void> deleteVehicle(String id) async {
    await _api.deleteVehicle(id, idToken: await _token());
  }

  /// `POST /recharge` — `{ "vehicleId", "amount" }`.
  Future<Map<String, dynamic>> initiateRecharge({
    required String vehicleId,
    required num amount,
  }) async {
    final normalized = amount % 1 == 0 ? amount.toInt() : amount;
    return _api.initiateRecharge(
      {
        'vehicleId': vehicleId,
        'amount': normalized,
      },
      idToken: await _token(),
    );
  }

  Future<Map<String, dynamic>> getRechargeStatus(String id) async {
    return _api.getRechargeStatus(id, idToken: await _token());
  }

  Future<List<FastagRechargeHistoryItem>> getRechargeHistory() async {
    return _api.getRechargeHistory(idToken: await _token());
  }

  Future<List<FastagTollTransaction>> getTollHistory(String vehicleId) async {
    return _api.getTollHistory(vehicleId, idToken: await _token());
  }

  Future<FastagAutoRechargeRule> getAutoRechargeRule(String vehicleId) async {
    return _api.getAutoRechargeRule(vehicleId, idToken: await _token());
  }

  Future<FastagAutoRechargeRule> setAutoRechargeRule(
    String vehicleId,
    FastagAutoRechargeRule rule,
  ) async {
    return _api.setAutoRechargeRule(
      vehicleId,
      rule.toApiBody(),
      idToken: await _token(),
    );
  }

  Future<FastagAutoRechargeRule> setAutoRechargeRaw(
    String vehicleId,
    Map<String, dynamic> body,
  ) async {
    return _api.setAutoRechargeRule(
      vehicleId,
      body,
      idToken: await _token(),
    );
  }
}
