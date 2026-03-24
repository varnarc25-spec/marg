const String kEducationApiErrorMessage = 'Something went wrong';

class EducationApiException implements Exception {
  EducationApiException([this.userMessage = kEducationApiErrorMessage]);

  final String userMessage;

  @override
  String toString() => userMessage;
}

String educationApiUserMessage(Object error) {
  if (error is EducationApiException) return error.userMessage;
  return kEducationApiErrorMessage;
}
