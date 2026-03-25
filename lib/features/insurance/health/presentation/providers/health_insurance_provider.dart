import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/core/services/firebase_auth_service.dart';
import 'package:marg/shared/providers/app_providers.dart';
import '../../data/health_insurance_plan.dart';
import '../../data/models/health_price_promise_model.dart';
import '../../data/services/health_insurance_api_service.dart';

/// Selected family member keys. Default: ['Myself'].
const List<String> defaultHealthMembers = ['Myself'];

/// Default sum insured (₹) for `POST /api/insurance/health/plans` (₹1 Crore).
const int kDefaultHealthCoverAmount = 10000000;

/// Default policy term in years for plan search.
const int kDefaultHealthPolicyDuration = 1;

/// Maps UI chips (`Myself`, …) to API slugs (`myself`, …) as in selection response.
List<String> uiMembersToApiSlugs(List<String> uiMembers) {
  const map = {
    'Myself': 'myself',
    'Spouse': 'spouse',
    'Children': 'children',
    'Parents': 'parents',
  };
  return uiMembers
      .map((m) => map[m] ?? m.toLowerCase().replaceAll(' ', '_'))
      .toList();
}

/// Display label for summary card (e.g. "18-35 years" from resolved age).
String healthAgeRangeLabel(HealthDetailsFormState form, List<String> uiMembers) {
  final age = form.resolveAgeForApi(uiMembers);
  if (age <= 35) return '18-35 years';
  if (age <= 45) return '36-45 years';
  if (age <= 55) return '46-55 years';
  if (age <= 65) return '56-65 years';
  return '65+ years';
}

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
  HealthPlansNotifier(this._api, this._auth) : super(HealthPlansInitial());

  final HealthInsuranceApiService _api;
  final FirebaseAuthService _auth;

  /// Loads quoted plans (POST body) after pincode validation; falls back to partners.
  Future<void> fetchQuotedPlans({
    required List<String> memberTypes,
    required HealthDetailsFormState form,
    int? coverAmount,
  }) async {
    if (memberTypes.isEmpty) {
      state = HealthPlansError('Select at least one family member');
      return;
    }
    final pin = form.pincode.trim();
    if (pin.length != 6) {
      state = HealthPlansError('Enter a valid 6-digit pincode');
      return;
    }

    state = HealthPlansLoading();
    try {
      final token = await _auth.getIdToken(forceRefresh: false);

      // Pincode validation (soft-fail: if endpoint errors, continue to quote).
      try {
        final pinResult = await _api.validatePincode(pin, idToken: token);
        if (!pinResult.isValid) {
          state = HealthPlansError(
            pinResult.message ?? 'Invalid or unserviceable pincode',
          );
          return;
        }
      } catch (e) {
        debugPrint('Health pincode validation skipped: $e');
      }

      final selectionBody = form.toSelectionBody(memberTypes);
      final quoteBody = form.toPlansSearchBody(
        memberTypes,
        coverAmount: coverAmount ?? kDefaultHealthCoverAmount,
      );

      try {
        await _api.submitSelection(selectionBody, idToken: token);
      } catch (e) {
        debugPrint('Health selection optional: $e');
      }

      List<HealthInsurancePlan> plans;
      try {
        plans = await _api.getPlansWithBody(quoteBody, idToken: token);
      } catch (e) {
        debugPrint('Health POST /plans failed, fallback partners: $e');
        plans = await _api.getPartners(idToken: token);
      }

      if (plans.isEmpty) {
        plans = await _api.getPartners(idToken: token);
      }

      if (plans.isEmpty) {
        state = HealthPlansError(
          'No health insurance plans available right now. Please try again later.',
        );
        return;
      }
      state = HealthPlansSuccess(plans);
    } catch (e) {
      state = HealthPlansError(
        e is Exception
            ? e.toString().replaceFirst('Exception: ', '')
            : 'Unable to fetch plans',
      );
    }
  }

  /// Refetch plans when only `coverAmount` changes (keeps current list visible; no full-screen load).
  Future<void> refetchPlansForCoverAmount({
    required List<String> memberTypes,
    required HealthDetailsFormState form,
    required int coverAmount,
  }) async {
    if (memberTypes.isEmpty) {
      state = HealthPlansError('Select at least one family member');
      return;
    }
    final pin = form.pincode.trim();
    if (pin.length != 6) {
      state = HealthPlansError('Enter a valid 6-digit pincode');
      return;
    }

    final previous = state;
    try {
      final token = await _auth.getIdToken(forceRefresh: false);
      final quoteBody = form.toPlansSearchBody(
        memberTypes,
        coverAmount: coverAmount,
      );

      List<HealthInsurancePlan> plans;
      try {
        plans = await _api.getPlansWithBody(quoteBody, idToken: token);
      } catch (e) {
        debugPrint('Health POST /plans (cover) failed, fallback partners: $e');
        plans = await _api.getPartners(idToken: token);
      }

      if (plans.isEmpty) {
        plans = await _api.getPartners(idToken: token);
      }

      if (plans.isEmpty) {
        if (previous is HealthPlansSuccess) {
          state = previous;
        } else {
          state = HealthPlansError(
            'No health insurance plans available right now. Please try again later.',
          );
        }
        return;
      }
      state = HealthPlansSuccess(plans);
    } catch (e) {
      if (previous is HealthPlansSuccess) {
        state = previous;
      } else {
        state = HealthPlansError(
          e is Exception
              ? e.toString().replaceFirst('Exception: ', '')
              : 'Unable to fetch plans',
        );
      }
      rethrow;
    }
  }

  /// Legacy: partners-only list (e.g. quick preview).
  Future<void> fetchPartnerPlansOnly(List<String> memberTypes) async {
    if (memberTypes.isEmpty) {
      state = HealthPlansError('Select at least one family member');
      return;
    }
    state = HealthPlansLoading();
    try {
      final token = await _auth.getIdToken(forceRefresh: false);
      final plans = await _api.getPartners(idToken: token);
      if (plans.isEmpty) {
        state = HealthPlansError(
          'No health insurance partners available right now. Please try again later.',
        );
        return;
      }
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

final healthInsuranceApiServiceProvider =
    Provider<HealthInsuranceApiService>((ref) {
  return HealthInsuranceApiService();
});

final healthPlansProvider =
    StateNotifierProvider<HealthPlansNotifier, HealthPlansState>((ref) {
  final api = ref.watch(healthInsuranceApiServiceProvider);
  final auth = ref.watch(firebaseAuthServiceProvider);
  return HealthPlansNotifier(api, auth);
});

/// Home: price promise + partners for trusted grid (parallel load).
final healthHomeBootstrapProvider =
    FutureProvider<HealthHomeBootstrap>((ref) async {
  final api = ref.watch(healthInsuranceApiServiceProvider);
  final auth = ref.watch(firebaseAuthServiceProvider);
  final token = await auth.getIdToken();

  HealthPricePromise? price;
  try {
    price = await api.getPricePromise(idToken: token);
  } catch (_) {
    price = null;
  }

  final partners = await api.getPartners(idToken: token);
  return HealthHomeBootstrap(pricePromise: price, partners: partners);
});

class HealthHomeBootstrap {
  const HealthHomeBootstrap({
    required this.pricePromise,
    required this.partners,
  });

  final HealthPricePromise? pricePromise;
  final List<HealthInsurancePlan> partners;
}

/// Optional: config for future dropdowns.
final healthInsuranceConfigProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final api = ref.watch(healthInsuranceApiServiceProvider);
  final auth = ref.watch(firebaseAuthServiceProvider);
  final token = await auth.getIdToken();
  return api.getConfig(idToken: token);
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

  /// `POST /api/insurance/health/selection` — `{ "members": ["myself", ...] }`.
  Map<String, dynamic> toSelectionBody(List<String> uiMembers) {
    return {
      'members': uiMembersToApiSlugs(uiMembers),
    };
  }

  /// Single age for plan search (API expects one [age]).
  int resolveAgeForApi(List<String> uiMembers) {
    final hasSelfOrSpouse =
        uiMembers.contains('Myself') || uiMembers.contains('Spouse');
    if (hasSelfOrSpouse) {
      final parsed = int.tryParse((elderAge ?? '').trim());
      if (parsed != null && parsed > 0 && parsed < 120) return parsed;
      return 40;
    }
    if (uiMembers.contains('Parents') && parentAges.isNotEmpty) {
      final ages = parentAges
          .map((a) => int.tryParse((a ?? '').trim()) ?? 0)
          .where((n) => n > 0 && n < 120)
          .toList();
      if (ages.isNotEmpty) {
        return ages.reduce((a, b) => a > b ? a : b);
      }
      return 60;
    }
    return 35;
  }

  /// `POST /api/insurance/health/plans` — matches Swagger body.
  Map<String, dynamic> toPlansSearchBody(
    List<String> uiMembers, {
    int? coverAmount,
  }) {
    return {
      'age': resolveAgeForApi(uiMembers),
      'pincode': pincode.trim(),
      'hasPreExistingDisease': preExistingDisease ?? false,
      'members': uiMembersToApiSlugs(uiMembers),
      'coverAmount': coverAmount ?? kDefaultHealthCoverAmount,
      'policyDuration': kDefaultHealthPolicyDuration,
      'sortBy': 'premium',
      'benefits': <String>[],
    };
  }
}

final healthDetailsFormProvider =
    StateProvider<HealthDetailsFormState>((ref) => const HealthDetailsFormState());
