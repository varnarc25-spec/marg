import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/health_insurance_plan.dart';
import '../../data/health_insurance_service.dart';

/// Selected family member keys. Default: ['Myself'].
const List<String> defaultHealthMembers = ['Myself'];

/// States for health plans fetch.
sealed class HealthPlansState {}

class HealthPlansInitial extends HealthPlansState {}

class HealthPlansLoading extends HealthPlansState {}

class HealthPlansSuccess extends HealthPlansState {
  final List<HealthInsurancePlan> plans;

  HealthPlansSuccess(this.plans);
}

class HealthPlansError extends HealthPlansState {
  final String message;

  HealthPlansError(this.message);
}

class HealthPlansNotifier extends StateNotifier<HealthPlansState> {
  HealthPlansNotifier(this._service) : super(HealthPlansInitial());

  final HealthInsuranceService _service;

  Future<void> fetchPlans(List<String> memberTypes) async {
    if (memberTypes.isEmpty) {
      state = HealthPlansError('Select at least one family member');
      return;
    }
    state = HealthPlansLoading();
    try {
      final plans = await _service.getPlans(memberTypes);
      state = HealthPlansSuccess(plans);
    } catch (e) {
      state = HealthPlansError(
        e is Exception
            ? e.toString().replaceFirst('Exception: ', '')
            : 'Unable to fetch plans',
      );
    }
  }

  void reset() {
    state = HealthPlansInitial();
  }
}

final healthInsuranceServiceProvider = Provider<HealthInsuranceService>((ref) {
  return HealthInsuranceService();
});

final healthPlansProvider =
    StateNotifierProvider<HealthPlansNotifier, HealthPlansState>((ref) {
  final service = ref.watch(healthInsuranceServiceProvider);
  return HealthPlansNotifier(service);
});

/// Selected family members for health insurance (e.g. ['Myself'], ['Myself', 'Spouse']).
final healthSelectedMembersProvider = StateProvider<List<String>>((ref) {
  return List.from(defaultHealthMembers);
});

/// Selected plan for review/payment step.
final selectedHealthPlanProvider = StateProvider<HealthInsurancePlan?>(
  (ref) => null,
);

/// Form state for "Let's find your perfect plan" details page.
/// Fields shown/hidden based on [healthSelectedMembersProvider].
class HealthDetailsFormState {
  final String? elderAge;
  final int childrenCount;
  final List<String?> parentAges;
  final String pincode;
  final bool? preExistingDisease;
  final bool advisoryConsent;

  const HealthDetailsFormState({
    this.elderAge,
    this.childrenCount = 0,
    this.parentAges = const [],
    this.pincode = '',
    this.preExistingDisease,
    this.advisoryConsent = false,
  });

  HealthDetailsFormState copyWith({
    String? elderAge,
    int? childrenCount,
    List<String?>? parentAges,
    String? pincode,
    bool? preExistingDisease,
    bool? advisoryConsent,
  }) {
    return HealthDetailsFormState(
      elderAge: elderAge ?? this.elderAge,
      childrenCount: childrenCount ?? this.childrenCount,
      parentAges: parentAges ?? this.parentAges,
      pincode: pincode ?? this.pincode,
      preExistingDisease: preExistingDisease ?? this.preExistingDisease,
      advisoryConsent: advisoryConsent ?? this.advisoryConsent,
    );
  }
}

final healthDetailsFormProvider =
    StateProvider<HealthDetailsFormState>((ref) => const HealthDetailsFormState());
