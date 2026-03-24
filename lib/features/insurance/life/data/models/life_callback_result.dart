/// Parsed from `POST /api/insurance/life/callback` success body.
class LifeCallbackResult {
  const LifeCallbackResult({
    required this.message,
    this.requestId,
    this.status,
  });

  final String message;
  final String? requestId;
  final String? status;
}
