import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/bike_insurance_plan.dart';
import '../../data/bike_insurance_service.dart';
import '../../data/bike_vehicle_model.dart';

/// States for bike vehicle lookup.
sealed class BikeVehicleState {}

class BikeVehicleInitial extends BikeVehicleState {}

class BikeVehicleLoading extends BikeVehicleState {}

class BikeVehicleSuccess extends BikeVehicleState {
  final BikeVehicleModel vehicle;
  final List<BikeInsurancePlan> plans;

  BikeVehicleSuccess(this.vehicle, this.plans);
}

class BikeVehicleError extends BikeVehicleState {
  final String message;

  BikeVehicleError(this.message);
}

class BikeVehicleNotifier extends StateNotifier<BikeVehicleState> {
  BikeVehicleNotifier(this._service) : super(BikeVehicleInitial());

  final BikeInsuranceService _service;

  Future<void> checkDetails(String vehicleNumber) async {
    if (vehicleNumber.trim().isEmpty) {
      state = BikeVehicleError('Please enter vehicle number');
      return;
    }
    state = BikeVehicleLoading();
    try {
      final vehicle = await _service.getVehicleDetails(vehicleNumber);
      final plans = await _service.getPlans(vehicleNumber);
      state = BikeVehicleSuccess(vehicle, plans);
    } catch (e) {
      state = BikeVehicleError(
        e is Exception
            ? e.toString().replaceFirst('Exception: ', '')
            : 'Vehicle not found',
      );
    }
  }

  void reset() {
    state = BikeVehicleInitial();
  }
}

final bikeInsuranceServiceProvider = Provider<BikeInsuranceService>((ref) {
  return BikeInsuranceService();
});

final bikeVehicleProvider =
    StateNotifierProvider<BikeVehicleNotifier, BikeVehicleState>((ref) {
      final service = ref.watch(bikeInsuranceServiceProvider);
      return BikeVehicleNotifier(service);
    });

/// Selected plan for review/payment step.
final selectedBikePlanProvider = StateProvider<BikeInsurancePlan?>(
  (ref) => null,
);

/// Last vehicle number entered (for display on Select Plan page).
final bikeVehicleNumberProvider = StateProvider<String>((ref) => '');

/// Selected bike name from "Find Your Bike" page (for display on Select Plan).
final selectedBikeNameProvider = StateProvider<String?>((ref) => null);
