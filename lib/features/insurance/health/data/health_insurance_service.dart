import 'health_insurance_plan.dart';

/// Mock service for health insurance: fetches plans based on selected family members.
class HealthInsuranceService {
  static const Duration _mockDelay = Duration(seconds: 2);

  /// Fetches available health plans for the given member types.
  /// [memberTypes] e.g. ['Myself'], ['Myself', 'Spouse'], etc.
  Future<List<HealthInsurancePlan>> getPlans(List<String> memberTypes) async {
    await Future.delayed(_mockDelay);
    if (memberTypes.isEmpty) {
      return [];
    }
    return [
      const HealthInsurancePlan(
        id: 'aditya_health_1',
        insurerName: 'Aditya Birla Health',
        coverLakhs: 5,
        priceMonthly: 449,
        tag: 'Best Value',
      ),
      const HealthInsurancePlan(
        id: 'bajaj_health_1',
        insurerName: 'Bajaj Allianz',
        coverLakhs: 5,
        priceMonthly: 468,
      ),
      const HealthInsurancePlan(
        id: 'digit_health_1',
        insurerName: 'Digit',
        coverLakhs: 5,
        priceMonthly: 424,
      ),
      const HealthInsurancePlan(
        id: 'icici_health_1',
        insurerName: 'ICICI Lombard',
        coverLakhs: 5,
        priceMonthly: 512,
      ),
      const HealthInsurancePlan(
        id: 'reliance_health_1',
        insurerName: 'Reliance General',
        coverLakhs: 5,
        priceMonthly: 485,
      ),
      const HealthInsurancePlan(
        id: 'star_health_1',
        insurerName: 'Star Health',
        coverLakhs: 5,
        priceMonthly: 498,
      ),
      const HealthInsurancePlan(
        id: 'hdfc_health_1',
        insurerName: 'HDFC Ergo',
        coverLakhs: 5,
        priceMonthly: 535,
      ),
      const HealthInsurancePlan(
        id: 'care_health_1',
        insurerName: 'Care Health',
        coverLakhs: 5,
        priceMonthly: 478,
      ),
    ];
  }
}
