/// User-facing copy for FASTag API failures (`success: false` or HTTP errors).
const String kFastagDataNotFoundMessage = 'Data Not Found';

/// Thrown when the FASTag API returns an error envelope or non-success HTTP status.
class FastagApiException implements Exception {
  FastagApiException([this.userMessage = kFastagDataNotFoundMessage]);

  final String userMessage;

  @override
  String toString() => userMessage;
}

/// Maps any error to the FASTag UI string (per product requirement).
String fastagApiUserMessage(Object error) {
  if (error is FastagApiException) return error.userMessage;
  return kFastagDataNotFoundMessage;
}
