import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;

import '../card_repay_api_exceptions.dart';
import '../models/card_repay_bill.dart';
import '../models/card_repay_biller.dart';
import '../models/card_repay_history_item.dart';
import '../models/card_repay_saved_account.dart';

class CardRepayApiService {
  CardRepayApiService({http.Client? httpClient, String? baseUrl})
      : _http = httpClient ?? http.Client(),
        _baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/$'), '');

  static const String _defaultBaseUrl =
      'https://margapi-548031081093.asia-south1.run.app';
  static const String _prefix = '/api/utilities/credit-card';

  final http.Client _http;
  final String _baseUrl;

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
    throw CardRepayApiException('Invalid response');
  }

  void _ensureSuccess(Map<String, dynamic> decoded) {
    if (decoded['success'] == false) {
      final msg = decoded['message'] ?? decoded['error'];
      throw CardRepayApiException(msg?.toString() ?? 'Request failed');
    }
  }

  Map<String, dynamic> _readJsonResponse(http.Response res) {
    Map<String, dynamic> decoded = {};
    if (res.body.isNotEmpty) {
      try {
        decoded = _decodeMap(res.body);
      } catch (_) {
        if (res.statusCode < 200 || res.statusCode >= 300) {
          throw CardRepayApiException();
        }
        rethrow;
      }
    }
    final httpOk = res.statusCode >= 200 && res.statusCode < 300;
    if (!httpOk) {
      if (decoded.isNotEmpty) _ensureSuccess(decoded);
      throw CardRepayApiException();
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

  Future<List<CardRepayBiller>> getBillers({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl$_prefix/billers');
    debugPrint('CardRepayApi GET $uri');
    final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    final raw = _dataList(decoded);
    return raw
        .whereType<Map>()
        .map((e) => CardRepayBiller.fromApiJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<CardRepayBill> fetchBill(Map<String, dynamic> body, {String? idToken}) async {
    final uri = Uri.parse('$_baseUrl$_prefix/fetch-bill');
    debugPrint('CardRepayApi POST $uri');
    final res = await _http.post(uri, headers: _headers(idToken), body: jsonEncode(body));
    final decoded = _readJsonResponse(res);
    return CardRepayBill.fromApiJson(_dataMap(decoded));
  }

  Future<Map<String, dynamic>> pay(Map<String, dynamic> body, {String? idToken}) async {
    final uri = Uri.parse('$_baseUrl$_prefix/pay');
    debugPrint('CardRepayApi POST $uri');
    final res = await _http.post(uri, headers: _headers(idToken), body: jsonEncode(body));
    final decoded = _readJsonResponse(res);
    return _dataMap(decoded);
  }

  Future<Map<String, dynamic>> getPaymentStatus(String id, {String? idToken}) async {
    final uri = Uri.parse('$_baseUrl$_prefix/status/${Uri.encodeComponent(id)}');
    debugPrint('CardRepayApi GET $uri');
    final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    return _dataMap(decoded);
  }

  Future<List<CardRepayHistoryItem>> getHistory({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl$_prefix/history');
    debugPrint('CardRepayApi GET $uri');
    final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    final raw = _dataList(decoded);
    return raw
        .whereType<Map>()
        .map((e) => CardRepayHistoryItem.fromApiJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<CardRepaySavedAccount>> getAccounts({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl$_prefix/accounts');
    debugPrint('CardRepayApi GET $uri');
    final res = await _http.get(uri, headers: _headers(idToken));
    final decoded = _readJsonResponse(res);
    final raw = _dataList(decoded);
    return raw
        .whereType<Map>()
        .map((e) => CardRepaySavedAccount.fromApiJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<CardRepaySavedAccount> createAccount(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl$_prefix/accounts');
    debugPrint('CardRepayApi POST $uri');
    final res = await _http.post(uri, headers: _headers(idToken), body: jsonEncode(body));
    final decoded = _readJsonResponse(res);
    return CardRepaySavedAccount.fromApiJson(_dataMap(decoded));
  }

  Future<void> deleteAccount(String id, {String? idToken}) async {
    final uri = Uri.parse('$_baseUrl$_prefix/accounts/${Uri.encodeComponent(id)}');
    debugPrint('CardRepayApi DELETE $uri');
    final res = await _http.delete(uri, headers: _headers(idToken));
    if (res.body.isEmpty) {
      if (res.statusCode < 200 || res.statusCode >= 300) throw CardRepayApiException();
      return;
    }
    _readJsonResponse(res);
  }
}
