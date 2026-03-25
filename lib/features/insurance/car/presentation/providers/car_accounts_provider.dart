import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/firebase_auth_service.dart';
import '../../data/models/car_saved_account_model.dart';
import '../../data/services/car_accounts_api_service.dart';
import '../../../../../shared/providers/app_providers.dart';

final carAccountsApiServiceProvider = Provider<CarAccountsApiService>((ref) {
  // Bike insurance uses a dedicated Cloud Run host; for consistency,
  // we default the service to that same host.
  return CarAccountsApiService(baseUrl: null);
});

final carSavedAccountsProvider =
    FutureProvider<List<CarSavedAccount>>((ref) async {
  // Watch auth state so provider re-fetches after login.
  ref.watch(firebaseAuthUserProvider);

  final api = ref.watch(carAccountsApiServiceProvider);
  final auth = ref.watch(firebaseAuthServiceProvider);
  if (!auth.isLoggedIn()) return const [];

  final idToken = await auth.getIdToken(forceRefresh: true);
  if (idToken == null || idToken.isEmpty) return const [];

  return api.fetchSavedAccounts(idToken: idToken);
});

/// Selected saved account id for the current purchase flow (future use).
final selectedCarSavedAccountIdProvider =
    StateProvider<String?>((ref) => null);

/// Mutations for saved accounts (create/update/delete).
/// UI should call these and then refresh `carSavedAccountsProvider`.
final carSavedAccountsMutationsProvider =
    Provider<CarSavedAccountsMutations>((ref) {
  final api = ref.watch(carAccountsApiServiceProvider);
  final auth = ref.watch(firebaseAuthServiceProvider);
  return CarSavedAccountsMutations(
    api: api,
    auth: auth,
    ref: ref,
  );
});

class CarSavedAccountsMutations {
  CarSavedAccountsMutations({
    required this.api,
    required this.auth,
    required this.ref,
  });

  final CarAccountsApiService api;
  final FirebaseAuthService auth;
  final Ref ref;

  Future<String> _getIdTokenOrThrow() async {
    if (!auth.isLoggedIn()) {
      throw Exception('Please login again to continue');
    }
    final idToken = await auth.getIdToken(forceRefresh: true);
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Session expired. Please login again');
    }
    return idToken;
  }

  Future<void> create({
    required String accountType,
    required String title,
    String? subtitle,
    String? masked,
    bool isDefault = false,
  }) async {
    final idToken = await _getIdTokenOrThrow();
    await api.createSavedAccount(
      idToken: idToken,
      payload: {
        'accountType': accountType,
        'title': title,
        'label': title,
        'name': title,
        'subtitle': subtitle,
        'consumerName': subtitle,
        'masked': masked,
        'accountNumber': masked,
        'isDefault': isDefault,
      }..removeWhere((k, v) => v == null),
    );
    ref.invalidate(carSavedAccountsProvider);
  }

  Future<void> update({
    required String id,
    required String accountType,
    required String title,
    String? subtitle,
    String? masked,
    bool isDefault = false,
  }) async {
    final idToken = await _getIdTokenOrThrow();
    await api.updateSavedAccount(
      idToken: idToken,
      id: id,
      payload: {
        'accountType': accountType,
        'title': title,
        'label': title,
        'name': title,
        'subtitle': subtitle,
        'consumerName': subtitle,
        'masked': masked,
        'accountNumber': masked,
        'isDefault': isDefault,
      }..removeWhere((k, v) => v == null),
    );
    ref.invalidate(carSavedAccountsProvider);
  }

  Future<void> delete(String id) async {
    final idToken = await _getIdTokenOrThrow();
    await api.deleteSavedAccount(idToken: idToken, id: id);
    ref.invalidate(carSavedAccountsProvider);

    // Clear selected id if it was deleted.
    ref.read(selectedCarSavedAccountIdProvider.notifier).state = null;
  }
}

