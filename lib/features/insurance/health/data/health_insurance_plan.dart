/// A single health insurance plan offer (insurer, cover amount, optional monthly price).
class HealthInsurancePlan {
  final String id;
  final String insurerName;
  /// Insurer code from API (e.g. ABHI).
  final String? insurerCode;
  final String? logoUrl;
  /// Cover amount in lakhs (e.g. 5 = 5 lakh). Default when API does not send sum insured.
  final int coverLakhs;
  /// Monthly premium in rupees; null when API returns partners only (show "Premium on quote").
  final int? priceMonthly;
  final String? tag;
  /// Bullet highlights for list UI (from API benefits/highlights).
  final List<String> highlights;
  /// Cashless network size when API sends it.
  final int? hospitalCount;
  /// e.g. "96.26% claim settlement rate"
  final String? claimSettlementRateLabel;

  const HealthInsurancePlan({
    required this.id,
    required this.insurerName,
    this.insurerCode,
    this.logoUrl,
    this.coverLakhs = 5,
    this.priceMonthly,
    this.tag,
    this.highlights = const [],
    this.hospitalCount,
    this.claimSettlementRateLabel,
  });
}
