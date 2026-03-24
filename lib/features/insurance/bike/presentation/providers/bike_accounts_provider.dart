import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/firebase_auth_service.dart';
import '../../data/models/bike_saved_account_model.dart';
import '../../data/services/bike_accounts_api_service.dart';
import '../../../../../shared/providers/app_providers.dart';

final bikeAccountsApiServiceProvider = Provider<BikeAccountsApiService>((ref) {
  return BikeAccountsApiService(baseUrl: null);
});

final bikeSavedAccountsProvider =
    FutureProvider<List<BikeSavedAccount>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  final api = ref.watch(bikeAccountsApiServiceProvider);
  final auth = ref.watch(firebaseAuthServiceProvider);
  if (!auth.isLoggedIn()) return const [];

  final idToken = await auth.getIdToken(forceRefresh: true);
  if (idToken == null || idToken.isEmpty) return const [];

  return api.fetchSavedAccounts(idToken: idToken);
});

/// Selected saved account id for the current purchase flow.
final selectedBikeSavedAccountIdProvider = StateProvider<String?>((ref) => null);

/// Mutations for saved accounts (create/update/delete).
/// UI should call these and then refresh `bikeSavedAccountsProvider`.
final bikeSavedAccountsMutationsProvider = Provider<BikeSavedAccountsMutations>((ref) {
  final api = ref.watch(bikeAccountsApiServiceProvider);
  final auth = ref.watch(firebaseAuthServiceProvider);
  return BikeSavedAccountsMutations(
    api: api,
    auth: auth,
    ref: ref,
  );
});

class BikeSavedAccountsMutations {
  BikeSavedAccountsMutations({
    required this.api,
    required this.auth,
    required this.ref,
  });

  final BikeAccountsApiService api;
  final FirebaseAuthService auth;
  final Ref ref;

  Future<String> _getIdTokenOrThrow() async {
    if (!auth.isLoggedIn()) {
      throw Exception('Please login again to continue');
    }
    final idToken = await auth.getIdToken();
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
        'subtitle': subtitle,
        'masked': masked,
        'isDefault': isDefault,
      }..removeWhere((k, v) => v == null),
    );
    ref.invalidate(bikeSavedAccountsProvider);
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
        'subtitle': subtitle,
        'masked': masked,
        'isDefault': isDefault,
      }..removeWhere((k, v) => v == null),
    );
    ref.invalidate(bikeSavedAccountsProvider);
  }

  Future<void> delete(String id) async {
    final idToken = await _getIdTokenOrThrow();
    await api.deleteSavedAccount(idToken: idToken, id: id);
    ref.invalidate(bikeSavedAccountsProvider);

    // Clear selected id if it was deleted.
    ref.read(selectedBikeSavedAccountIdProvider.notifier).state = null;
  }
}

