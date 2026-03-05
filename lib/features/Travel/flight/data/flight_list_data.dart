import 'flight_city_model.dart';

/// A single date–fare option for the results date strip.
class FlightDateFare {
  const FlightDateFare({
    required this.day,
    required this.weekday,
    required this.price,
  });

  final String day;
  final String weekday;
  final int price;
}

/// Popular city/airport for the city select page.
class FlightPopularCity {
  const FlightPopularCity({
    required this.city,
    required this.airport,
    required this.code,
  });

  final String city;
  final String airport;
  final String code;

  FlightCityResult toCityResult() =>
      FlightCityResult(code: code, cityName: city, airportName: airport);
}

/// Recent search entry (route label + city to return when tapped).
class FlightRecentSearch {
  const FlightRecentSearch({
    required this.routeLabel,
    required this.subtitle,
    required this.cityResult,
  });

  final String routeLabel;
  final String subtitle;
  final FlightCityResult cityResult;
}

/// Date–fare list for the results page (e.g. MAR strip).
const List<FlightDateFare> flightDateFares = [
  FlightDateFare(day: '08', weekday: 'Sun', price: 26481),
  FlightDateFare(day: '09', weekday: 'Mon', price: 11083),
  FlightDateFare(day: '10', weekday: 'Tue', price: 13949),
  FlightDateFare(day: '11', weekday: 'Wed', price: 14256),
  FlightDateFare(day: '12', weekday: 'Thu', price: 12858),
  FlightDateFare(day: '13', weekday: 'Fri', price: 9614),
];

/// Recent searches for the city select page.
const List<FlightRecentSearch> flightRecentSearches = [
  FlightRecentSearch(
    routeLabel: 'Chennai - Colombo',
    subtitle: '08 Mar 2026, 1 Traveller',
    cityResult: FlightCityResult(
      code: 'CMB',
      cityName: 'Colombo',
      airportName: 'Bandaranaike International',
    ),
  ),
  FlightRecentSearch(
    routeLabel: 'Bhubaneswar - Tirupati',
    subtitle: '04 Mar 2026, 1 Traveller',
    cityResult: FlightCityResult(
      code: 'TIR',
      cityName: 'Tirupati',
      airportName: 'Tirupati Airport',
    ),
  ),
  FlightRecentSearch(
    routeLabel: 'Bhubaneswar - Cuddapah',
    subtitle: '04 Mar 2026, 1 Traveller',
    cityResult: FlightCityResult(
      code: 'CDP',
      cityName: 'Cuddapah',
      airportName: 'Cuddapah Airport',
    ),
  ),
];

/// Popular cities for the city select page.
const List<FlightPopularCity> flightPopularCities = [
  FlightPopularCity(
    city: 'Delhi',
    airport: 'Indira Gandhi Airport',
    code: 'DEL',
  ),
  FlightPopularCity(
    city: 'Kochi',
    airport: 'Cochin International Airport',
    code: 'COK',
  ),
  FlightPopularCity(
    city: 'Mumbai',
    airport: 'Chhatrapati Shivaji Maharaj International',
    code: 'BOM',
  ),
  FlightPopularCity(
    city: 'Chennai',
    airport: 'Chennai International Airport',
    code: 'MAA',
  ),
  FlightPopularCity(
    city: 'Bengaluru',
    airport: 'Kempegowda International Airport',
    code: 'BLR',
  ),
  FlightPopularCity(
    city: 'Kozhikode',
    airport: 'Calicut International Airport',
    code: 'CCJ',
  ),
];
