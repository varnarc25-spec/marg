import 'flight_city_model.dart';

/// A single date–fare option for the results date strip.
class FlightDateFare {
  const FlightDateFare({
    required this.date,
    required this.day,
    required this.weekday,
    required this.price,
  });

  final DateTime date;
  final String day;
  final String weekday;
  final int price;
}

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String monthShortName(int month) =>
    (month >= 1 && month <= 12) ? _months[month - 1] : '';

/// Generates a date strip centered on [selectedDate] with up to 3 days before
/// and 3 days after. Past dates (before today) are excluded.
/// Returns the list and the index of the selected date within it.
({List<FlightDateFare> dates, int selectedIndex}) generateDateStrip(
  DateTime selectedDate,
) {
  final basePrices = [9614, 11083, 12858, 13949, 14256, 15500, 26481];
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dates = <FlightDateFare>[];
  int selectedIndex = 0;
  const centerOffset = 3;

  for (int i = -centerOffset; i <= centerOffset; i++) {
    final d = selectedDate.add(Duration(days: i));
    if (d.isBefore(today)) continue;
    if (d == selectedDate || (d.year == selectedDate.year && d.month == selectedDate.month && d.day == selectedDate.day)) {
      selectedIndex = dates.length;
    }
    final priceIndex = (d.day + d.month) % basePrices.length;
    dates.add(FlightDateFare(
      date: d,
      day: d.day.toString().padLeft(2, '0'),
      weekday: _weekdays[d.weekday - 1],
      price: basePrices[priceIndex],
    ));
  }

  return (dates: dates, selectedIndex: selectedIndex);
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
