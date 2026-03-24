import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/core/services/firebase_auth_service.dart';
import 'package:marg/shared/providers/app_providers.dart';

import '../../data/life_insurance_api_exceptions.dart';
import '../../data/life_insurance_plan.dart';
import '../../data/life_insurance_service.dart';
import '../../data/models/life_benefit_item.dart';
import '../../data/models/life_partner_model.dart';
import '../../data/models/life_promo_model.dart';
import '../../data/services/life_insurance_api_service.dart';

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

/// Age in full years from DOB (for `POST /plans` body).
int lifeAgeInYears(DateTime dateOfBirth) {
  final now = DateTime.now();
  var age = now.year - dateOfBirth.year;
  final hadBirthday = now.month > dateOfBirth.month ||
      (now.month == dateOfBirth.month && now.day >= dateOfBirth.day);
  if (!hadBirthday) age--;
  return age.clamp(0, 120);
}

/// `POST /api/insurance/life/calculate-cover`
Map<String, dynamic> lifeCalculateCoverBody({
  required DateTime dateOfBirth,
  required int annualIncome,
}) {
  return {
    'dateOfBirth': dateOfBirth.toIso8601String().split('T').first,
    'annualIncome': annualIncome,
  };
}

/// `POST /api/insurance/life/recommendation`
Map<String, dynamic> lifeRecommendationBody({
  required DateTime dateOfBirth,
  required int annualIncome,
  required int selectedSumAssuredRupees,
  required int coverTillAge,
}) {
  return {
    'dateOfBirth': dateOfBirth.toIso8601String().split('T').first,
    'annualIncome': annualIncome,
    'selectedSumAssured': selectedSumAssuredRupees,
    'coverTillAge': coverTillAge,
  };
}

/// `POST /api/insurance/life/plans`
Map<String, dynamic> lifePlansSearchBody({
  required DateTime dateOfBirth,
  required int sumAssuredLakhs,
  required int coverTillAge,
  String gender = 'male',
  String occupation = 'salaried',
  String education = 'graduate',
  bool tobaccoConsumer = false,
  String sortBy = 'premium',
}) {
  return {
    'sumAssured': sumAssuredLakhs * 100000,
    'coverTillAge': coverTillAge,
    'dateOfBirth': dateOfBirth.toIso8601String().split('T').first,
    'age': lifeAgeInYears(dateOfBirth),
    'gender': gender,
    'occupation': occupation,
    'education': education,
    'tobaccoConsumer': tobaccoConsumer,
    'sortBy': sortBy,
  };
}

class LifeCoverNotifier extends StateNotifier<LifeCoverState> {
  LifeCoverNotifier(this._api, this._auth, this._fallback)
      : super(LifeCoverInitial());

  final LifeInsuranceApiService _api;
  final FirebaseAuthService _auth;
  final LifeInsuranceService _fallback;

  Future<void> calculateCover({
    required DateTime dateOfBirth,
    required int annualIncome,
  }) async {
    state = LifeCoverLoading();
    try {
      final token = await _auth.getIdToken(forceRefresh: false);
      final body = lifeCalculateCoverBody(
        dateOfBirth: dateOfBirth,
        annualIncome: annualIncome,
      );
      final result = await _api.calculateCover(body, idToken: token);
      state = LifeCoverSuccess(result);
    } on LifeApiUnsuccessfulResponse {
      state = LifeCoverError('Not found');
    } catch (e) {
      debugPrint('Life calculate-cover API failed, using local fallback: $e');
      try {
        final result = await _fallback.getRecommendedCover(
          dateOfBirth: dateOfBirth,
          annualIncome: annualIncome,
        );
        state = LifeCoverSuccess(result);
      } catch (e2) {
        state = LifeCoverError(lifeInsuranceApiUserMessage(e2));
      }
    }
  }

  void reset() {
    state = LifeCoverInitial();
  }
}

final lifeInsuranceApiServiceProvider = Provider<LifeInsuranceApiService>((ref) {
  return LifeInsuranceApiService();
});

final lifeInsuranceServiceProvider = Provider<LifeInsuranceService>((ref) {
  return LifeInsuranceService();
});

final lifeCoverProvider =
    StateNotifierProvider<LifeCoverNotifier, LifeCoverState>((ref) {
  final api = ref.watch(lifeInsuranceApiServiceProvider);
  final auth = ref.watch(firebaseAuthServiceProvider);
  final fallback = ref.watch(lifeInsuranceServiceProvider);
  return LifeCoverNotifier(api, auth, fallback);
});

/// Home: partners, promos, benefits for banners / grids.
final lifeHomeBootstrapProvider = FutureProvider<LifeHomeBootstrap>((ref) async {
  final api = ref.watch(lifeInsuranceApiServiceProvider);
  final auth = ref.watch(firebaseAuthServiceProvider);
  final token = await auth.getIdToken();

  List<LifePartner> partners = const [];
  List<LifePromoBanner> promos = const [];
  List<LifeBenefitItem> benefits = const [];

  try {
    partners = await api.getPartners(idToken: token);
  } catch (_) {}
  try {
    promos = await api.getPromos(idToken: token);
  } catch (_) {}
  try {
    benefits = await api.getBenefits(idToken: token);
  } catch (_) {}

  return LifeHomeBootstrap(
    partners: partners,
    promos: promos,
    benefits: benefits,
  );
});

class LifeHomeBootstrap {
  const LifeHomeBootstrap({
    required this.partners,
    required this.promos,
    required this.benefits,
  });

  final List<LifePartner> partners;
  final List<LifePromoBanner> promos;
  final List<LifeBenefitItem> benefits;
}

/// Optional config for dropdowns / future forms.
final lifeInsuranceConfigProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final api = ref.watch(lifeInsuranceApiServiceProvider);
  final auth = ref.watch(firebaseAuthServiceProvider);
  final token = await auth.getIdToken();
  return api.getConfig(idToken: token);
});

sealed class LifePlansState {}

class LifePlansInitial extends LifePlansState {}

class LifePlansLoading extends LifePlansState {}

class LifePlansSuccess extends LifePlansState {
  final List<LifeTermPlan> plans;

  LifePlansSuccess(this.plans);
}

class LifePlansError extends LifePlansState {
  final String message;

  LifePlansError(this.message);
}

class LifePlansNotifier extends StateNotifier<LifePlansState> {
  LifePlansNotifier(this._api, this._auth) : super(LifePlansInitial());

  final LifeInsuranceApiService _api;
  final FirebaseAuthService _auth;

  /// Calls `recommendation` then `plans` with the same profile fields.
  Future<void> fetchTopPlans({
    required DateTime dateOfBirth,
    required int annualIncome,
    required int sumAssuredLakhs,
    required int coverTillAge,
    String gender = 'male',
    String occupation = 'salaried',
    String education = 'graduate',
    bool tobaccoConsumer = false,
    String sortBy = 'premium',
  }) async {
    state = LifePlansLoading();
    try {
      final token = await _auth.getIdToken(forceRefresh: false);

      final selectedRupees = sumAssuredLakhs * 100000;
      try {
        await _api.postRecommendation(
          lifeRecommendationBody(
            dateOfBirth: dateOfBirth,
            annualIncome: annualIncome,
            selectedSumAssuredRupees: selectedRupees,
            coverTillAge: coverTillAge,
          ),
          idToken: token,
        );
      } catch (e) {
        debugPrint('Life recommendation optional: $e');
      }

      final plansBody = lifePlansSearchBody(
        dateOfBirth: dateOfBirth,
        sumAssuredLakhs: sumAssuredLakhs,
        coverTillAge: coverTillAge,
        gender: gender,
        occupation: occupation,
        education: education,
        tobaccoConsumer: tobaccoConsumer,
        sortBy: sortBy,
      );

      final plans = await _api.postPlans(plansBody, idToken: token);
      if (plans.isEmpty) {
        state = LifePlansError('Not found');
        return;
      }
      state = LifePlansSuccess(plans);
    } catch (e) {
      state = LifePlansError(lifeInsuranceApiUserMessage(e));
    }
  }

  void reset() {
    state = LifePlansInitial();
  }
}

final lifePlansProvider =
    StateNotifierProvider<LifePlansNotifier, LifePlansState>((ref) {
  final api = ref.watch(lifeInsuranceApiServiceProvider);
  final auth = ref.watch(firebaseAuthServiceProvider);
  return LifePlansNotifier(api, auth);
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

/// `POST /plans` — defaults match common Swagger placeholders; override via UI later.
final lifeGenderProvider = StateProvider<String>((ref) => 'male');
final lifeOccupationProvider = StateProvider<String>((ref) => 'salaried');
final lifeEducationProvider = StateProvider<String>((ref) => 'graduate');
final lifeTobaccoConsumerProvider = StateProvider<bool>((ref) => false);
final lifePlansSortByProvider = StateProvider<String>((ref) => 'premium');

/// Available cover till age options.
const List<int> lifeCoverTillAgeOptions = [50, 55, 60, 65, 70];
