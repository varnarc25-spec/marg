import '../models/electricity_bill.dart';
import '../models/electricity_biller.dart';
import '../models/electricity_state.dart';

/// Electricity bill payment. TODO: BBPS integration.
class ElectricityRepository {
  Future<List<ElectricityState>> getStates() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const ElectricityState(id: 'maharashtra', name: 'Maharashtra'),
      const ElectricityState(id: 'karnataka', name: 'Karnataka'),
      const ElectricityState(id: 'delhi', name: 'Delhi'),
      const ElectricityState(id: 'tn', name: 'Tamil Nadu'),
    ];
  }

  Future<List<ElectricityBiller>> getBillers(String stateId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      ElectricityBiller(id: 'msedcl', name: 'MSEDCL', stateId: stateId),
      ElectricityBiller(id: 'best', name: 'BEST', stateId: stateId),
      ElectricityBiller(id: 'tatapower', name: 'Tata Power', stateId: stateId),
    ];
  }

  Future<ElectricityBill?> fetchBill(String billerId, String consumerId) async {
    await Future.delayed(const Duration(seconds: 1));
    return ElectricityBill(
      consumerId: consumerId,
      name: 'Consumer Name',
      amount: 1250,
      dueDate: DateTime.now().add(const Duration(days: 15)),
      breakdown: 'Energy charges: ₹980, Fixed: ₹200, Tax: ₹70',
    );
  }

  Future<bool> payBill({required String billerId, required String consumerId, required double amount}) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
