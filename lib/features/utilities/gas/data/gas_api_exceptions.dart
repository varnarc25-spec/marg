const String kGasApiErrorMessage = 'Something went wrong';

class GasApiException implements Exception {
  GasApiException([this.userMessage = kGasApiErrorMessage]);

  final String userMessage;

  @override
  String toString() => userMessage;
}

String gasApiUserMessage(Object error) {
  if (error is GasApiException) return error.userMessage;
  return kGasApiErrorMessage;
}
