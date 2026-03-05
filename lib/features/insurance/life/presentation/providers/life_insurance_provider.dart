import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/life_insurance_plan.dart';
import '../../data/life_insurance_service.dart';

sealed class LifeCoverState {}

class LifeCoverInitial extends LifeCoverState {}

class LifeCoverLoading extends LifeCoverState {}

class LifeCoverSuccess extends LifeCoverState {
  final LifeCoverResult result;

  LifeCoverSuccess(this.result);
}

class LifeCoverError extends LifeCoverState {
  final String message;

  LifeCoverError(this.message);
}

class LifeCoverNotifier extends StateNotifier<LifeCoverState> {
  LifeCoverNotifier(this._service) : super(LifeCoverInitial());

  final LifeInsuranceService _service;

  Future<void> calculateCover({
    required DateTime dateOfBirth,
    required int annualIncome,
  }) async {
    state = LifeCoverLoading();
    try {
      final result = await _service.getRecommendedCover(
        dateOfBirth: dateOfBirth,
        annualIncome: annualIncome,
      );
      state = LifeCoverSuccess(result);
    } catch (e) {
      state = LifeCoverError(
        e is Exception
            ? e.toString().replaceFirst('Exception: ', '')
            : 'Unable to calculate cover',
      );
    }
  }

  void reset() {
    state = LifeCoverInitial();
  }
}

final lifeInsuranceServiceProvider = Provider<LifeInsuranceService>((ref) {
  return LifeInsuranceService();
});

final lifeCoverProvider =
    StateNotifierProvider<LifeCoverNotifier, LifeCoverState>((ref) {
  final service = ref.watch(lifeInsuranceServiceProvider);
  return LifeCoverNotifier(service);
});

/// DOB for life insurance form (null = not set).
final lifeDateOfBirthProvider = StateProvider<DateTime?>((ref) => null);

/// Annual income as string for input (e.g. "10,00,000" or "1000000").
final lifeAnnualIncomeProvider = StateProvider<String>((ref) => '');

/// Advisory consent checkbox.
final lifeAdvisoryConsentProvider = StateProvider<bool>((ref) => false);

/// Selected sum assured in lakhs (for cover page slider).
final lifeSelectedSumAssuredLakhsProvider = StateProvider<int?>((ref) => null);

/// Cover till age (e.g. 60).
final lifeCoverTillAgeProvider = StateProvider<int>((ref) => 60);

/// Available cover till age options.
const List<int> lifeCoverTillAgeOptions = [50, 55, 60, 65, 70];
