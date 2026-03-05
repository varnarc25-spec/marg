import 'bike_insurance_plan.dart';
import 'bike_vehicle_model.dart';

/// Mock service for bike insurance vehicle lookup and plans.
/// Simulates a 2-second API delay; returns data only for KA01AB1234.
class BikeInsuranceService {
  static const String _mockVehicleNumber = 'KA01AB1234';
  static const Duration _mockDelay = Duration(seconds: 2);

  /// Fetches vehicle details by registration number.
  /// Returns [BikeVehicleModel] for KA01AB1234, otherwise throws "Vehicle not found".
  Future<BikeVehicleModel> getVehicleDetails(String vehicleNumber) async {
    await Future.delayed(_mockDelay);
    final normalized = vehicleNumber.trim().toUpperCase().replaceAll(
      RegExp(r'\s+'),
      '',
    );
    if (normalized != _mockVehicleNumber) {
      throw Exception('Vehicle not found');
    }
    return BikeVehicleModel(
      ownerName: 'Ravi Kumar',
      model: 'Honda Activa 6G',
      registrationDate: _regDate,
      insuranceExpiry: _expiryDate,
    );
  }

  /// Fetches available plans for the given vehicle number.
  /// Returns mock plans only when vehicle is valid (KA01AB1234).
  Future<List<BikeInsurancePlan>> getPlans(String vehicleNumber) async {
    await Future.delayed(_mockDelay);
    final normalized = vehicleNumber.trim().toUpperCase().replaceAll(
      RegExp(r'\s+'),
      '',
    );
    if (normalized != _mockVehicleNumber) {
      throw Exception('Vehicle not found');
    }
    return [
      const BikeInsurancePlan(
        id: 'hdfc_1',
        insurerName: 'HDFC ERGO',
        idv: 1561680,
        price: 10003,
      ),
      const BikeInsurancePlan(
        id: 'iffco_1',
        insurerName: 'IFFCO TOKIO',
        idv: 1123200,
        price: 19374,
      ),
      const BikeInsurancePlan(
        id: 'iffco_2',
        insurerName: 'IFFCO TOKIO',
        idv: 1728000,
        price: 29120,
      ),
      const BikeInsurancePlan(
        id: 'hdfc_2',
        insurerName: 'HDFC ERGO',
        idv: 1561680,
        price: 10323,
      ),
      const BikeInsurancePlan(
        id: 'iffco_3',
        insurerName: 'IFFCO TOKIO',
        idv: 1123200,
        price: 16570,
      ),
      const BikeInsurancePlan(
        id: 'iffco_4',
        insurerName: 'IFFCO TOKIO',
        idv: 1123200,
        price: 18929,
      ),
      const BikeInsurancePlan(
        id: 'godigit_1',
        insurerName: 'GoDigit',
        idv: 1284800,
        price: 10339,
      ),
      const BikeInsurancePlan(
        id: 'sbi_1',
        insurerName: 'SBI General',
        idv: 1123200,
        price: 10335,
        tag: 'Own Damage @Re 1',
      ),
      const BikeInsurancePlan(
        id: 'acko_1',
        insurerName: 'Acko',
        idv: 963700,
        price: 10337,
      ),
    ];
  }

  static final _regDate = DateTime(2021, 4, 12);
  static final _expiryDate = DateTime(2025, 5, 10);
}
