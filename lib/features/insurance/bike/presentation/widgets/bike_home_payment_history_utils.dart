import '../../data/models/bike_payment_history_item.dart';

/// Treat backend status strings as paid-like when not clearly failed.
bool bikeHomeIsPaidLikeHistoryStatus(BikePaymentHistoryItem e) {
  final s = e.status.toLowerCase().trim();
  if (s.isEmpty) return true;
  if (s.contains('fail') ||
      s.contains('error') ||
      s.contains('declin') ||
      s.contains('cancel') ||
      s.contains('reject')) {
    return false;
  }
  return s.contains('success') ||
      s.contains('paid') ||
      s.contains('completed') ||
      s.contains('settled') ||
      s.contains('ok') ||
      s.contains('approved') ||
      s.contains('confirm') ||
      s.contains('done');
}
