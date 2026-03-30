import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/flight_result_model.dart';

/// Real flight search service backed by FlightAPI.io.
///
/// Uses the public onewaytrip endpoint:
/// https://api.flightapi.io/onewaytrip/<api-key>/<from>/<to>/<date>/<adults>/<children>/<infants>/<cabin>/<currency>
class FlightApiService {
  FlightApiService({
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  static const String _baseUrl = 'https://api.flightapi.io/onewaytrip';

  /// TODO: Move to secure config / backend for production use.
  static const String _apiKey = '69b3a15ed846b947fca50758';

  /// Static configuration for demo.
  static const String _currency = 'INR';
  static const String _cabinClass = 'Economy';
  static const int _defaultAdults = 1;
  static const int _defaultChildren = 0;
  static const int _defaultInfants = 0;

  final http.Client _http;

  /// Fetches live flights for a one-way trip.
  ///
  /// [departureDate] must be in `YYYY-MM-DD` format expected by the API.
  Future<List<FlightResultItem>> searchOneWay({
    required String fromCode,
    required String toCode,
    required String departureDate,
    int adults = _defaultAdults,
    int children = _defaultChildren,
    int infants = _defaultInfants,
  }) async {
    final pathSegments = <String>[
      _apiKey,
      fromCode,
      toCode,
      departureDate,
      adults.toString(),
      children.toString(),
      infants.toString(),
      _cabinClass,
      _currency,
    ];

    final uri = Uri.parse('$_baseUrl/${pathSegments.join('/')}');

    
    final res = await _http.get(uri);
    if (res.statusCode < 200 || res.statusCode >= 300) {
            throw Exception('Failed to fetch flights (${res.statusCode})');
    }

    final dynamic raw = jsonDecode(res.body);
    if (raw is! Map<String, dynamic>) {
      throw Exception('Unexpected flights response format');
    }

    return _mapToFlightResults(raw);
  }

  List<FlightResultItem> _mapToFlightResults(Map<String, dynamic> json) {
    final itineraries = (json['itineraries'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final legs = (json['legs'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final segments = (json['segments'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final places = (json['places'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final carriers = (json['carriers'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();

    Map<int, Map<String, dynamic>> _byIntId(List<Map<String, dynamic>> list) {
      final map = <int, Map<String, dynamic>>{};
      for (final item in list) {
        final id = item['id'];
        if (id is int) {
          map[id] = item;
        }
      }
      return map;
    }

    final legsById = <String, Map<String, dynamic>>{
      for (final l in legs)
        if (l['id'] is String) l['id'] as String: l,
    };
    final segmentsById = <String, Map<String, dynamic>>{
      for (final s in segments)
        if (s['id'] is String) s['id'] as String: s,
    };
    final placesById = _byIntId(places);
    final carriersById = _byIntId(carriers);

    final results = <FlightResultItem>[];

    for (final itinerary in itineraries) {
      final legIds = (itinerary['leg_ids'] as List<dynamic>? ?? [])
          .whereType<String>()
          .toList();
      if (legIds.isEmpty) continue;

      final leg = legsById[legIds.first];
      if (leg == null) continue;

      final segmentIds = (leg['segment_ids'] as List<dynamic>? ?? [])
          .whereType<String>()
          .toList();
      if (segmentIds.isEmpty) continue;
      final segment = segmentsById[segmentIds.first] ?? const {};

      final originPlace = placesById[(leg['origin_place_id'] as num?)?.toInt() ?? -1];
      final destPlace =
          placesById[(leg['destination_place_id'] as num?)?.toInt() ?? -1];

      final marketingCarrierId =
          (segment['marketing_carrier_id'] as num?)?.toInt();
      final carrier =
          marketingCarrierId != null ? carriersById[marketingCarrierId] : null;

      final airlineName =
          (carrier?['name'] as String?) ?? (carrier?['alt_id'] as String?) ?? 'Airline';
      final marketingFlightNumber =
          (segment['marketing_flight_number'] as String?) ?? '';

      final departureIso = (leg['departure'] as String?) ?? '';
      final arrivalIso = (leg['arrival'] as String?) ?? '';

      String _formatTime(String iso) {
        try {
          final dt = DateTime.parse(iso).toLocal();
          final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
          final minute = dt.minute.toString().padLeft(2, '0');
          final suffix = dt.hour >= 12 ? 'PM' : 'AM';
          return '$hour:$minute $suffix';
        } catch (_) {
          return iso;
        }
      }

      final departureTime = departureIso.isNotEmpty
          ? _formatTime(departureIso)
          : '—';
      final arrivalTime =
          arrivalIso.isNotEmpty ? _formatTime(arrivalIso) : '—';

      final durationMinutes = (leg['duration'] as num?)?.toInt() ?? 0;
      final duration = _formatDuration(durationMinutes);

      final stopCount = (leg['stop_count'] as num?)?.toInt() ?? 0;
      final stops =
          stopCount == 0 ? 'Non-stop' : '$stopCount Stop${stopCount > 1 ? "s" : ""}';

      final originCity =
          (originPlace?['name'] as String?) ?? (originPlace?['type'] as String?) ?? 'Origin';
      final destCity =
          (destPlace?['name'] as String?) ?? (destPlace?['type'] as String?) ?? 'Destination';

      double? amount;
      final pricingOptions = (itinerary['pricing_options'] as List<dynamic>? ??
              itinerary['pricingOptions'] as List<dynamic>? ??
              [])
          .whereType<Map<String, dynamic>>()
          .toList();
      if (pricingOptions.isNotEmpty) {
        final priceObj = pricingOptions.first['price'];
        if (priceObj is Map<String, dynamic>) {
          final rawAmount = priceObj['amount'];
          if (rawAmount is num) amount = rawAmount.toDouble();
        }
      }

      final price = (amount ?? 0).round();

      results.add(
        FlightResultItem(
          airlineName: airlineName,
          flightNumbers: marketingFlightNumber.isNotEmpty
              ? marketingFlightNumber
              : '—',
          departureTime: departureTime,
          departureCity: originCity,
          arrivalTime: arrivalTime,
          arrivalCity: destCity,
          duration: duration,
          stops: stops,
          layoverText: null,
          offerText: null,
          price: price,
        ),
      );
    }

    return results;
  }

  String _formatDuration(int minutes) {
    if (minutes <= 0) return '—';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }
}

