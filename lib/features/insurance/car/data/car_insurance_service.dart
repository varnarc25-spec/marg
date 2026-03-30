import 'dart:convert';

import 'package:http/http.dart' as http;

import 'car_insurance_plan.dart';
import 'car_vehicle_model.dart';

/// API-backed service for car insurance plans.
/// Uses `/api/insurance/car/billers` and derives plan cards from insurer list.
class CarInsuranceService {
  CarInsuranceService({
    http.Client? httpClient,
    String? baseUrl,
  })  : _http = httpClient ?? http.Client(),
        _baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/$'), '');

  static const String _defaultBaseUrl =
      'https://margapi-548031081093.asia-south1.run.app';

  final http.Client _http;
  final String _baseUrl;

  String _normalize(String vehicleNumber) {
    return vehicleNumber.trim().toUpperCase().replaceAll(RegExp(r'[\s\-]+'), '');
  }

  /// Car details are not yet backed by API routes in this module.
  /// Return a lightweight derived model so the flow can continue to plans.
  Future<CarVehicleModel> getVehicleDetails(String vehicleNumber) async {
    final normalized = _normalize(vehicleNumber);
    if (normalized.length < 4) {
      throw Exception('Enter a valid registration number');
    }

    return CarVehicleModel(
      ownerName: '—',
      model: 'Car $normalized',
      registrationDate: DateTime(2022, 1, 1),
      insuranceExpiry: DateTime.now().add(const Duration(days: 30)),
    );
  }

  /// GET `/api/insurance/car/billers` -> map insurers into plan cards.
  Future<List<CarInsurancePlan>> getPlans(String vehicleNumber) async {
    final normalized = _normalize(vehicleNumber);
    if (normalized.length < 4) {
      throw Exception('Enter a valid registration number');
    }

    final uri = Uri.parse('$_baseUrl/api/insurance/car/billers');
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

    if (decoded['success'] == false) {
      final err = decoded['error'];
      final msg = err is Map ? err['message']?.toString() : err?.toString();
      throw Exception(msg ?? decoded['message']?.toString() ?? 'Request failed');
    }

    dynamic data = decoded['data'];
    if (data is! List) data = decoded['billers'] ?? decoded['items'];
    if (data is! List) return const [];

    final billers = data.whereType<Map<String, dynamic>>().toList();
    final sorted = List<Map<String, dynamic>>.from(billers)
      ..sort(
        (a, b) => (a['name']?.toString() ?? '').compareTo(
          b['name']?.toString() ?? '',
        ),
      );

    final plans = <CarInsurancePlan>[];
    for (var i = 0; i < sorted.length; i++) {
      final b = sorted[i];
      final name = b['name']?.toString().trim() ?? '';
      if (name.isEmpty) continue;
      final id = (b['id']?.toString().trim().isNotEmpty ?? false)
          ? b['id'].toString().trim()
          : 'car_plan_$i';
      plans.add(
        CarInsurancePlan(
          id: id,
          insurerName: name,
          idv: 480000 + (i * 1500),
          price: 12000 + (i * 220),
          priceThirdParty: 7900 + (i * 70),
          tag: i == 0 ? 'Best Value' : null,
        ),
      );
    }
    return plans;
  }
}
