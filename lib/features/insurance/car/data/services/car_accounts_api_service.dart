import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/car_saved_account_model.dart';

/// Client for car insurance saved payment accounts.
class CarAccountsApiService {
  CarAccountsApiService({
    http.Client? httpClient,
    String? baseUrl,
  })  : _http = httpClient ?? http.Client(),
        _baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/$'), '');

  static const String _defaultBaseUrl =
      'https://margapi-548031081093.asia-south1.run.app';

  final http.Client _http;
  final String _baseUrl;

  /// GET `/api/insurance/car/accounts`
  Future<List<CarSavedAccount>> fetchSavedAccounts({
    required String idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/car/accounts');
    
    final res = await _http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to load car accounts (${res.statusCode})');
    }

    final decoded = jsonDecode(res.body);

    if (decoded is! Map<String, dynamic>) {
      // Some backends might return arrays directly.
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(CarSavedAccount.fromJson)
            .toList();
      }
      throw Exception('Invalid accounts response');
    }

    // Only treat explicit `success: false` as failure.
    if (decoded['success'] == false) {
      final err = decoded['error'];
      final message =
          err is Map ? err['message']?.toString() : err?.toString();
      throw Exception(message ?? 'Failed to load car accounts');
    }

    final data = decoded['data'];
    final list = _extractAccountsList(data, decoded);
    if (list.isEmpty) return const [];

    return list
        .whereType<Map<String, dynamic>>()
        .map(CarSavedAccount.fromJson)
        .toList();
  }

  List<dynamic> _extractAccountsList(
    dynamic data,
    Map<String, dynamic> decoded,
  ) {
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      final items = data['items'];
      if (items is List) return items;
    }

    // Fallback keys.
    for (final k in ['items', 'accounts', 'records', 'rows']) {
      final v = decoded[k];
      if (v is List) return v;
    }

    return const [];
  }

  /// POST `/api/insurance/car/accounts`
  Future<CarSavedAccount> createSavedAccount({
    required String idToken,
    required Map<String, dynamic> payload,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/car/accounts');
    
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
      return CarSavedAccount.fromJson(data);
    }

    // Fallback: some backends may return the created object at root.
    if (decoded['success'] == true) {
      final maybeAccount = decoded;
      if (maybeAccount.containsKey('accountType') ||
          maybeAccount.containsKey('id')) {
        return CarSavedAccount.fromJson(maybeAccount);
      }
    }

    throw Exception('Invalid create account response');
  }

  /// PUT `/api/insurance/car/accounts/{id}`
  Future<CarSavedAccount> updateSavedAccount({
    required String idToken,
    required String id,
    required Map<String, dynamic> payload,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/car/accounts/$id');
    
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
      return CarSavedAccount.fromJson(data);
    }

    if (decoded['success'] == true) {
      final maybeAccount = decoded;
      if (maybeAccount.containsKey('accountType') ||
          maybeAccount.containsKey('id')) {
        return CarSavedAccount.fromJson(maybeAccount);
      }
    }

    throw Exception('Invalid update account response');
  }

  /// DELETE `/api/insurance/car/accounts/{id}`
  Future<void> deleteSavedAccount({
    required String idToken,
    required String id,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/car/accounts/$id');
    
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
      throw Exception(
        'Request failed (${res.statusCode}): ${body.isEmpty ? '<empty>' : body}',
      );
    }
    if (body.trim().isEmpty) {
      // Some APIs reply with 201/204 and no body.
      return const <String, dynamic>{'success': true};
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      // Some APIs reply with plain text on success.
      return <String, dynamic>{'success': true, 'message': body};
    }
    if (decoded is! Map<String, dynamic>) {
      // Treat non-map success responses as valid.
      return const <String, dynamic>{'success': true};
    }

    final success = decoded['success'] as bool?;
    if (success == false) {
      final err = decoded['error'];
      final message =
          err is Map ? err['message']?.toString() : err?.toString();
      throw Exception(
        message ?? decoded['message']?.toString() ?? 'Request failed',
      );
    }
    return decoded;
  }
}

