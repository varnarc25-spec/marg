import 'dart:convert';

import 'package:http/http.dart' as http;

import '../life_insurance_api_exceptions.dart';
import '../life_insurance_plan.dart';
import '../models/life_benefit_item.dart';
import '../models/life_callback_result.dart';
import '../models/life_partner_model.dart';
import '../models/life_promo_model.dart';

/// Marg Life Insurance API (`/api/insurance/life/*`).
class LifeInsuranceApiService {
  LifeInsuranceApiService({http.Client? httpClient, String? baseUrl})
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
      throw const LifeApiUnsuccessfulResponse();
    }
  }

  List<Map<String, dynamic>> _extractObjectList(Map<String, dynamic> decoded) {
    dynamic data = decoded['data'];
    if (data is List) {
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
    if (data is Map<String, dynamic>) {
      final nested =
          data['items'] ??
          data['partners'] ??
          data['plans'] ??
          data['records'] ??
          data['results'] ??
          data['promos'] ??
          data['benefits'] ??
          data['banners'];
      if (nested is List) data = nested;
    }
    if (data is! List) {
      data =
          decoded['items'] ??
          decoded['partners'] ??
          decoded['plans'] ??
          decoded['results'] ??
          decoded['data'];
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

  /// GET `/api/insurance/life/partners`
  Future<List<LifePartner>> getPartners({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/life/partners');
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException(
        'Failed to load life partners',
        res.statusCode,
        res.body,
      );
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final rows = _extractObjectList(decoded);
    final out = <LifePartner>[];
    for (final m in rows) {
      try {
        final p = LifePartner.fromJson(m);
        if (p.name.isNotEmpty) out.add(p);
      } catch (_) {}
    }
    return out;
  }

  /// GET `/api/insurance/life/promos`
  Future<List<LifePromoBanner>> getPromos({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/life/promos');
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Failed to load promos', res.statusCode, res.body);
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final rows = _extractObjectList(decoded);
    return rows.map(LifePromoBanner.fromJson).toList();
  }

  /// GET `/api/insurance/life/benefits`
  Future<List<LifeBenefitItem>> getBenefits({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/life/benefits');
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Failed to load benefits', res.statusCode, res.body);
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final rows = _extractObjectList(decoded);
    final out = <LifeBenefitItem>[];
    for (final m in rows) {
      try {
        final b = LifeBenefitItem.fromJson(m);
        if (b.title.isNotEmpty) out.add(b);
      } catch (_) {}
    }
    return out;
  }

  /// GET `/api/insurance/life/config`
  Future<Map<String, dynamic>> getConfig({String? idToken}) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/life/config');
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Failed to load config', res.statusCode, res.body);
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final data = decoded['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return decoded;
  }

  /// POST `/api/insurance/life/calculate-cover`
  Future<LifeCoverResult> calculateCover(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/life/calculate-cover');
    final res = await _http.post(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Calculate cover failed', res.statusCode, res.body);
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    return _parseCoverResult(decoded);
  }

  LifeCoverResult _parseCoverResult(Map<String, dynamic> decoded) {
    final dynamic raw = decoded['data'] ?? decoded;
    if (raw is! Map) {
      throw Exception('Invalid calculate-cover response');
    }
    final map = Map<String, dynamic>.from(raw);

    int rupeesToLakhs(num? r, {int fallback = 25}) {
      if (r == null) return fallback;
      final v = r.round();
      if (v <= 0) return fallback;
      return (v / 100000).round().clamp(1, 9999);
    }

    final minL = rupeesToLakhs(_numFrom(map['minSumAssured']), fallback: 25);
    var maxL = rupeesToLakhs(_numFrom(map['maxSumAssured']), fallback: 300);
    num? idealRupees = _numFrom(map['idealRecommendedCover']);
    if (idealRupees == null || idealRupees == 0) {
      idealRupees = _numFrom(map['defaultSumAssured']);
    }
    final idealL = rupeesToLakhs(idealRupees, fallback: minL);
    final defaultL = map['defaultSumAssured'] != null
        ? rupeesToLakhs(_numFrom(map['defaultSumAssured']), fallback: idealL)
        : null;

    maxL = maxL.clamp(minL + 1, 9999);
    final rec = idealL.clamp(minL, maxL);

    final till = map['defaultCoverTillAge'];
    final tillAge = till is num ? till.round() : int.tryParse('$till');

    return LifeCoverResult(
      minCoverLakhs: minL,
      maxCoverLakhs: maxL,
      recommendedCoverLakhs: rec,
      idealCoverRationale: map['idealCoverRationale']?.toString(),
      defaultCoverTillAge: tillAge,
      defaultSumAssuredLakhs: defaultL,
    );
  }

  num? _numFrom(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    return num.tryParse(v.toString().replaceAll(RegExp(r'[^0-9.]'), ''));
  }

  /// POST `/api/insurance/life/recommendation`
  Future<Map<String, dynamic>> postRecommendation(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/life/recommendation');
    final res = await _http.post(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Recommendation failed', res.statusCode, res.body);
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final data = decoded['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return decoded;
  }

  /// GET `/api/insurance/life/plans`
  Future<List<LifeTermPlan>> getPlansQuery(
    Map<String, String> query, {
    String? idToken,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/api/insurance/life/plans',
    ).replace(queryParameters: query);
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Failed to load plans', res.statusCode, res.body);
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    return _parsePlansList(decoded);
  }

  /// POST `/api/insurance/life/plans`
  Future<List<LifeTermPlan>> postPlans(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/life/plans');
    final res = await _http.post(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Plans search failed', res.statusCode, res.body);
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    return _parsePlansList(decoded);
  }

  List<LifeTermPlan> _parsePlansList(Map<String, dynamic> decoded) {
    final rows = _extractObjectList(decoded);
    final out = <LifeTermPlan>[];
    for (var i = 0; i < rows.length; i++) {
      try {
        final p = _parsePlanRow(rows[i], i);
        if (p != null) out.add(p);
      } catch (e, st) {}
    }
    return out;
  }

  LifeTermPlan? _parsePlanRow(Map<String, dynamic> json, int index) {
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

    final id =
        (json['id'] ?? json['planId'] ?? json['_id'] ?? 'life_plan_$index')
            .toString();

    int? lakhs;
    final sa =
        json['sumAssuredLakhs'] ?? json['sumAssured'] ?? json['coverLakhs'];
    if (sa is num) {
      lakhs = sa > 1000 ? (sa / 100000).round() : sa.round();
    }

    int? monthly;
    final pm = json['premiumMonthly'] ?? json['monthlyPremium'];
    final pa =
        json['premiumAnnual'] ?? json['annualPremium'] ?? json['premium'];
    if (pm is num) {
      monthly = pm.round();
    } else if (pa is num) {
      monthly = (pa / 12).round();
    }

    final highlights = <String>[];
    final h = json['highlights'] ?? json['benefits'] ?? json['features'];
    if (h is List) {
      for (final e in h) {
        final s = e.toString().trim();
        if (s.isNotEmpty) highlights.add(s);
      }
    }

    return LifeTermPlan(
      id: id,
      insurerName: name,
      logoUrl: json['logoUrl']?.toString() ?? json['logo']?.toString(),
      premiumMonthly: monthly,
      sumAssuredLakhs: lakhs,
      tag: json['tag']?.toString(),
      highlights: highlights.take(4).toList(),
    );
  }

  /// GET `/api/insurance/life/plans/{planId}`
  Future<Map<String, dynamic>> getPlanDetails(
    String planId, {
    String? idToken,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/api/insurance/life/plans/${Uri.encodeComponent(planId)}',
    );
    final res = await _http.get(uri, headers: _headers(idToken));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Plan details failed', res.statusCode, res.body);
    }
    final decoded = _decodeMap(res.body);
    _ensureSuccess(decoded);
    final data = decoded['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return decoded;
  }

  /// POST `/api/insurance/life/plans/compare`
  Future<Map<String, dynamic>> comparePlans(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/life/plans/compare');
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

  /// POST `/api/insurance/life/callback`
  Future<LifeCallbackResult> requestCallback(
    Map<String, dynamic> body, {
    String? idToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/insurance/life/callback');
    final res = await _http.post(
      uri,
      headers: _headers(idToken),
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw _httpException('Callback failed', res.statusCode, res.body);
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
    return LifeCallbackResult(
      message: decoded['message']?.toString() ?? 'Request submitted',
      requestId: id,
      status: status,
    );
  }
}
