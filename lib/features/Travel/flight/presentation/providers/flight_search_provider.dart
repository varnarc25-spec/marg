import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/flight_city_model.dart';
import '../../data/flight_result_model.dart';
import '../../data/flight_search_service.dart';

/// Flight search service (mock).
final flightSearchServiceProvider = Provider<FlightSearchService>((ref) {
  return FlightSearchService();
});

/// From city/airport selection. Default: Chennai (MAA).
final flightFromProvider = StateProvider<FlightCityResult>((ref) {
  return const FlightCityResult(
    code: 'MAA',
    cityName: 'Chennai',
    airportName: 'Chennai International Airport',
  );
});

/// To city/airport selection. Default: Kuwait (KWI).
final flightToProvider = StateProvider<FlightCityResult>((ref) {
  return const FlightCityResult(
    code: 'KWI',
    cityName: 'Kuwait',
    airportName: 'Kuwait International Airport',
  );
});

/// Cached flight results for the current search (set when user taps Search Flights).
/// Results page reads this; sort/filter stay local to the page.
final flightResultsProvider = StateProvider<List<FlightResultItem>>((ref) {
  return FlightSearchService.flightResultsMock;
});
