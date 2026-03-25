/// Result of `POST /api/insurance/life/calculate-cover` (amounts in lakhs for UI).
class LifeCoverResult {
  const LifeCoverResult({
    required this.minCoverLakhs,
    required this.maxCoverLakhs,
    required this.recommendedCoverLakhs,
    this.idealCoverRationale,
    this.defaultCoverTillAge,
    this.defaultSumAssuredLakhs,
  });

  /// From `minSumAssured` (rupees) → lakhs.
  final int minCoverLakhs;
  /// From `maxSumAssured` (rupees) → lakhs.
  final int maxCoverLakhs;
  /// From `idealRecommendedCover` (rupees) → lakhs.
  final int recommendedCoverLakhs;
  /// e.g. "10x of income"
  final String? idealCoverRationale;
  /// Suggested term end age from API (`defaultCoverTillAge`).
  final int? defaultCoverTillAge;
  /// From `defaultSumAssured` (rupees) → lakhs, if different from ideal.
  final int? defaultSumAssuredLakhs;
}

/// A term plan row from `GET/POST /api/insurance/life/plans`.
class LifeTermPlan {
  const LifeTermPlan({
    required this.id,
    required this.insurerName,
    this.logoUrl,
    this.premiumMonthly,
    this.sumAssuredLakhs,
    this.tag,
    this.highlights = const [],
  });

  final String id;
  final String insurerName;
  final String? logoUrl;
  final int? premiumMonthly;
  final int? sumAssuredLakhs;
  final String? tag;
  final List<String> highlights;
}
