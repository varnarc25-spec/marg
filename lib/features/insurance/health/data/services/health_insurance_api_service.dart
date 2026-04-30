import 'dart:convert';

import 'package:http/http.dart' as http;

import '../health_insurance_plan.dart';
import '../models/health_network_hospital.dart';
import '../models/health_partner_model.dart';
import '../models/health_pincode_result.dart';
import '../models/health_callback_result.dart';
import '../models/health_price_promise_model.dart';

/// Marg Health Insurance API (`/api/insurance/health/*`).
class HealthInsuranceApiService {
  HealthInsuranceApiService({http.Client? httpClient, String? baseUrl})
    : _http = httpClient ?? http.Client(),
      _baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/$'), '');

  static const String _defaultBaseUrl =
      'https://marg-api-548031081093.asia-south1.run.app';

  final http.Client _http;
  final String _baseUrl;

  Map<String, String> _headers(String? idToken) {
    return {
      'Content-Type': 'application/json',
      if (idToken != null && idToken.isNotEmpty)
        'Authorization': 'Bearer $idToken',
    };
  }

  Exception _httpException(String label, int code, String body) {
    return Exception(
      '$label ($code)${body.isNotEmpty ? ': ${body.length > 200 ? '${body.substring(0, 200)}…' : body}' : ''}',
    );
  }

  Map<String, dynamic> _decodeMap(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    throw Exception('Invalid JSON response');
  }

  void _ensureSuccess(Map<String, dynamic> decoded) {
    if (decoded['success'] == false) {
      final err = decoded['error'];
      final msg = err is Map ? err['message']?.toString() : err?.toString();
      throw Exception(
        msg ?? decoded['message']?.toString() ?? 'Request failed',
      );
    }
  }

  /// GET `/api/insurance/health/partners`
  Future<List<HealthInsurancePlan>> getPartners({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/health/partners');

    final res = await _http.get(uri, headers: _headers(idToken));

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException(
        'Failed to load health partners',
        res.statusCode,
        res.body,
      );
    }

    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);

    final partners = _extractObjectList(decoded);
    final plans = <HealthInsurancePlan>[];
    for (var i = 0; i < partners.length; i++) {
      try {
        final p = HealthPartner.fromJson(partners[i]);
        if (p.name.isEmpty) continue;
        plans.add(
          HealthInsurancePlan(
            id: p.id.isNotEmpty ? p.id : 'health_${p.code}_$i',
            insurerName: p.name,
            insurerCode: p.code.isNotEmpty ? p.code : null,
            logoUrl: (p.logoUrl != null && p.logoUrl!.isNotEmpty)
                ? p.logoUrl
                : null,
            coverLakhs: 5,
            priceMonthly: null,
            tag: i == 0 ? 'Popular' : null,
            highlights: const [],
            hospitalCount: null,
            claimSettlementRateLabel: null,
          ),
        );
      } catch (e, st) {}
    }
    return plans;
  }

  /// GET `/api/insurance/health/config`
  Future<Map<String, dynamic>> getConfig({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/health/config');
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException(
        'Failed to load health config',
        res.statusCode,
        res.body,
      );
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final data = decoded['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return decoded;
  }

  /// GET `/api/insurance/health/price-promise`
  Future<HealthPricePromise?> getPricePromise({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/health/price-promise');
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      return null;
    }
    final decoded = _decodeMap(res.body);
    if (decoded['success'] == false) return null;
    final data = decoded['data'];
    if (data is Map<String, dynamic>) {
      return HealthPricePromise.fromJson(data);
    }
    if (data is Map) {
      return HealthPricePromise.fromJson(Map<String, dynamic>.from(data));
    }
    return HealthPricePromise.fromJson(decoded);
  }

  /// GET `/api/insurance/health/pincode/{pincode}`
  Future<HealthPincodeResult> validatePincode(
    String pincode, {
    String? idToken,
  }) async {
    final clean = pincode.trim();
    final uri = Uri.parse('$_baseUrl/api/insurance/health/pincode/$clean');
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      return HealthPincodeResult.invalid('Could not validate pincode');
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final data = decoded['data'];
    if (data is Map<String, dynamic>) {
      return HealthPincodeResult.fromJson(data);
    }
    if (data is Map) {
      return HealthPincodeResult.fromJson(Map<String, dynamic>.from(data));
    }
    return HealthPincodeResult.fromJson(decoded);
  }

  /// GET `/api/insurance/health/network-hospitals?pincode=`
  Future<List<HealthNetworkHospital>> getNetworkHospitals(
    String pincode, {
    String? idToken,
  }) async {
    final clean = pincode.trim();
    final uri = Uri.parse(
      '$_baseUrl/api/insurance/health/network-hospitals',
    ).replace(queryParameters: {'pincode': clean});
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException(
        'Failed to load network hospitals',
        res.statusCode,
        res.body,
      );
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final list = _extractObjectList(decoded);
    final out = <HealthNetworkHospital>[];
    for (final m in list) {
      try {
        final h = HealthNetworkHospital.fromJson(m);
        if (h.name.isNotEmpty) out.add(h);
      } catch (_) {}
    }
    return out;
  }

  /// POST `/api/insurance/health/selection`
  Future<void> submitSelection(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/health/selection');
    final res = await _http.post(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Selection failed', res.statusCode, res.body);
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
  }

  /// GET `/api/insurance/health/plans` (query string)
  Future<List<HealthInsurancePlan>> getPlansWithQuery(
    Map<String, String> query, {
    String? idToken,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/api/insurance/health/plans',
    ).replace(queryParameters: query);
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Failed to load plans', res.statusCode, res.body);
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    return _plansFromDecoded(decoded);
  }

  /// POST `/api/insurance/health/plans` (quote body)
  Future<List<HealthInsurancePlan>> getPlansWithBody(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/health/plans');
    final res = await _http.post(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Quote failed', res.statusCode, res.body);
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    return _plansFromDecoded(decoded);
  }

  /// GET `/api/insurance/health/plans/{planId}`
  Future<Map<String, dynamic>> getPlanDetails(
    String planId, {
    String? idToken,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/api/insurance/health/plans/${Uri.encodeComponent(planId)}',
    );
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException(
        'Failed to load plan details',
        res.statusCode,
        res.body,
      );
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final data = decoded['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return decoded;
  }

  /// POST `/api/insurance/health/plans/compare`
  Future<Map<String, dynamic>> comparePlans(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/health/plans/compare');
    final res = await _http.post(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Compare failed', res.statusCode, res.body);
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final data = decoded['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return decoded;
  }

  /// POST `/api/insurance/health/callback`
  ///
  /// Response: `{ "success": true, "message": "...", "data": { "id", "status" } }`
  Future<HealthCallbackResult> requestCallback(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/health/callback');
    final res = await _http.post(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Callback request failed', res.statusCode, res.body);
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final data = decoded['data'];
    String? id;
    String? status;
    if (data is Map) {
      id = data['id']?.toString();
      status = data['status']?.toString();
    }
    return HealthCallbackResult(
      message: decoded['message']?.toString() ?? 'Callback request submitted',
      requestId: id,
      status: status,
    );
  }

  List<Map<String, dynamic>> _extractObjectList(Map<String, dynamic> decoded) {
    dynamic data = decoded['data'];
    if (data is Map<String, dynamic>) {
      final nested =
          data['items'] ??
          data['partners'] ??
          data['plans'] ??
          data['records'] ??
          data['results'] ??
          data['hospitals'];
      if (nested is List) data = nested;
    }
    if (data is! List) {
      data =
          decoded['partners'] ??
          decoded['items'] ??
          decoded['plans'] ??
          decoded['results'];
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

  List<HealthInsurancePlan> _plansFromDecoded(Map<String, dynamic> decoded) {
    final rows = _extractObjectList(decoded);
    final plans = <HealthInsurancePlan>[];
    for (var i = 0; i < rows.length; i++) {
      try {
        final p = _parsePlanRow(rows[i], i);
        if (p != null) plans.add(p);
      } catch (e, st) {}
    }
    return plans;
  }

  HealthInsurancePlan? _parsePlanRow(Map<String, dynamic> json, int index) {
    final name =
        (json['insurerName'] ??
                json['insurer'] ??
                json['companyName'] ??
                json['name'] ??
                json['planName'] ??
                '')
            .toString()
            .trim();
    if (name.isEmpty) return null;

    final id = (json['id'] ?? json['planId'] ?? json['_id'] ?? 'plan_$index')
        .toString();

    final code = json['insurerCode'] ?? json['code'];
    final logo = json['logoUrl'] ?? json['logo'];

    int cover = 5;
    final si = json['sumInsured'] ?? json['sum_insured'] ?? json['coverLakhs'];
    if (si is num) {
      if (si > 100) {
        cover = (si / 100000).round().clamp(1, 999);
      } else {
        cover = si.toInt().clamp(1, 999);
      }
    }

    int? monthly;
    final pm =
        json['premiumMonthly'] ??
        json['monthlyPremium'] ??
        json['monthly_premium'];
    final pa =
        json['premiumAnnual'] ?? json['annualPremium'] ?? json['premium'];
    if (pm is num) {
      monthly = pm.round();
    } else if (pa is num) {
      monthly = (pa / 12).round();
    } else if (json['premium'] is String) {
      final parsed = int.tryParse(
        (json['premium'] as String).replaceAll(RegExp(r'[^0-9]'), ''),
      );
      monthly = parsed;
    }

    final highlights = <String>[];
    final rawHighlights =
        json['highlights'] ??
        json['benefits'] ??
        json['features'] ??
        json['bullets'];
    if (rawHighlights is List) {
      for (final e in rawHighlights) {
        final s = e.toString().trim();
        if (s.isNotEmpty) highlights.add(s);
      }
    }
    if (highlights.isEmpty) {
      final b1 = json['benefit1'] ?? json['highlight1'];
      final b2 = json['benefit2'] ?? json['highlight2'];
      if (b1 != null) highlights.add(b1.toString());
      if (b2 != null) highlights.add(b2.toString());
    }

    int? hospitalCount;
    final hc =
        json['hospitalCount'] ??
        json['networkHospitalCount'] ??
        json['cashlessHospitals'] ??
        json['networkHospitals'];
    if (hc is num) {
      hospitalCount = hc.round();
    } else if (hc is String) {
      hospitalCount = int.tryParse(hc.replaceAll(RegExp(r'[^0-9]'), ''));
    }

    String? csrLabel;
    final csr =
        json['claimSettlementRate'] ??
        json['settlementRate'] ??
        json['claimSettlement'];
    if (csr != null) {
      final s = csr.toString().trim();
      if (s.isNotEmpty) csrLabel = s;
    }

    return HealthInsurancePlan(
      id: id,
      insurerName: name,
      insurerCode: code?.toString(),
      logoUrl: logo?.toString(),
      coverLakhs: cover,
      priceMonthly: monthly,
      tag: json['tag']?.toString() ?? (index == 0 ? 'Popular' : null),
      highlights: highlights.take(4).toList(),
      hospitalCount: hospitalCount,
      claimSettlementRateLabel: csrLabel,
    );
  }
}
