/// Model for a saved payment account/card/UPI used for car insurance.
///
/// Backend response shapes may vary, so parsing is tolerant and maps from
/// common key names (id/accountType/label/name/masked/etc).
class CarSavedAccount {
  const CarSavedAccount({
    required this.id,
    required this.accountType,
    required this.title,
    this.subtitle,
    this.masked,
    this.isDefault = false,
    this.raw,
  });

  final String id;
  final String accountType;
  final String title;
  final String? subtitle;
  final String? masked;
  final bool isDefault;
  final Map<String, dynamic>? raw;

  static CarSavedAccount fromJson(Map<String, dynamic> json) {
    String pickString(List<String> keys, {String fallback = ''}) {
      for (final k in keys) {
        final v = json[k];
        if (v != null && v.toString().trim().isNotEmpty) {
          return v.toString().trim();
        }
      }
      return fallback;
    }

    bool pickBool(List<String> keys, {bool fallback = false}) {
      for (final k in keys) {
        final v = json[k];
        if (v is bool) return v;
        final s = v?.toString().toLowerCase().trim();
        if (s == 'true' || s == '1') return true;
        if (s == 'false' || s == '0') return false;
      }
      return fallback;
    }

    final id = pickString(
      const [
        'id',
        'accountId',
        'savedAccountId',
        'paymentId',
        'payment_account_id',
        'account_id',
      ],
      fallback: '',
    );

    final accountType = pickString(
      const [
        'accountType',
        'type',
        'methodType',
        'paymentMethodType',
        'methodTypeName',
      ],
      fallback: 'payment',
    );

    final bankName = pickString(
      const ['bankName', 'bank', 'issuerName', 'providerName'],
      fallback: '',
    );

    final upiId = pickString(const ['upiId', 'upi', 'vpa'], fallback: '');

    // Backend uses `label` for the saved account name/title in many responses.
    final name = pickString(
      const ['label', 'name', 'displayName', 'title'],
      fallback: '',
    );

    final consumerName = pickString(
      const ['consumerName', 'consumer_name', 'customerName', 'customer_name'],
      fallback: '',
    );

    final masked = pickString(
      const [
        'masked',
        'mask',
        'accountNumber',
        'account_number',
        'cardNumberMasked',
        'cardMaskedNumber',
        'lastFourDigits',
        'lastFour',
        'last4',
        'last_4',
      ],
      fallback: '',
    );

    final isDefault = pickBool(
      const ['isDefault', 'default', 'defaultAccount'],
      fallback: false,
    );

    final title = name.isNotEmpty
        ? name
        : (bankName.isNotEmpty ? bankName : (upiId.isNotEmpty ? upiId : id));

    final subtitle = consumerName.isNotEmpty
        ? consumerName
        : (bankName.isNotEmpty ? accountType : null);

    return CarSavedAccount(
      id: id.isNotEmpty ? id : '${accountType}_unknown',
      accountType: accountType,
      title: title.isNotEmpty ? title : 'Saved account',
      subtitle: subtitle,
      masked: masked.isNotEmpty ? masked : null,
      isDefault: isDefault,
      raw: json,
    );
  }
}

