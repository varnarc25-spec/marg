import 'models/bike_biller_model.dart';

/// A single insurance plan offer (insurer, IDV, price).
/// Built from API billers via [fromBillers].
class BikeInsurancePlan {
  const BikeInsurancePlan({
    required this.id,
    required this.insurerName,
    required this.idv,
    required this.price,
    this.tag,
    this.insurerCode,
    this.logoUrl,
    this.fetchSupported = false,
  });

  final String id;
  final String insurerName;
  final int idv;
  final int price;
  final String? tag;
  /// Biller code from API (e.g. HDFC-ERGO-BIKE).
  final String? insurerCode;
  final String? logoUrl;
  final bool fetchSupported;

  /// One plan per insurer from [billers]. IDV/price are derived from
  /// [normalizedPlate] + biller id until a quotes API exists.
  static List<BikeInsurancePlan> fromBillers(
    List<BikeBiller> billers,
    String normalizedPlate,
  ) {
    final h = _plateHash(normalizedPlate);
    return billers.asMap().entries.map((e) {
      final index = e.key;
      final b = e.value;
      final hi = h + index * 17 + _plateHash(b.id);
      return BikeInsurancePlan(
        id: b.id,
        insurerName: b.name,
        insurerCode: b.code,
        logoUrl: (b.logoUrl != null && b.logoUrl!.trim().isNotEmpty)
            ? b.logoUrl
            : null,
        fetchSupported: b.fetchSupported,
        idv: 800000 + (hi % 900000),
        price: 5000 + (hi % 15000),
        tag: (b.category != null && b.category!.trim().isNotEmpty)
            ? b.category!.trim()
            : null,
      );
    }).toList();
  }

  static int _plateHash(String normalized) {
    var h = 0;
    for (final u in normalized.codeUnits) {
      h = 0x1fffffff & (h + u);
      h = 0x1fffffff & (h + ((0x0007ffff & h) << 10));
      h ^= h >> 6;
    }
    h = 0x1fffffff & (h + ((0x03ffffff & h) << 3));
    h ^= h >> 11;
    return h.abs();
  }
}
