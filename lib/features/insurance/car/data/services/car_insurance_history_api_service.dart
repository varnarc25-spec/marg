import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/car_payment_history_item.dart';

/// Client for car insurance payment history.
class CarInsuranceHistoryApiService {
  CarInsuranceHistoryApiService({
    http.Client? httpClient,
    String? baseUrl,
  })  : _http = httpClient ?? http.Client(),
        _baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/$'), '');

  static const String _defaultBaseUrl =
      'https://margapi-548031081093.asia-south1.run.app';

  final http.Client _http;
  final String _baseUrl;

  /// GET `/api/insurance/car/history?limit=<limit>&offset=<offset>`
  Future<List<CarPaymentHistoryItem>> fetchPaymentHistory({
    required String idToken,
    int limit = 10,
    int offset = 0,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/api/insurance/car/history?limit=$limit&offset=$offset',
    );
    
    final res = await _http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to load car payment history (${res.statusCode})');
    }

    final decoded = jsonDecode(res.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid car payment history response');
    }

    if (decoded['success'] == false) {
      final err = decoded['error'];
      final message = err is Map
          ? err['message']?.toString()
          : err?.toString();
      throw Exception(message ?? 'Failed to load car payment history');
    }

    final data = decoded['data'];
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(CarPaymentHistoryItem.fromJson)
          .toList();
    }

    if (data is Map<String, dynamic>) {
      final items = data['items'];
      if (items is List) {
        return items
            .whereType<Map<String, dynamic>>()
            .map(CarPaymentHistoryItem.fromJson)
            .toList();
      }
    }

    // Some backends might return payments directly under `items` at root.
    final rootItems = decoded['items'];
    if (rootItems is List) {
      return rootItems
          .whereType<Map<String, dynamic>>()
          .map(CarPaymentHistoryItem.fromJson)
          .toList();
    }

    return const [];
  }
}

