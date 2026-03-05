/// Origin or destination for train search (station code + name).
class TrainStationResult {
  const TrainStationResult({
    required this.stationCode,
    required this.stationName,
  });

  final String stationCode;
  final String stationName;
}
