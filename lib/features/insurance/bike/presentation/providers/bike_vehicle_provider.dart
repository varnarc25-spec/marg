import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/bike_insurance_plan.dart';
import '../../data/models/bike_biller_model.dart';
import '../../data/models/bike_vehicle_model.dart';
import '../../data/services/bike_insurance_api_service.dart';
import 'bike_biller_provider.dart';

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
  BikeVehicleNotifier(this._api) : super(BikeVehicleInitial());

  final BikeInsuranceApiService _api;

  Future<void> checkDetails(String vehicleNumber) async {
    if (vehicleNumber.trim().isEmpty) {
      state = BikeVehicleError('Please enter vehicle number');
      return;
    }

    final normalized = BikeInsuranceApiService.normalizePlate(vehicleNumber);
    if (normalized.length < 4) {
      state = BikeVehicleError(
        'Enter a valid registration number (at least 4 characters)',
      );
      return;
    }
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(normalized)) {
      state = BikeVehicleError('Use only letters and numbers');
      return;
    }

    state = BikeVehicleLoading();
    try {
      // Load insurers first; vehicle lookup is optional and can hang on some hosts.
      final billers = await _api.fetchBillers();

      if (billers.isEmpty) {
        state = BikeVehicleError(
          'No insurers available. Please try again later.',
        );
        return;
      }

      BikeVehicleModel? vehicleFromApi;
      try {
        vehicleFromApi = await _api
            .fetchVehicleDetails(normalized)
            .timeout(const Duration(seconds: 18));
      } on TimeoutException catch (_) {
        vehicleFromApi = null;
      } catch (e) {
        // Network / parse issues should not block plan list if billers loaded.
        vehicleFromApi = null;
              }

      final vehicle =
          vehicleFromApi ?? BikeVehicleModel.registrationOnly(normalized);
      final sortedBillers = List<BikeBiller>.from(billers)
        ..sort((a, b) => a.name.compareTo(b.name));
      final plans = BikeInsurancePlan.fromBillers(sortedBillers, normalized);

      state = BikeVehicleSuccess(vehicle, plans);
    } catch (e) {
      state = BikeVehicleError(
        e is Exception
            ? e.toString().replaceFirst('Exception: ', '')
            : 'Something went wrong',
      );
    }
  }

  void reset() {
    state = BikeVehicleInitial();
  }
}

final bikeVehicleProvider =
    StateNotifierProvider<BikeVehicleNotifier, BikeVehicleState>((ref) {
  final api = ref.watch(bikeInsuranceApiServiceProvider);
  return BikeVehicleNotifier(api);
});

/// Selected plan for review/payment step.
final selectedBikePlanProvider = StateProvider<BikeInsurancePlan?>(
  (ref) => null,
);

/// Last vehicle number entered (for display on Select Plan page).
final bikeVehicleNumberProvider = StateProvider<String>((ref) => '');

/// Selected bike name from "Find Your Bike" page (for display on Select Plan).
final selectedBikeNameProvider = StateProvider<String?>((ref) => null);
