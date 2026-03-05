import 'flight_result_model.dart';

/// Mock service for flight search. Returns date fares and flight results.
class FlightSearchService {
  static const Duration _mockDelay = Duration(milliseconds: 400);

  /// Fetches flight results for the given route (mock).
  Future<List<FlightResultItem>> getFlights(String fromCode, String toCode) async {
    await Future.delayed(_mockDelay);
    return flightResultsMock;
  }

  /// Mock flight results (same for any route for demo).
  static const List<FlightResultItem> flightResultsMock = [
    FlightResultItem(
      airlineName: 'Air India Express',
      flightNumbers: 'IX 2786, IX 987',
      departureTime: '05:05 PM',
      departureCity: 'Chennai',
      arrivalTime: '12:50 AM',
      arrivalCity: 'Kuwait',
      arrivalNextDay: true,
      duration: '10h 15m',
      stops: '1 Stop',
      layoverText: '3h 30m layover at Bengaluru',
      offerText: 'Flat ₹976 off on FLYDEAL',
      price: 13949,
    ),
    FlightResultItem(
      airlineName: 'Air India Express',
      flightNumbers: 'IX 2786, IX 987',
      departureTime: '12:25 PM',
      departureCity: 'Chennai',
      arrivalTime: '12:50 AM',
      arrivalCity: 'Kuwait',
      arrivalNextDay: true,
      duration: '14h 55m',
      stops: '1 Stop',
      layoverText: '8h 5m layover at Bengaluru',
      offerText: 'Flat ₹976 off on FLYDEAL',
      price: 13949,
    ),
    FlightResultItem(
      airlineName: 'SriLankan Airlines',
      flightNumbers: 'UL 123, UL 456',
      departureTime: '03:55 PM',
      departureCity: 'Chennai',
      arrivalTime: '09:20 PM',
      arrivalCity: 'Kuwait',
      duration: '7h 55m',
      stops: '1 Stop',
      layoverText: '1h layover at Colombo',
      offerText: 'Flat ₹800 off on FLYDEAL',
      price: 15246,
    ),
    FlightResultItem(
      airlineName: 'SriLankan Airlines',
      flightNumbers: 'UL 789, UL 012',
      departureTime: '09:45 AM',
      departureCity: 'Chennai',
      arrivalTime: '09:20 PM',
      arrivalCity: 'Kuwait',
      duration: '14h 5m',
      stops: '1 Stop',
      layoverText: '7h 10m layover at Colombo',
      offerText: 'Flat ₹800 off on FLYDEAL',
      price: 15246,
    ),
  ];
}
