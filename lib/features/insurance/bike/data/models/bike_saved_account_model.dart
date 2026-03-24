/// Model for a saved payment account/card/UPI used for bike insurance.
///
/// Since the backend response shape may vary, this model uses flexible
/// parsing from common keys.
class BikeSavedAccount {
  const BikeSavedAccount({
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

  static BikeSavedAccount fromJson(Map<String, dynamic> json) {
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
    // Backend uses `label` for the saved account name/title.
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

    final isDefault = pickBool(const ['isDefault', 'default', 'defaultAccount']);

    final title = name.isNotEmpty
        ? name
        : (bankName.isNotEmpty ? bankName : (upiId.isNotEmpty ? upiId : id));

    // Show consumer name in UI (sample API response contains `consumerName`).
    final subtitle = consumerName.isNotEmpty
        ? consumerName
        : (bankName.isNotEmpty ? accountType : null);

    return BikeSavedAccount(
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

