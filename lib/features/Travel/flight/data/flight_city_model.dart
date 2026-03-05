/// Result of selecting a city/airport on the city select page.
class FlightCityResult {
  const FlightCityResult({
    required this.code,
    required this.cityName,
    this.airportName,
  });

  final String code;
  final String cityName;
  final String? airportName;
}
