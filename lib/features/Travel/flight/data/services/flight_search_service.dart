import '../models/flight_result_model.dart';
import '../models/flight_static_data.dart';

/// Flight search fallback service.
///
/// Provides static flight results parsed from JSON when the live API
/// is unavailable. Supports route-specific data (e.g. "MAA-DEL") with
/// a generic default fallback for unknown routes.
class FlightSearchService {
  /// Returns fallback flights for the given route, filling in the
  /// actual city names when the data uses generic "Origin"/"Destination".
  static List<FlightResultItem> getFallbackFlights({
    required String fromCode,
    required String toCode,
    String? fromCity,
    String? toCity,
  }) {
    final routeKey = '${fromCode.toUpperCase()}-${toCode.toUpperCase()}';
    final jsonList = flightStaticJson[routeKey] ?? flightDefaultJson;

    return jsonList.map((json) {
      final item = FlightResultItem.fromJson(json);

      if (fromCity != null && item.departureCity == 'Origin') {
        return FlightResultItem.fromJson({
          ...json,
          'departure_city': fromCity,
          'arrival_city': toCity ?? item.arrivalCity,
        });
      }
      return item;
    }).toList();
  }

  /// Convenience getter kept for backward compatibility.
  static List<FlightResultItem> get flightResultsMock =>
      getFallbackFlights(fromCode: 'MAA', toCode: 'DEL');
}
