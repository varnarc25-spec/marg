const String kCardRepayApiErrorMessage = 'Something went wrong';

class CardRepayApiException implements Exception {
  CardRepayApiException([this.userMessage = kCardRepayApiErrorMessage]);

  final String userMessage;

  @override
  String toString() => userMessage;
}

String cardRepayApiUserMessage(Object error) {
  if (error is CardRepayApiException) return error.userMessage;
  return kCardRepayApiErrorMessage;
}
