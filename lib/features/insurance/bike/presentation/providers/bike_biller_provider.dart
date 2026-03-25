import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/providers/app_providers.dart';
import '../../data/models/bike_payment_history_item.dart';
import '../../data/services/bike_insurance_api_service.dart';

/// Bike insurance REST routes are served from the Marg Cloud Run API host.
/// Always use that default so Find Plans / history work even when
/// [margApiServiceProvider] points at a different host (e.g. localhost:3000
/// for user registration only).
final bikeInsuranceApiServiceProvider = Provider<BikeInsuranceApiService>((ref) {
  return BikeInsuranceApiService(baseUrl: null);
});

/// Fetched list of bike insurance insurers (billers).
final bikeBillersProvider = FutureProvider((ref) async {
  final api = ref.watch(bikeInsuranceApiServiceProvider);
  return api.fetchBillers();
});

class BikePaymentHistoryQuery {
  const BikePaymentHistoryQuery({
    required this.limit,
    required this.offset,
  });

  final int limit;
  final int offset;
}

final bikePaymentHistoryProvider = FutureProvider.family<
    List<BikePaymentHistoryItem>, BikePaymentHistoryQuery>((ref, query) async {
  // Re-fetch when user signs in/out (service instance alone does not change).
  ref.watch(firebaseAuthUserProvider);
  final api = ref.watch(bikeInsuranceApiServiceProvider);
  final auth = ref.watch(firebaseAuthServiceProvider);
  if (!auth.isLoggedIn()) return const [];
  // Refresh token so backend auth does not fail silently after expiry.
  final idToken = await auth.getIdToken(forceRefresh: true);
  if (idToken == null || idToken.isEmpty) return const [];

  return api.fetchPaymentHistory(
    idToken: idToken,
    limit: query.limit,
    offset: query.offset,
  );
});
