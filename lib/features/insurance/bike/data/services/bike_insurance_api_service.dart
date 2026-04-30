import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/bike_biller_model.dart';
import '../models/bike_payment_history_item.dart';
import '../models/bike_vehicle_model.dart';

class BikeBillResult {
  const BikeBillResult({
    required this.billId,
    required this.amount,
    required this.raw,
  });

  final String billId;
  final int amount;
  final Map<String, dynamic> raw;
}

class BikePayResult {
  const BikePayResult({
    required this.transactionId,
    required this.status,
    required this.amount,
    required this.paymentDate,
    this.paymentMethod,
    required this.raw,
  });

  final String transactionId;
  final String status;
  final int amount;
  final DateTime paymentDate;
  final String? paymentMethod;
  final Map<String, dynamic> raw;
}

/// Marg API client for bike insurance (billers list + optional vehicle lookup).
class BikeInsuranceApiService {
  BikeInsuranceApiService({http.Client? httpClient, String? baseUrl})
    : _http = httpClient ?? http.Client(),
      _baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/$'), '');

  static const String _defaultBaseUrl =
      'https://marg-api-548031081093.asia-south1.run.app';

  final http.Client _http;
  final String _baseUrl;

  /// Normalizes registration: uppercase, no spaces or hyphens.
  static String normalizePlate(String vehicleNumber) {
    return vehicleNumber.trim().toUpperCase().replaceAll(
      RegExp(r'[\s\-]+'),
      '',
    );
  }

  /// GET `/api/insurance/bike/billers`
  Future<List<BikeBiller>> fetchBillers() async {
    final uri = Uri.parse('$_baseUrl/api/insurance/bike/billers');

    final res = await _http.get(
      uri,
      headers: const {'Content-Type': 'application/json'},
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to load insurers (${res.statusCode})');
    }

    final decoded = jsonDecode(res.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid insurers response');
    }

    // Only treat explicit `success: false` as failure. Many APIs omit `success`
    // when returning `{ "data": [...] }`, which previously broke Find Plans.
    if (decoded['success'] == false) {
      final err = decoded['error'];
      final msg = err is Map ? err['message']?.toString() : err?.toString();
      throw Exception(
        msg ?? decoded['message']?.toString() ?? 'Request failed',
      );
    }

    final rowMaps = _extractBillerRowMaps(decoded);
    final out = <BikeBiller>[];
    for (final raw in rowMaps) {
      try {
        final b = BikeBiller.fromJson(raw);
        if (b.name.isNotEmpty) out.add(b);
      } catch (e, st) {}
    }
    return out;
  }

  /// POST `/api/insurance/bike/fetch-bill`
  Future<BikeBillResult> fetchBill({
    required String registrationNumber,
    required String insurerCode,
    required String insurerId,
    required int amount,
    required String idToken,
  }) async {
    final normalized = normalizePlate(registrationNumber);
    final endpoints = [
      Uri.parse('$_baseUrl/api/insurance/bike/fetch-bill'),
      Uri.parse('$_baseUrl/api/insurance/bike/fetchBill'),
    ];

    final payload = <String, dynamic>{
      'registrationNumber': normalized,
      'vehicleNumber': normalized,
      'insurerCode': insurerCode,
      'insurerId': insurerId,
      'amount': amount,
    };

    Map<String, dynamic>? response;
    Object? lastError;
    for (final uri in endpoints) {
      try {
        response = await _postJsonOrNull(uri, payload, idToken: idToken);
        break;
      } catch (e) {
        lastError = e;
        final msg = e.toString().toLowerCase();
        final looksNotFound =
            msg.contains('404') ||
            msg.contains('not found') ||
            msg.contains('route') ||
            msg.contains('no route');

        // Don't mask auth/payload errors by falling back to a variant
        // endpoint. Only retry the next variant when the first one is
        // truly "not found".
        if (!looksNotFound) {
          throw e;
        }
      }
    }
    if (response == null) {
      throw Exception(
        lastError?.toString().replaceFirst('Exception: ', '') ??
            'Unable to fetch bill right now',
      );
    }

    final data = _extractDataMap(response);
    final billId =
        _pickFirstString(data, ['billId', 'bill_id', 'id', 'referenceId']) ??
        'BILL-${DateTime.now().millisecondsSinceEpoch}';

    final amountValue =
        _pickFirstInt(data, ['amount', 'payableAmount']) ?? amount;

    return BikeBillResult(billId: billId, amount: amountValue, raw: response);
  }

  /// POST `/api/insurance/bike/pay`
  Future<BikePayResult> pay({
    required BikeBillResult bill,
    required String registrationNumber,
    required String insurerCode,
    required String billerId,
    required String consumerName,
    required String accountId,
    required String paymentMode,
    required String idToken,
  }) async {
    final normalized = normalizePlate(registrationNumber);
    final uri = Uri.parse('$_baseUrl/api/insurance/bike/pay');

    final billData = _extractDataMap(bill.raw);
    final dueDate = _pickFirstString(billData, [
      'dueDate',
      'due_date',
      'billDueDate',
    ]);
    final billPeriod = _pickFirstString(billData, [
      'billPeriod',
      'bill_period',
      'period',
    ]);
    final billDate = _pickFirstString(billData, [
      'billDate',
      'bill_date',
      'issueDate',
    ]);

    final lateFee = _pickFirstInt(billData, ['lateFee', 'late_fee']) ?? 0;
    final convenienceFee =
        _pickFirstInt(billData, ['convenienceFee', 'convenience_fee']) ?? 0;

    final billDetailsRaw = billData['billDetails'];

    final payload = <String, dynamic>{
      // Fields required by the backend "pay bill" schema
      'billerId': billerId,
      'consumerNumber': normalized,
      'consumerName': consumerName,
      'amount': bill.amount,
      'dueDate': dueDate,
      'billPeriod': billPeriod,
      'billDate': billDate,
      'lateFee': lateFee,
      'convenienceFee': convenienceFee,
      'billDetails': billDetailsRaw is Map<String, dynamic>
          ? billDetailsRaw
          : (billDetailsRaw ?? const <String, dynamic>{}),
      'paymentMode': paymentMode,
      'accountId': accountId,

      // Keep compatibility with older client implementations
      'billId': bill.billId,
      'registrationNumber': normalized,
      'vehicleNumber': normalized,
      'insurerCode': insurerCode,
    }..removeWhere((k, v) => v == null);

    final response = await _postJsonOrNull(uri, payload, idToken: idToken);

    final data = _extractDataMap(response);
    final txnId =
        _pickFirstString(data, [
          'transactionId',
          'transaction_id',
          'txnId',
          'paymentId',
          'id',
        ]) ??
        'TXN-${DateTime.now().millisecondsSinceEpoch}';
    final status =
        _pickFirstString(data, ['status', 'paymentStatus']) ?? 'Success';
    final paidAmount =
        _pickFirstInt(data, ['amount', 'paidAmount']) ?? bill.amount;
    final method = _pickFirstString(data, ['paymentMethod', 'method', 'mode']);

    return BikePayResult(
      transactionId: txnId,
      status: status,
      amount: paidAmount,
      paymentDate: DateTime.now(),
      paymentMethod: method,
      raw: response,
    );
  }

  /// GET `/api/insurance/bike/history?limit=<limit>&offset=<offset>`
  Future<List<BikePaymentHistoryItem>> fetchPaymentHistory({
    required String idToken,
    int limit = 10,
    int offset = 0,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/api/insurance/bike/history?limit=$limit&offset=$offset',
    );

    final res = await _http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to load payment history (${res.statusCode})');
    }

    final decoded = jsonDecode(res.body);

    if (decoded is Map<String, dynamic>) {
      if (decoded['success'] == false) {
        final err = decoded['error'];
        final message = err is Map
            ? err['message']?.toString()
            : err?.toString();
        throw Exception(message ?? 'Failed to load payment history');
      }
    } else if (decoded is! List) {
      throw Exception('Invalid payment history response');
    }

    return _parsePaymentHistoryResponse(decoded);
  }

  /// Tries known vehicle-detail routes. Returns [null] if none succeed
  /// (backend can add a route later without app changes beyond this list).
  Future<BikeVehicleModel?> fetchVehicleDetails(
    String normalizedRegistration,
  ) async {
    final reg = Uri.encodeComponent(normalizedRegistration);
    final candidates = <Uri>[
      Uri.parse('$_baseUrl/api/insurance/bike/vehicle?registration=$reg'),
      Uri.parse('$_baseUrl/api/insurance/bike/vehicle/$normalizedRegistration'),
      Uri.parse('$_baseUrl/api/insurance/bike/lookup?registration=$reg'),
    ];

    for (final uri in candidates) {
      try {
        final res = await _http.get(
          uri,
          headers: const {'Content-Type': 'application/json'},
        );
        if (res.statusCode < 200 || res.statusCode >= 300) {
          continue;
        }
        final decoded = jsonDecode(res.body);
        if (decoded is! Map<String, dynamic>) continue;
        if (decoded['success'] == false) continue;

        final raw = decoded['data'];
        Map<String, dynamic>? data;
        if (raw is Map<String, dynamic>) {
          data = raw;
        } else if (raw is List && raw.isNotEmpty && raw.first is Map) {
          data = Map<String, dynamic>.from(raw.first as Map);
        }
        if (data == null) continue;

        final model = _parseVehiclePayload(data, normalizedRegistration);
        if (model != null) return model;
      } catch (e, st) {}
    }
    return null;
  }

  BikeVehicleModel? _parseVehiclePayload(
    Map<String, dynamic> data,
    String fallbackReg,
  ) {
    final regRaw =
        data['registrationNumber'] ?? data['registration'] ?? fallbackReg;
    final reg = regRaw.toString().trim().toUpperCase().replaceAll(' ', '');
    if (reg.isEmpty) return null;

    String pickString(List<String> keys) {
      for (final k in keys) {
        final v = data[k];
        if (v != null && v.toString().trim().isNotEmpty) {
          return v.toString().trim();
        }
      }
      return '';
    }

    final owner = pickString([
      'ownerName',
      'owner',
      'insuredName',
      'policyHolderName',
    ]);
    final model = pickString([
      'model',
      'modelName',
      'vehicleModel',
      'makeModel',
    ]);

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is int) {
        return DateTime.fromMillisecondsSinceEpoch(v);
      }
      final s = v.toString().trim();
      if (s.isEmpty) return null;
      final iso = DateTime.tryParse(s);
      if (iso != null) return iso;
      final parts = s.split(RegExp(r'[-/]'));
      if (parts.length == 3) {
        final d = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        final y = int.tryParse(parts[2]);
        if (d != null && m != null && y != null) {
          if (y < 100) return DateTime(2000 + y, m, d);
          return DateTime(y, m, d);
        }
      }
      return null;
    }

    final regDate = parseDate(
      data['registrationDate'] ?? data['regDate'] ?? data['registeredOn'],
    );
    final expDate = parseDate(
      data['insuranceExpiry'] ??
          data['policyExpiry'] ??
          data['expiryDate'] ??
          data['insuranceValidTill'],
    );

    if (owner.isEmpty && model.isEmpty && regDate == null && expDate == null) {
      return null;
    }

    return BikeVehicleModel(
      registrationNumber: reg,
      ownerName: owner.isNotEmpty ? owner : '—',
      model: model.isNotEmpty ? model : '—',
      registrationDate: regDate,
      insuranceExpiry: expDate,
    );
  }

  Future<Map<String, dynamic>> _postJsonOrNull(
    Uri uri,
    Map<String, dynamic> payload, {
    required String idToken,
  }) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      };
      final res = await _http.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      final body = res.body;
      final bodyTrunc = body.length > 1000
          ? '${body.substring(0, 1000)}...'
          : body;

      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception(
          _extractServerMessage(body) ??
              'Request failed with status ${res.statusCode}',
        );
      }

      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        throw Exception('Invalid server response format');
      }
      if (decoded['success'] == false) {
        throw Exception(
          _extractServerMessage(body) ??
              decoded['message']?.toString() ??
              'Request failed',
        );
      }
      return decoded;
    } catch (e, st) {
      // Re-throw so UI can show the real message.
      if (e is Exception) throw e;
      throw Exception('Request failed: ${e.toString()}');
    }
  }

  String? _extractServerMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final err = decoded['error'];
        if (err is Map<String, dynamic>) {
          final msg = err['message']?.toString();
          if (msg != null && msg.isNotEmpty) return msg;
        }
        final msg = decoded['message']?.toString();
        if (msg != null && msg.isNotEmpty) return msg;
      }
    } catch (_) {
      // ignore parse errors, fallback to generic message
    }
    return null;
  }

  /// Billers list may be under `data`, `data.items`, or top-level keys.
  List<Map<String, dynamic>> _extractBillerRowMaps(
    Map<String, dynamic> decoded,
  ) {
    dynamic data = decoded['data'];
    if (data is Map<String, dynamic>) {
      final nested =
          data['items'] ??
          data['billers'] ??
          data['insurers'] ??
          data['records'] ??
          data['result'];
      if (nested is List) data = nested;
    }
    if (data is! List) {
      data =
          decoded['billers'] ??
          decoded['items'] ??
          decoded['insurers'] ??
          decoded['records'];
    }
    if (data is! List) return const [];

    final out = <Map<String, dynamic>>[];
    for (final raw in data) {
      if (raw is Map<String, dynamic>) {
        out.add(raw);
      } else if (raw is Map) {
        out.add(Map<String, dynamic>.from(raw));
      }
    }
    return out;
  }

  /// Accepts a JSON object or array; tolerates several backend shapes (same host
  /// as accounts may still use different envelopes for `/history`).
  List<BikePaymentHistoryItem> _parsePaymentHistoryResponse(Object decoded) {
    final rows = <Map<String, dynamic>>[];

    void addList(dynamic list) {
      if (list is! List) return;
      for (final raw in list) {
        if (raw is Map<String, dynamic>) {
          rows.add(raw);
        } else if (raw is Map) {
          rows.add(Map<String, dynamic>.from(raw));
        }
      }
    }

    if (decoded is List) {
      addList(decoded);
    } else if (decoded is Map<String, dynamic>) {
      final m = decoded;
      dynamic data = m['data'];
      if (data is Map<String, dynamic>) {
        for (final key in [
          'items',
          'history',
          'payments',
          'records',
          'rows',
          'result',
        ]) {
          final list = data[key];
          if (list is List) {
            addList(list);
            break;
          }
        }
      }
      if (rows.isEmpty && data is List) addList(data);
      if (rows.isEmpty) {
        for (final key in [
          'history',
          'items',
          'payments',
          'records',
          'rows',
          'result',
        ]) {
          final list = m[key];
          if (list is List) {
            addList(list);
            break;
          }
        }
      }
    }

    final out = <BikePaymentHistoryItem>[];
    for (final row in rows) {
      try {
        out.add(BikePaymentHistoryItem.fromJson(row));
      } catch (e, st) {}
    }
    return out;
  }

  Map<String, dynamic> _extractDataMap(Map<String, dynamic> response) {
    final raw = response['data'];
    if (raw is Map<String, dynamic>) return raw;
    if (raw is List && raw.isNotEmpty && raw.first is Map) {
      return Map<String, dynamic>.from(raw.first as Map);
    }
    return response;
  }

  String? _pickFirstString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return null;
  }

  int? _pickFirstInt(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is int) return value;
      final parsed = int.tryParse(value?.toString() ?? '');
      if (parsed != null) return parsed;
    }
    return null;
  }
}
