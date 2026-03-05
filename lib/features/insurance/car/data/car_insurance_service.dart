import 'car_insurance_plan.dart';
import 'car_vehicle_model.dart';

/// Mock service for car insurance vehicle lookup and plans.
/// Simulates a 2-second API delay; returns data only for KA01KA1234.
class CarInsuranceService {
  static const String _mockVehicleNumber = 'KA01KA1234';
  static const Duration _mockDelay = Duration(seconds: 2);

  /// Fetches vehicle details by registration number.
  /// Returns [CarVehicleModel] for KA01KA1234, otherwise throws "Vehicle not found".
  Future<CarVehicleModel> getVehicleDetails(String vehicleNumber) async {
    await Future.delayed(_mockDelay);
    final normalized = vehicleNumber.trim().toUpperCase().replaceAll(
      RegExp(r'\s+'),
      '',
    );
    if (normalized != _mockVehicleNumber) {
      throw Exception('Vehicle not found');
    }
    return CarVehicleModel(
      ownerName: 'Ravi Kumar',
      model: 'Maruti Baleno Alpha',
      registrationDate: _regDate,
      insuranceExpiry: _expiryDate,
    );
  }

  /// Fetches available plans for the given vehicle number.
  /// Returns mock plans only when vehicle is valid (KA01KA1234).
  Future<List<CarInsurancePlan>> getPlans(String vehicleNumber) async {
    await Future.delayed(_mockDelay);
    final normalized = vehicleNumber.trim().toUpperCase().replaceAll(
      RegExp(r'\s+'),
      '',
    );
    if (normalized != _mockVehicleNumber) {
      throw Exception('Vehicle not found');
    }
    return [
      const CarInsurancePlan(
        id: 'godigit_car_1',
        insurerName: 'GoDigit',
        idv: 485000,
        price: 12450,
        priceThirdParty: 7897,
      ),
      const CarInsurancePlan(
        id: 'sbi_car_1',
        insurerName: 'SBI General',
        idv: 492000,
        price: 12100,
        priceThirdParty: 7897,
        tag: 'Best Value',
      ),
      const CarInsurancePlan(
        id: 'acko_car_1',
        insurerName: 'Acko',
        idv: 478000,
        price: 12380,
        priceThirdParty: 7897,
      ),
      const CarInsurancePlan(
        id: 'icici_car_1',
        insurerName: 'ICICI Lombard',
        idv: 500000,
        price: 12900,
        priceThirdParty: 8217,
      ),
      const CarInsurancePlan(
        id: 'hdfc_car_1',
        insurerName: 'HDFC Ergo',
        idv: 490000,
        price: 12560,
        priceThirdParty: 8217,
      ),
      const CarInsurancePlan(
        id: 'tata_car_1',
        insurerName: 'Tata AIG General',
        idv: 488000,
        price: 12680,
        priceThirdParty: 8217,
      ),
      const CarInsurancePlan(
        id: 'united_car_1',
        insurerName: 'United India Insurance',
        idv: 482000,
        price: 12420,
        priceThirdParty: 8217,
      ),
      const CarInsurancePlan(
        id: 'bajaj_car_1',
        insurerName: 'Bajaj General Insurance',
        idv: 495000,
        price: 12750,
        priceThirdParty: 8217,
      ),
    ];
  }

  static final _regDate = DateTime(2022, 3, 15);
  static final _expiryDate = DateTime(2025, 4, 20);
}
