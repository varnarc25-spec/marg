import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/flight_booking_model.dart';
import '../../data/flight_city_model.dart';
import '../../data/flight_result_model.dart';
import '../../data/flight_search_service.dart';
import '../../data/flight_api_service.dart';

/// Flight search service (mock, kept as fallback/demo).
final flightSearchServiceProvider = Provider<FlightSearchService>((ref) {
  return FlightSearchService();
});

/// Real flight API service backed by FlightAPI.io (one-way, INR).
final flightApiServiceProvider = Provider<FlightApiService>((ref) {
  return FlightApiService();
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

/// Completed flight bookings stored in memory for the session.
final flightBookingsProvider =
    StateNotifierProvider<FlightBookingsNotifier, List<FlightBooking>>((ref) {
  return FlightBookingsNotifier();
});

class FlightBookingsNotifier extends StateNotifier<List<FlightBooking>> {
  FlightBookingsNotifier() : super([]);

  void add(FlightBooking booking) {
    state = [booking, ...state];
  }
}
