import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/education_institution.dart';
import '../../data/models/education_bill.dart';
import '../../data/models/education_biller.dart';
import '../../data/models/education_history_item.dart';
import '../../data/models/education_saved_account.dart';
import '../../data/models/education_state.dart';
import '../../data/repositories/education_repository.dart';
import '../../../../shared/providers/app_providers.dart';

final educationRepositoryProvider = Provider<EducationRepository>((ref) => EducationRepository());
final selectedEducationInstitutionProvider = StateProvider<EducationInstitution?>((ref) => null);

final educationStatesProvider = FutureProvider<List<EducationState>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(educationRepositoryProvider).getStates();
});

final educationBillersProvider =
    FutureProvider.family<List<EducationBiller>, String>((ref, stateId) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(educationRepositoryProvider).getBillers(stateId);
});

final educationAllBillersProvider = FutureProvider<List<EducationBiller>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(educationRepositoryProvider).getBillers('');
});

final educationHistoryProvider = FutureProvider<List<EducationHistoryItem>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(educationRepositoryProvider).getHistory();
});

final educationSavedAccountsProvider =
    FutureProvider<List<EducationSavedAccount>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(educationRepositoryProvider).getSavedAccounts();
});

final selectedEducationStateProvider = StateProvider<EducationState?>((ref) => null);
final selectedEducationBillerProvider = StateProvider<EducationBiller?>((ref) => null);
final educationConsumerNumberProvider = StateProvider<String>((ref) => '');
final fetchedEducationBillProvider = StateProvider<EducationBill?>((ref) => null);
