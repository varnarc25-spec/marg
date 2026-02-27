import '../models/tax_property.dart';

/// Government & tax payments. TODO: BBPS/govt biller API.
class GovernmentBillsRepository {
  Future<List<TaxProperty>> getProperties() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const TaxProperty(id: '1', name: 'Flat 101, Mumbai', type: 'property'),
      const TaxProperty(id: '2', name: 'KA01AB1234', type: 'vehicle'),
    ];
  }

  Future<List<Map<String, String>>> getTaxTypes(String propertyId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      {'id': 'property_tax', 'name': 'Property Tax'},
      {'id': 'water_tax', 'name': 'Water Tax'},
      {'id': 'other', 'name': 'Other'},
    ];
  }

  Future<Map<String, dynamic>?> fetchBill(String propertyId, String taxTypeId) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'amount': 3500,
      'penalty': 100,
      'interest': 50,
      'dueDate': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
    };
  }
}
