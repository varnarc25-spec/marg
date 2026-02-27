import '../models/rent_property.dart';

/// Rent & society payments. TODO: Payment gateway & mandate for AutoPay.
class RentRepository {
  Future<List<RentProperty>> getProperties() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const RentProperty(
        id: '1',
        address: 'Flat 101, Tower A, Mumbai',
        ownerName: 'Owner Name',
        ownerPhone: '9876543210',
        monthlyRent: 25000,
        autopayEnabled: false,
      ),
    ];
  }

  Future<bool> payRent(String propertyId, double amount) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
