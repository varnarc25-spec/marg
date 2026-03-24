import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/bus_city_model.dart';
import '../../data/services/bus_search_service.dart';

final busSearchServiceProvider = Provider<BusSearchService>((ref) {
  return BusSearchService();
});

/// From city for bus search. Default: Tirupati.
final busFromProvider = StateProvider<BusCityResult>((ref) {
  return const BusCityResult(cityName: 'Tirupati');
});

/// To city for bus search. Default: Rajampet.
final busToProvider = StateProvider<BusCityResult>((ref) {
  return const BusCityResult(cityName: 'Rajampet');
});
