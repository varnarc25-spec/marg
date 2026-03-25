/// Parsed from `POST /api/insurance/health/callback` success body.
class HealthCallbackResult {
  const HealthCallbackResult({
    required this.message,
    this.requestId,
    this.status,
  });

  final String message;
  final String? requestId;
  final String? status;
}
