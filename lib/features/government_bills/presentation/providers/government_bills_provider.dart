import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/tax_property.dart';
import '../../data/repositories/government_bills_repository.dart';

final governmentBillsRepositoryProvider = Provider<GovernmentBillsRepository>((ref) => GovernmentBillsRepository());
final governmentBillsPropertiesProvider = FutureProvider<List<TaxProperty>>((ref) => ref.read(governmentBillsRepositoryProvider).getProperties());
final selectedGovernmentPropertyProvider = StateProvider<TaxProperty?>((ref) => null);
final governmentBillDetailProvider = StateProvider<Map<String, dynamic>?>((ref) => null);
