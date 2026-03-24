/// Thrown when the API returns HTTP 200 but `success: false` in the JSON body.
/// UI should show a friendly message (e.g. "Not found"), not the raw server error.
class LifeApiUnsuccessfulResponse implements Exception {
  const LifeApiUnsuccessfulResponse();

  @override
  String toString() => 'LifeApiUnsuccessfulResponse';
}

/// User-facing copy for life API failures (avoids exposing raw exception text).
String lifeInsuranceApiUserMessage(Object error) {
  if (error is LifeApiUnsuccessfulResponse) return 'Not found';
  final s = error.toString();
  return s.replaceFirst('Exception: ', '');
}
