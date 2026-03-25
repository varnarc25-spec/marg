import '../../data/models/car_payment_history_item.dart';

bool carHomeIsPaidLikeHistoryStatus(CarPaymentHistoryItem e) {
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
