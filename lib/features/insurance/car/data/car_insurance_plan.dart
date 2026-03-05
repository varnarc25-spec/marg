/// A single car insurance plan offer (insurer, IDV, prices by plan type).
class CarInsurancePlan {
  final String id;
  final String insurerName;
  final int idv;
  /// Comprehensive plan price (IDV-based).
  final int price;
  /// Third party only plan price.
  final int priceThirdParty;
  final String? tag;

  const CarInsurancePlan({
    required this.id,
    required this.insurerName,
    required this.idv,
    required this.price,
    required this.priceThirdParty,
    this.tag,
  });

  /// Effective price for display based on plan type and add-ons.
  int effectivePrice(String planType, {bool personalAccident = false}) {
    final base = planType == 'Third Party' ? priceThirdParty : price;
    return base + (personalAccident ? 500 : 0);
  }
}
