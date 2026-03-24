const String kBroadbandApiErrorMessage = 'Something went wrong';

class BroadbandApiException implements Exception {
  BroadbandApiException([this.userMessage = kBroadbandApiErrorMessage]);

  final String userMessage;

  @override
  String toString() => userMessage;
}

String broadbandApiUserMessage(Object error) {
  if (error is BroadbandApiException) return error.userMessage;
  return kBroadbandApiErrorMessage;
}
