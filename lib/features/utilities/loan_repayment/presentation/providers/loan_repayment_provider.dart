import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/shared/providers/app_providers.dart';

import '../../data/models/loan_repayment_bill.dart';
import '../../data/models/loan_repayment_biller.dart';
import '../../data/models/loan_repayment_history_item.dart';
import '../../data/models/loan_repayment_saved_account.dart';
import '../../data/repositories/loan_repayment_repository.dart';
import '../../data/services/loan_repayment_api_service.dart';

final loanRepaymentApiServiceProvider = Provider<LoanRepaymentApiService>((ref) {
  return LoanRepaymentApiService();
});

final loanRepaymentRepositoryProvider = Provider<LoanRepaymentRepository>((ref) {
  return LoanRepaymentRepository(
    ref.watch(loanRepaymentApiServiceProvider),
    ref.watch(firebaseAuthServiceProvider),
  );
});

final loanRepaymentBillersProvider = FutureProvider<List<LoanRepaymentBiller>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(loanRepaymentRepositoryProvider).getBillers();
});

final loanRepaymentHistoryProvider = FutureProvider<List<LoanRepaymentHistoryItem>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(loanRepaymentRepositoryProvider).getHistory();
});

final loanRepaymentSavedAccountsProvider =
    FutureProvider<List<LoanRepaymentSavedAccount>>((ref) async {
  ref.watch(firebaseAuthUserProvider);
  return ref.read(loanRepaymentRepositoryProvider).getSavedAccounts();
});

final selectedLoanRepaymentBillerProvider = StateProvider<LoanRepaymentBiller?>((ref) => null);
final loanRepaymentConsumerNumberProvider = StateProvider<String>((ref) => '');
final fetchedLoanRepaymentBillProvider = StateProvider<LoanRepaymentBill?>((ref) => null);
final selectedLoanRepaymentSavedAccountIdProvider = StateProvider<String?>((ref) => null);
final lastLoanRepaymentTransactionIdProvider = StateProvider<String?>((ref) => null);
