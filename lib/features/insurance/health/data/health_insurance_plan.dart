/// A single health insurance plan offer (insurer, cover amount, monthly price).
class HealthInsurancePlan {
  final String id;
  final String insurerName;
  /// Cover amount in lakhs (e.g. 5 = 5 lakh).
  final int coverLakhs;
  /// Monthly premium in rupees.
  final int priceMonthly;
  final String? tag;

  const HealthInsurancePlan({
    required this.id,
    required this.insurerName,
    required this.coverLakhs,
    required this.priceMonthly,
    this.tag,
  });
}
