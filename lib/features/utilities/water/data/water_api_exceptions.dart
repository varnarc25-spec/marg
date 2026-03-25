const String kWaterApiErrorMessage = 'Something went wrong';

class WaterApiException implements Exception {
  WaterApiException([this.userMessage = kWaterApiErrorMessage]);

  final String userMessage;

  @override
  String toString() => userMessage;
}

String waterApiUserMessage(Object error) {
  if (error is WaterApiException) return error.userMessage;
  return kWaterApiErrorMessage;
}
