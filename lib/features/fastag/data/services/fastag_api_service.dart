import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;

import '../fastag_api_exceptions.dart';
import '../models/fastag_auto_recharge_rule.dart';
import '../models/fastag_recharge_history_item.dart';
import '../models/fastag_toll_transaction.dart';
import '../models/vehicle_model.dart';

/// Marg FASTag API (`/api/recharges/fastag/*`).
class FastagApiService {
  FastagApiService({http.Client? httpClient, String? baseUrl})
      : _http = httpClient ?? http.Client(),
        _baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/$'), '');

  static const String _defaultBaseUrl =
      'https://margapi-548031081093.asia-south1.run.app';

  final http.Client _http;
  final String _baseUrl;

  static const String _prefix = '/api/recharges/fastag';

  Map<String, String> _headers(String? idToken) {
    return {
      'Content-Type': 'application/json',
      'accept': '*/*',
      if (idToken != null && idToken.isNotEmpty)
        'Authorization': 'Bearer $idToken',
    };
  }

  Map<String, dynamic> _decodeMap(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    throw Exception('Invalid JSON response');
  }

  void _ensureSuccess(Map<String, dynamic> decoded) {
    if (decoded['success'] == false) {
      throw FastagApiException();
    }
  }

  /// Enforces HTTP status and `success` flag; on any failure throws [FastagApiException] (UI: "Data Not Found").
  Map<String, dynamic> _readJsonResponse(http.Response res) {
    Map<String, dynamic> decoded = {};
    if (res.body.isNotEmpty) {
      try {
        decoded = _decodeMap(res.body);
      } catch (_) {
        if (res.statusCode < 200 || res.statusCode >= 300) {
          throw FastagApiException();
        }
        rethrow;
      }
    }
    final httpOk = res.statusCode >= 200 && res.statusCode < 300;
    if (!httpOk) {
      if (decoded.isNotEmpty) {
        _ensureSuccess(decoded);
      }
      throw FastagApiException();
    }
    _ensureSuccess(decoded);
    return decoded;
  }

  Map<String, dynamic> _dataMap(Map<String, dynamic> decoded) {
    final data = decoded['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return decoded;
  }

  List<dynamic> _dataList(Map<String, dynamic> decoded) {
    final data = decoded['data'];
    if (data is List) return data;
    if (data is Map) {
      for (final key in ['items', 'vehicles', 'records', 'history']) {
        final nested = data[key];
        if (nested is List) return nested;
      }
    }
    for (final key in ['items', 'vehicles', 'records']) {
      final top = decoded[key];
      if (top is List) return top;
    }
    return const [];
  }

  /// GET `/vehicles` — list user vehicles.
  Future<List<VehicleModel>> listVehicles({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl$_prefix/vehicles');
    debugPrint('FastagApi GET $uri');
    final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    final raw = _dataList(decoded);
    final out = <VehicleModel>[];
    for (final e in raw) {
      if (e is! Map) continue;
      try {
        out.add(VehicleModel.fromApiJson(Map<String, dynamic>.from(e)));
      } catch (_) {}
    }
    return out;
  }

  /// POST `/vehicles` — add vehicle.
  Future<VehicleModel> createVehicle(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl$_prefix/vehicles');
    debugPrint('FastagApi POST $uri');
    final res = await _http.post(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    final decoded = _readJsonResponse(res);
    final m = _dataMap(decoded);
    return VehicleModel.fromApiJson(m);
  }

  /// GET `/vehicles/{id}`.
  Future<VehicleModel> getVehicle(String id, {String? idToken}) async {
    final uri = Uri.parse(
      '$_baseUrl$_prefix/vehicles/${Uri.encodeComponent(id)}',
    );
    debugPrint('FastagApi GET $uri');
    final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    return VehicleModel.fromApiJson(_dataMap(decoded));
  }

  /// PUT `/vehicles/{id}`.
  Future<VehicleModel> updateVehicle(
    String id,
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl$_prefix/vehicles/${Uri.encodeComponent(id)}',
    );
    debugPrint('FastagApi PUT $uri');
    final res = await _http.put(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    final decoded = _readJsonResponse(res);
    return VehicleModel.fromApiJson(_dataMap(decoded));
  }

  /// DELETE `/vehicles/{id}`.
  Future<void> deleteVehicle(String id, {String? idToken}) async {
    final uri = Uri.parse(
      '$_baseUrl$_prefix/vehicles/${Uri.encodeComponent(id)}',
    );
    debugPrint('FastagApi DELETE $uri');
    final res = await _http.delete(uri, headers: _headers(idToken));
    if (res.body.isEmpty) {
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw FastagApiException();
      }
      return;
    }
    _readJsonResponse(res);
  }

  /// POST `/recharge` — initiate FASTag recharge.
  Future<Map<String, dynamic>> initiateRecharge(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl$_prefix/recharge');
    debugPrint('FastagApi POST $uri');
    final res = await _http.post(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    final decoded = _readJsonResponse(res);
    return _dataMap(decoded);
  }

  /// GET `/recharge/status/{id}`.
  Future<Map<String, dynamic>> getRechargeStatus(
    String id, {
    String? idToken,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl$_prefix/recharge/status/${Uri.encodeComponent(id)}',
    );
    debugPrint('FastagApi GET $uri');
    final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    return _dataMap(decoded);
  }

  /// GET `/recharge/history`.
  Future<List<FastagRechargeHistoryItem>> getRechargeHistory({
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl$_prefix/recharge/history');
    debugPrint('FastagApi GET $uri');
    final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    final raw = _dataList(decoded);
    final out = <FastagRechargeHistoryItem>[];
    for (final e in raw) {
      if (e is! Map) continue;
      try {
        out.add(
          FastagRechargeHistoryItem.fromApiJson(
            Map<String, dynamic>.from(e),
          ),
        );
      } catch (_) {}
    }
    return out;
  }

  /// GET `/toll-history/{vehicleId}`.
  Future<List<FastagTollTransaction>> getTollHistory(
    String vehicleId, {
    String? idToken,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl$_prefix/toll-history/${Uri.encodeComponent(vehicleId)}',
    );
    debugPrint('FastagApi GET $uri');
    final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    final raw = _dataList(decoded);
    final out = <FastagTollTransaction>[];
    for (final e in raw) {
      if (e is! Map) continue;
      try {
        out.add(
          FastagTollTransaction.fromApiJson(Map<String, dynamic>.from(e)),
        );
      } catch (_) {}
    }
    return out;
  }

  /// GET `/auto-recharge/{vehicleId}`.
  Future<FastagAutoRechargeRule> getAutoRechargeRule(
    String vehicleId, {
    String? idToken,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl$_prefix/auto-recharge/${Uri.encodeComponent(vehicleId)}',
    );
    debugPrint('FastagApi GET $uri');
    final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    return FastagAutoRechargeRule.fromApiJson(_dataMap(decoded));
  }

  /// PUT `/auto-recharge/{vehicleId}`.
  Future<FastagAutoRechargeRule> setAutoRechargeRule(
    String vehicleId,
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl$_prefix/auto-recharge/${Uri.encodeComponent(vehicleId)}',
    );
    debugPrint('FastagApi PUT $uri');
    final res = await _http.put(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    final decoded = _readJsonResponse(res);
    return FastagAutoRechargeRule.fromApiJson(_dataMap(decoded));
  }
}
