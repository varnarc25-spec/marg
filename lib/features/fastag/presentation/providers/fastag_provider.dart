import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/repositories/fastag_repository.dart';

final fastagRepositoryProvider = Provider<FastagRepository>((ref) => FastagRepository());
final fastagVehiclesProvider = FutureProvider<List<VehicleModel>>((ref) => ref.read(fastagRepositoryProvider).getVehicles());
final selectedFastagVehicleProvider = StateProvider<VehicleModel?>((ref) => null);
