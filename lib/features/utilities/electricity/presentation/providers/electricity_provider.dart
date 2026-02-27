import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/electricity_bill.dart';
import '../../data/models/electricity_biller.dart';
import '../../data/models/electricity_state.dart';
import '../../data/repositories/electricity_repository.dart';

final electricityRepositoryProvider = Provider<ElectricityRepository>((ref) => ElectricityRepository());
final electricityStatesProvider = FutureProvider<List<ElectricityState>>((ref) => ref.read(electricityRepositoryProvider).getStates());
final electricityBillersProvider = FutureProvider.family<List<ElectricityBiller>, String>((ref, stateId) => ref.read(electricityRepositoryProvider).getBillers(stateId));

final selectedElectricityStateProvider = StateProvider<ElectricityState?>((ref) => null);
final selectedElectricityBillerProvider = StateProvider<ElectricityBiller?>((ref) => null);
final electricityConsumerIdProvider = StateProvider<String>((ref) => '');
final fetchedElectricityBillProvider = StateProvider<ElectricityBill?>((ref) => null);
