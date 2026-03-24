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

  factory FlightResultItem.fromJson(Map<String, dynamic> json) {
    return FlightResultItem(
      airlineName: json['airline_name'] as String,
      flightNumbers: json['flight_numbers'] as String,
      departureTime: json['departure_time'] as String,
      departureCity: json['departure_city'] as String,
      arrivalTime: json['arrival_time'] as String,
      arrivalCity: json['arrival_city'] as String,
      arrivalNextDay: json['arrival_next_day'] as bool? ?? false,
      duration: json['duration'] as String,
      stops: json['stops'] as String,
      layoverText: json['layover_text'] as String?,
      offerText: json['offer_text'] as String?,
      price: json['price'] as int,
    );
  }

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

  Map<String, dynamic> toJson() => {
        'airline_name': airlineName,
        'flight_numbers': flightNumbers,
        'departure_time': departureTime,
        'departure_city': departureCity,
        'arrival_time': arrivalTime,
        'arrival_city': arrivalCity,
        'arrival_next_day': arrivalNextDay,
        'duration': duration,
        'stops': stops,
        'layover_text': layoverText,
        'offer_text': offerText,
        'price': price,
      };
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
