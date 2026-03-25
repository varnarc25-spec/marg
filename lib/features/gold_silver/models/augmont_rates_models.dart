class AugmontTax {
  final String type;
  final String taxPerc;

  const AugmontTax({
    required this.type,
    required this.taxPerc,
  });

  factory AugmontTax.fromJson(Map<String, dynamic> json) {
    return AugmontTax(
      type: json['type']?.toString() ?? '',
      taxPerc: json['taxPerc']?.toString() ?? '',
    );
  }
}

class AugmontRatesValues {
  final String gBuy;
  final String gSell;
  final String sBuy;
  final String sSell;
  final String gBuyGst;
  final String sBuyGst;

  const AugmontRatesValues({
    required this.gBuy,
    required this.gSell,
    required this.sBuy,
    required this.sSell,
    required this.gBuyGst,
    required this.sBuyGst,
  });

  factory AugmontRatesValues.fromJson(Map<String, dynamic> json) {
    return AugmontRatesValues(
      gBuy: json['gBuy']?.toString() ?? '0',
      gSell: json['gSell']?.toString() ?? '0',
      sBuy: json['sBuy']?.toString() ?? '0',
      sSell: json['sSell']?.toString() ?? '0',
      gBuyGst: json['gBuyGst']?.toString() ?? '0',
      sBuyGst: json['sBuyGst']?.toString() ?? '0',
    );
  }
}

/// Response model for GET /rates (or /api/account/augmont/rates).
class AugmontRates {
  final AugmontRatesValues rates;
  final List<AugmontTax> taxes;
  final String blockId;
  final bool isMock;

  const AugmontRates({
    required this.rates,
    required this.taxes,
    required this.blockId,
    this.isMock = false,
  });

  factory AugmontRates.fromJson(Map<String, dynamic> json) {
    final taxesJson = json['taxes'];
    return AugmontRates(
      rates: AugmontRatesValues.fromJson(
        (json['rates'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      taxes: taxesJson is List
          ? taxesJson
              .whereType<Map>()
              .map((e) => AugmontTax.fromJson(e.cast<String, dynamic>()))
              .toList()
          : const <AugmontTax>[],
      blockId: json['blockId']?.toString() ?? '',
      isMock: json['_mock'] == true,
    );
  }
}

/// Response model for GET /sip/rates (or /api/account/augmont/sip/rates).
class AugmontSipRates {
  final String gBuy;
  final String sBuy;
  final String gBuyGst;
  final String sBuyGst;
  final List<AugmontTax> taxes;
  final String blockId;

  const AugmontSipRates({
    required this.gBuy,
    required this.sBuy,
    required this.gBuyGst,
    required this.sBuyGst,
    required this.taxes,
    required this.blockId,
  });

  factory AugmontSipRates.fromJson(Map<String, dynamic> json) {
    final rates = (json['rates'] as Map?)?.cast<String, dynamic>() ?? const {};
    final taxesJson = json['taxes'];
    return AugmontSipRates(
      gBuy: rates['gBuy']?.toString() ?? '0',
      sBuy: rates['sBuy']?.toString() ?? '0',
      gBuyGst: rates['gBuyGst']?.toString() ?? '0',
      sBuyGst: rates['sBuyGst']?.toString() ?? '0',
      taxes: taxesJson is List
          ? taxesJson
              .whereType<Map>()
              .map((e) => AugmontTax.fromJson(e.cast<String, dynamic>()))
              .toList()
          : const <AugmontTax>[],
      blockId: json['blockId']?.toString() ?? '',
    );
  }
}

