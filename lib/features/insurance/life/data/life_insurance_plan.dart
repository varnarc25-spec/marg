/// Result of cover calculation: max and recommended sum assured in lakhs.
class LifeCoverResult {
  /// Max sum assured in lakhs (e.g. 300 = ₹3 Crore).
  final int maxCoverLakhs;
  /// Recommended sum assured in lakhs (e.g. 100 = ₹1 Crore).
  final int recommendedCoverLakhs;

  const LifeCoverResult({
    required this.maxCoverLakhs,
    required this.recommendedCoverLakhs,
  });
}
