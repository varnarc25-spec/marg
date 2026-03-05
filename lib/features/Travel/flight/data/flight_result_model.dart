/// Single flight option for the search results list.
class FlightResultItem {
  const FlightResultItem({
    required this.airlineName,
    required this.flightNumbers,
    required this.departureTime,
    required this.departureCity,
    required this.arrivalTime,
    required this.arrivalCity,
    this.arrivalNextDay = false,
    required this.duration,
    required this.stops,
    this.layoverText,
    this.offerText,
    required this.price,
  });

  final String airlineName;
  final String flightNumbers;
  final String departureTime;
  final String departureCity;
  final String arrivalTime;
  final String arrivalCity;
  final bool arrivalNextDay;
  final String duration;
  final String stops;
  final String? layoverText;
  final String? offerText;
  final int price;
}

/// Sort option for flight results.
enum FlightSortOption {
  cheapest,
  earlyDeparture,
  earlyArrival,
  lateDeparture,
  lateArrival,
  fastest,
}
