import 'dart:convert';

import 'package:http/http.dart' as http;

import '../broadband_api_exceptions.dart';
import '../models/broadband_bill.dart';
import '../models/broadband_biller.dart';
import '../models/broadband_history_item.dart';
import '../models/broadband_saved_account.dart';

/// Marg Broadband/Landline API (`/api/utilities/broadband-landline/*`).
class BroadbandApiService {
  BroadbandApiService({http.Client? httpClient, String? baseUrl})
      : _http = httpClient ?? http.Client(),
        _baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/$'), '');

  static const String _defaultBaseUrl =
      'https://margapi-548031081093.asia-south1.run.app';

  final http.Client _http;
  final String _baseUrl;

  static const String _prefix = '/api/utilities/broadband-landline';

  Map<String, String> _headers(String? idToken) {
    return {
      'Content-Type': 'application/json',
      'accept': '*/*',
      if (idToken != null && idToken.isNotEmpty) 'Authorization': 'Bearer $idToken',
    };
  }

  Map<String, dynamic> _decodeMap(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    throw BroadbandApiException('Invalid response');
  }

  void _ensureSuccess(Map<String, dynamic> decoded) {
    if (decoded['success'] == false) {
      final msg = decoded['message'] ?? decoded['error'];
      throw BroadbandApiException(msg?.toString() ?? 'Request failed');
    }
  }

  Map<String, dynamic> _readJsonResponse(http.Response res) {
    Map<String, dynamic> decoded = {};
    if (res.body.isNotEmpty) {
      try {
        decoded = _decodeMap(res.body);
      } catch (_) {
        if (res.statusCode < 200 || res.statusCode >= 300) {
          throw BroadbandApiException();
        }
        rethrow;
      }
    }
    final httpOk = res.statusCode >= 200 && res.statusCode < 300;
    if (!httpOk) {
      if (decoded.isNotEmpty) {
        _ensureSuccess(decoded);
      }
      throw BroadbandApiException();
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
      for (final key in ['items', 'billers', 'accounts', 'records', 'history']) {
        final nested = data[key];
        if (nested is List) return nested;
      }
    }
    for (final key in ['items', 'billers', 'accounts']) {
      final top = decoded[key];
      if (top is List) return top;
    }
    return const [];
  }

  Future<List<BroadbandBiller>> getBillers({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl$_prefix/billers');
        final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    final raw = _dataList(decoded);
    final out = <BroadbandBiller>[];
    for (final e in raw) {
      if (e is! Map) continue;
      try {
        out.add(BroadbandBiller.fromApiJson(Map<String, dynamic>.from(e)));
      } catch (_) {}
    }
    return out;
  }

  Future<BroadbandBill> fetchBill(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl$_prefix/fetch-bill');
        final res = await _http.post(uri, headers: _headers(idToken), body: jsonEncode(body));
    final decoded = _readJsonResponse(res);
    return BroadbandBill.fromApiJson(_dataMap(decoded));
  }

  Future<Map<String, dynamic>> pay(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl$_prefix/pay');
        final res = await _http.post(uri, headers: _headers(idToken), body: jsonEncode(body));
    final decoded = _readJsonResponse(res);
    return _dataMap(decoded);
  }

  Future<Map<String, dynamic>> getPaymentStatus(
    String id, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl$_prefix/status/${Uri.encodeComponent(id)}');
        final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    return _dataMap(decoded);
  }

  Future<List<BroadbandHistoryItem>> getHistory({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl$_prefix/history');
        final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    final raw = _dataList(decoded);
    final out = <BroadbandHistoryItem>[];
    for (final e in raw) {
      if (e is! Map) continue;
      try {
        out.add(BroadbandHistoryItem.fromApiJson(Map<String, dynamic>.from(e)));
      } catch (_) {}
    }
    return out;
  }

  Future<List<BroadbandSavedAccount>> getAccounts({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl$_prefix/accounts');
        final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    final raw = _dataList(decoded);
    final out = <BroadbandSavedAccount>[];
    for (final e in raw) {
      if (e is! Map) continue;
      try {
        out.add(BroadbandSavedAccount.fromApiJson(Map<String, dynamic>.from(e)));
      } catch (_) {}
    }
    return out;
  }

  Future<BroadbandSavedAccount> createAccount(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl$_prefix/accounts');
        final res = await _http.post(uri, headers: _headers(idToken), body: jsonEncode(body));
    final decoded = _readJsonResponse(res);
    return BroadbandSavedAccount.fromApiJson(_dataMap(decoded));
  }

  Future<BroadbandSavedAccount> updateAccount(
    String id,
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl$_prefix/accounts/${Uri.encodeComponent(id)}');
        final res = await _http.put(uri, headers: _headers(idToken), body: jsonEncode(body));
    final decoded = _readJsonResponse(res);
    return BroadbandSavedAccount.fromApiJson(_dataMap(decoded));
  }

  Future<void> deleteAccount(String id, {String? idToken}) async {
    final uri = Uri.parse('$_baseUrl$_prefix/accounts/${Uri.encodeComponent(id)}');
        final res = await _http.delete(uri, headers: _headers(idToken));
    if (res.body.isEmpty) {
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw BroadbandApiException();
      }
      return;
    }
    _readJsonResponse(res);
  }
}
