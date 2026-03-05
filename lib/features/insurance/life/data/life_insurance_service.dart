import 'life_insurance_plan.dart';

/// Mock service for term life: calculate recommended cover from DOB and annual income.
class LifeInsuranceService {
  static const Duration _mockDelay = Duration(seconds: 2);
  static const int maxCoverLakhs = 300; // ₹3 Crore
  static const int minCoverLakhs = 25;  // ₹25 Lakh

  /// Returns recommended cover. [annualIncome] in rupees (e.g. 1000000).
  /// Recommended = 10x income, capped at max; min 25 lakh.
  Future<LifeCoverResult> getRecommendedCover({
    required DateTime dateOfBirth,
    required int annualIncome,
  }) async {
    await Future.delayed(_mockDelay);
    final incomeLakhs = annualIncome / 100000;
    final recommended = (incomeLakhs * 10).round().clamp(minCoverLakhs, maxCoverLakhs);
    return LifeCoverResult(
      maxCoverLakhs: maxCoverLakhs,
      recommendedCoverLakhs: recommended,
    );
  }
}
