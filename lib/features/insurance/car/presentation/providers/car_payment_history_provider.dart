import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/car_payment_history_item.dart';
import '../../data/services/car_insurance_history_api_service.dart';
import '../../../../../shared/providers/app_providers.dart';

final carInsuranceHistoryApiServiceProvider =
    Provider<CarInsuranceHistoryApiService>((ref) {
  return CarInsuranceHistoryApiService();
});

class CarPaymentHistoryQuery {
  const CarPaymentHistoryQuery({
    required this.limit,
    required this.offset,
  });

  final int limit;
  final int offset;
}

final carPaymentHistoryProvider = FutureProvider.family<
    List<CarPaymentHistoryItem>, CarPaymentHistoryQuery>((ref, query) async {
  // Watch auth state so we re-fetch after login/logout.
  ref.watch(firebaseAuthUserProvider);

  final api = ref.watch(carInsuranceHistoryApiServiceProvider);
  final auth = ref.watch(firebaseAuthServiceProvider);
  if (!auth.isLoggedIn()) return const [];

  final idToken = await auth.getIdToken(forceRefresh: true);
  if (idToken == null || idToken.isEmpty) return const [];

  return api.fetchPaymentHistory(
    idToken: idToken,
    limit: query.limit,
    offset: query.offset,
  );
});

