import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/dth_operator.dart';
import '../models/dth_plan.dart';
import '../models/dth_recharge_history_item.dart';
import '../models/dth_saved_account.dart';

/// Marg DTH recharge API (`/api/recharges/dth/*`).
class DthApiService {
  DthApiService({http.Client? httpClient, String? baseUrl})
    : _http = httpClient ?? http.Client(),
      _baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/$'), '');

  static const String _defaultBaseUrl =
      'https://marg-api-548031081093.asia-south1.run.app';

  final http.Client _http;
  final String _baseUrl;

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
    // Only treat explicit `success: false` as failure (many endpoints omit `success`).
    if (decoded['success'] == false) {
      final err = decoded['error'] ?? decoded['message'];
      throw Exception(err?.toString() ?? 'Request failed');
    }
  }

  List<dynamic> _dataList(Map<String, dynamic> decoded) {
    final data = decoded['data'];
    if (data is List) return data;
    if (data is Map) {
      for (final key in [
        'items',
        'accounts',
        'records',
        'operators',
        'plans',
      ]) {
        final nested = data[key];
        if (nested is List) return nested;
      }
    }
    for (final key in ['items', 'operators', 'plans', 'records']) {
      final top = decoded[key];
      if (top is List) return top;
    }
    return const [];
  }

  /// GET `/api/recharges/dth/operators`
  Future<List<DthOperator>> getOperators({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl/api/recharges/dth/operators');
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to load operators (${res.statusCode})');
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final raw = _dataList(decoded);
    final out = <DthOperator>[];
    for (final e in raw) {
      if (e is! Map) continue;
      final m = Map<String, dynamic>.from(e);
      try {
        out.add(DthOperator.fromJson(m));
      } catch (_) {}
    }
    return out;
  }

  /// POST `/api/recharges/dth/plans`
  Future<List<DthPlan>> postPlans(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/recharges/dth/plans');
    final res = await _http.post(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to load plans (${res.statusCode})');
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final raw = _dataList(decoded);
    final out = <DthPlan>[];
    for (final e in raw) {
      if (e is! Map) continue;
      try {
        out.add(DthPlan.fromJson(Map<String, dynamic>.from(e)));
      } catch (_) {}
    }
    return out;
  }

  /// POST `/api/recharges/dth/initiate`
  Future<Map<String, dynamic>> initiate(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/recharges/dth/initiate');
    final res = await _http.post(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Initiate failed (${res.statusCode})');
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final data = decoded['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return decoded;
  }

  /// GET `/api/recharges/dth/status/{id}`
  Future<Map<String, dynamic>> getStatus(String id, {String? idToken}) async {
    final uri = Uri.parse(
      '$_baseUrl/api/recharges/dth/status/${Uri.encodeComponent(id)}',
    );
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Status failed (${res.statusCode})');
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final data = decoded['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return decoded;
  }

  /// GET `/api/recharges/dth/history`
  Future<List<DthRechargeHistoryItem>> getHistory({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl/api/recharges/dth/history');
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to load history (${res.statusCode})');
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final raw = _dataList(decoded);
    final out = <DthRechargeHistoryItem>[];
    for (final e in raw) {
      if (e is! Map) continue;
      try {
        out.add(
          DthRechargeHistoryItem.fromApiJson(Map<String, dynamic>.from(e)),
        );
      } catch (_) {}
    }
    return out;
  }

  /// GET `/api/recharges/dth/saved-accounts`
  Future<List<DthSavedAccount>> getSavedAccounts({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl/api/recharges/dth/saved-accounts');
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to load saved accounts (${res.statusCode})');
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final raw = _dataList(decoded);
    final out = <DthSavedAccount>[];
    for (final e in raw) {
      if (e is! Map) continue;
      try {
        out.add(DthSavedAccount.fromJson(Map<String, dynamic>.from(e)));
      } catch (_) {}
    }
    return out;
  }

  /// POST `/api/recharges/dth/saved-accounts`
  Future<DthSavedAccount> postSavedAccount(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/recharges/dth/saved-accounts');
    final res = await _http.post(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Save account failed (${res.statusCode})');
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final data = decoded['data'];
    if (data is Map) {
      return DthSavedAccount.fromJson(Map<String, dynamic>.from(data));
    }
    return DthSavedAccount.fromJson(decoded);
  }

  /// PUT `/api/recharges/dth/saved-accounts/{id}`
  Future<DthSavedAccount> putSavedAccount(
    String id,
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/api/recharges/dth/saved-accounts/${Uri.encodeComponent(id)}',
    );
    final res = await _http.put(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Update account failed (${res.statusCode})');
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final data = decoded['data'];
    if (data is Map) {
      return DthSavedAccount.fromJson(Map<String, dynamic>.from(data));
    }
    return DthSavedAccount.fromJson(decoded);
  }

  /// DELETE `/api/recharges/dth/saved-accounts/{id}`
  Future<void> deleteSavedAccount(String id, {String? idToken}) async {
    final uri = Uri.parse(
      '$_baseUrl/api/recharges/dth/saved-accounts/${Uri.encodeComponent(id)}',
    );
    final res = await _http.delete(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Delete failed (${res.statusCode})');
    }
    if (res.body.isEmpty) return;
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
  }
}
