import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/car_insurance_plan.dart';
import '../../data/car_insurance_service.dart';
import '../../data/car_vehicle_model.dart';

/// States for car vehicle lookup.
sealed class CarVehicleState {}

class CarVehicleInitial extends CarVehicleState {}

class CarVehicleLoading extends CarVehicleState {}

class CarVehicleSuccess extends CarVehicleState {
  final CarVehicleModel vehicle;
  final List<CarInsurancePlan> plans;

  CarVehicleSuccess(this.vehicle, this.plans);
}

class CarVehicleError extends CarVehicleState {
  final String message;

  CarVehicleError(this.message);
}

class CarVehicleNotifier extends StateNotifier<CarVehicleState> {
  CarVehicleNotifier(this._service) : super(CarVehicleInitial());

  final CarInsuranceService _service;

  Future<void> checkDetails(String vehicleNumber) async {
    if (vehicleNumber.trim().isEmpty) {
      state = CarVehicleError('Please enter vehicle number');
      return;
    }
    state = CarVehicleLoading();
    try {
      final vehicle = await _service.getVehicleDetails(vehicleNumber);
      final plans = await _service.getPlans(vehicleNumber);
      state = CarVehicleSuccess(vehicle, plans);
    } catch (e) {
      state = CarVehicleError(
        e is Exception
            ? e.toString().replaceFirst('Exception: ', '')
            : 'Vehicle not found',
      );
    }
  }

  void reset() {
    state = CarVehicleInitial();
  }
}

final carInsuranceServiceProvider = Provider<CarInsuranceService>((ref) {
  return CarInsuranceService();
});

final carVehicleProvider =
    StateNotifierProvider<CarVehicleNotifier, CarVehicleState>((ref) {
  final service = ref.watch(carInsuranceServiceProvider);
  return CarVehicleNotifier(service);
});

/// Selected plan for review/payment step.
final selectedCarPlanProvider = StateProvider<CarInsurancePlan?>(
  (ref) => null,
);

/// Plan type when user tapped Buy Now ('Comprehensive' or 'Third Party').
final selectedCarPlanTypeProvider = StateProvider<String>((ref) => 'Comprehensive');

/// Personal Accident add-on when user tapped Buy Now.
final selectedCarPersonalAccidentProvider = StateProvider<bool>((ref) => false);

/// Last vehicle number entered (for display on Select Plan page).
final carVehicleNumberProvider = StateProvider<String>((ref) => '');

/// Selected car name from "Find Your Car" page (for display on Select Plan).
final selectedCarNameProvider = StateProvider<String?>((ref) => null);
