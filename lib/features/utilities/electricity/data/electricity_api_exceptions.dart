const String kElectricityApiErrorMessage = 'Something went wrong';

class ElectricityApiException implements Exception {
  ElectricityApiException([this.userMessage = kElectricityApiErrorMessage]);

  final String userMessage;

  @override
  String toString() => userMessage;
}

String electricityApiUserMessage(Object error) {
  if (error is ElectricityApiException) return error.userMessage;
  return kElectricityApiErrorMessage;
}
