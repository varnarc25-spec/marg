/// Model representing one saved car insurance payment history row.
///
/// Backend response keys may vary between `id`, `paymentId`, etc., so this
/// model does tolerant parsing similar to the bike implementation.
class CarPaymentHistoryItem {
  const CarPaymentHistoryItem({
    required this.id,
    required this.registrationNumber,
    required this.insurerName,
    required this.amount,
    required this.status,
    required this.paidAt,
    this.transactionId,
    this.paymentMethod,
  });

  final String id;
  final String registrationNumber;
  final String insurerName;
  final int amount;
  final String status;
  final DateTime paidAt;
  final String? transactionId;
  final String? paymentMethod;

  static CarPaymentHistoryItem fromJson(Map<String, dynamic> json) {
    String readString(List<String> keys, {String fallback = ''}) {
      for (final key in keys) {
        final value = json[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }
      return fallback;
    }

    int readInt(List<String> keys, {int fallback = 0}) {
      for (final key in keys) {
        final value = json[key];
        if (value is int) return value;
        final parsed = int.tryParse(value?.toString() ?? '');
        if (parsed != null) return parsed;
      }
      return fallback;
    }

    DateTime readDate(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) continue;
        if (value is int) {
          return DateTime.fromMillisecondsSinceEpoch(value);
        }
        final parsed = DateTime.tryParse(value.toString());
        if (parsed != null) return parsed;
      }
      return DateTime.now();
    }

    String? readNullableString(List<String> keys) {
      final s = readString(keys, fallback: '');
      return s.isEmpty ? null : s;
    }

    return CarPaymentHistoryItem(
      id: readString(['id', 'historyId', 'paymentId'], fallback: ''),
      registrationNumber: readString(
        ['registrationNumber', 'vehicleNumber', 'regNo', 'consumerNumber'],
        fallback: '—',
      ),
      insurerName: readString(
        ['insurerName', 'billerName', 'companyName'],
        fallback: 'Car Insurance',
      ),
      amount: readInt(['amount', 'paidAmount', 'premium']),
      status: readString(['status', 'paymentStatus'], fallback: 'Success'),
      paidAt: readDate(['paidAt', 'paymentDate', 'createdAt', 'date']),
      transactionId: readNullableString(['transactionId', 'txnId']),
      paymentMethod:
          readNullableString(['paymentMethod', 'method', 'mode']),
    );
  }
}

