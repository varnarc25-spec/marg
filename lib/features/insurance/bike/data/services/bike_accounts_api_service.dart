import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;

import '../models/bike_saved_account_model.dart';

/// Client for bike insurance saved payment accounts.
class BikeAccountsApiService {
  BikeAccountsApiService({
    http.Client? httpClient,
    String? baseUrl,
  })  : _http = httpClient ?? http.Client(),
        _baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/$'), '');

  static const String _defaultBaseUrl =
      'https://margapi-548031081093.asia-south1.run.app';

  final http.Client _http;
  final String _baseUrl;

  /// GET `/api/insurance/bike/accounts`
  Future<List<BikeSavedAccount>> fetchSavedAccounts({
    required String idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/bike/accounts');
    debugPrint('BikeAccountsApi GET $uri');

    final res = await _http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to load bike accounts (${res.statusCode})');
    }

    final decoded = jsonDecode(res.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid accounts response');
    }

    // Match bike billers/history: only fail on explicit `success: false`.
    if (decoded['success'] == false) {
      final err = decoded['error'];
      final message = err is Map ? err['message']?.toString() : err?.toString();
      throw Exception(message ?? 'Failed to load bike accounts');
    }

    final data = decoded['data'];
    if (data is! List) return const [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(BikeSavedAccount.fromJson)
        .toList();
  }

  /// POST `/api/insurance/bike/accounts`
  Future<BikeSavedAccount> createSavedAccount({
    required String idToken,
    required Map<String, dynamic> payload,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/bike/accounts');
    debugPrint('BikeAccountsApi POST $uri payload=$payload');

    final res = await _http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode(payload),
    );

    final decoded = _decodeAndValidate(res);
    final data = decoded['data'];
    if (data is Map<String, dynamic>) {
      return BikeSavedAccount.fromJson(data);
    }

    // Fallback: some backends may return the created object at root.
    if (decoded['success'] == true) {
      final maybeAccount = decoded;
      if (maybeAccount.containsKey('accountType') ||
          maybeAccount.containsKey('id')) {
        return BikeSavedAccount.fromJson(maybeAccount);
      }
    }

    throw Exception('Invalid create account response');
  }

  /// PUT `/api/insurance/bike/accounts/{id}`
  Future<BikeSavedAccount> updateSavedAccount({
    required String idToken,
    required String id,
    required Map<String, dynamic> payload,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/bike/accounts/$id');
    debugPrint('BikeAccountsApi PUT $uri payload=$payload');

    final res = await _http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode(payload),
    );

    final decoded = _decodeAndValidate(res);
    final data = decoded['data'];
    if (data is Map<String, dynamic>) {
      return BikeSavedAccount.fromJson(data);
    }

    if (decoded['success'] == true) {
      final maybeAccount = decoded;
      if (maybeAccount.containsKey('accountType') ||
          maybeAccount.containsKey('id')) {
        return BikeSavedAccount.fromJson(maybeAccount);
      }
    }

    throw Exception('Invalid update account response');
  }

  /// DELETE `/api/insurance/bike/accounts/{id}`
  Future<void> deleteSavedAccount({
    required String idToken,
    required String id,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/bike/accounts/$id');
    debugPrint('BikeAccountsApi DELETE $uri');

    final res = await _http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );

    _decodeAndValidate(res);
  }

  Map<String, dynamic> _decodeAndValidate(http.Response res) {
    final body = res.body;
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request failed (${res.statusCode}): ${body.isEmpty ? '<empty>' : body}');
    }
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid server response');
    }

    final success = decoded['success'] as bool?;
    if (success == false) {
      final err = decoded['error'];
      final message = err is Map ? err['message']?.toString() : err?.toString();
      throw Exception(message ?? decoded['message']?.toString() ?? 'Request failed');
    }
    return decoded;
  }
}

