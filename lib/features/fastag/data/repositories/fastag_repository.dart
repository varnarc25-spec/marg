import '../models/vehicle_model.dart';

/// FASTag & vehicle payments. TODO: NPCI/FASTag API integration.
class FastagRepository {
  Future<List<VehicleModel>> getVehicles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const VehicleModel(id: '1', number: 'KA01AB1234', tagId: 'TAG***001', balance: 450),
      const VehicleModel(id: '2', number: 'MH02CD5678', tagId: 'TAG***002', balance: 120),
    ];
  }

  Future<List<Map<String, dynamic>>> getTollHistory(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      {'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(), 'toll': 'Mumbai Entry', 'amount': 65},
      {'date': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(), 'toll': 'Pune Exit', 'amount': 45},
    ];
  }

  Future<bool> recharge(String vehicleId, double amount) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
