import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/train_station_model.dart';
import '../../data/train_search_service.dart';

final trainSearchServiceProvider = Provider<TrainSearchService>((ref) {
  return TrainSearchService();
});

/// From station for train search. Default: TPTY Tirupati.
final trainFromProvider = StateProvider<TrainStationResult>((ref) {
  return const TrainStationResult(stationCode: 'TPTY', stationName: 'Tirupati');
});

/// To station for train search. Default: TNM Tiruvannamalai.
final trainToProvider = StateProvider<TrainStationResult>((ref) {
  return const TrainStationResult(
    stationCode: 'TNM',
    stationName: 'Tiruvannamalai',
  );
});
