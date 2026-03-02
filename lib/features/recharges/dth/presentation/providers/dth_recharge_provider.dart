import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/dth_operator.dart';
import '../../data/models/dth_plan.dart';
import '../../data/models/dth_recharge_history_item.dart';
import '../../data/repositories/dth_recharge_repository.dart';

final selectedDthOperatorProvider = StateProvider<DthOperator?>((ref) => null);
final dthSubscriberIdProvider = StateProvider<String>((ref) => '');
final selectedDthPlanProvider = StateProvider<DthPlan?>((ref) => null);

final dthRechargeRepositoryProvider = Provider<DthRechargeRepository>((ref) {
  return DthRechargeRepository();
});

final dthOperatorsProvider = FutureProvider<List<DthOperator>>((ref) {
  final repo = ref.watch(dthRechargeRepositoryProvider);
  return repo.getOperators();
});

final dthPlansProvider = FutureProvider.family<List<DthPlan>, String>((
  ref,
  operatorId,
) {
  final repo = ref.watch(dthRechargeRepositoryProvider);
  return repo.getPlans(operatorId);
});

final mobileHistoryProvider = FutureProvider<List<DthRechargeHistoryItem>>((
  ref,
) {
  final repo = ref.watch(dthRechargeRepositoryProvider);
  return repo.getRecentHistory();
});

/// Alias for use in DTH recent history / home.
final dthHistoryProvider = mobileHistoryProvider;

/// Alias for subscriber ID state (number) in DTH flow.
final dthRechargeNumberProvider = dthSubscriberIdProvider;

/// Selected operator for current flow (scoped to flow; can use StateProvider).
final selectedMobileOperatorProvider = StateProvider<DthOperator?>(
  (ref) => null,
);

/// Selected number for current flow.
final mobileRechargeNumberProvider = StateProvider<String>((ref) => '');

/// Selected plan for payment.
final selectedMobilePlanProvider = StateProvider<DthPlan?>((ref) => null);

/// Family numbers saved for quick recharge.
final mobileFamilyNumbersProvider = StateProvider<List<FamilyNumberEntry>>(
  (ref) => [
    const FamilyNumberEntry(
      label: 'My number',
      number: '9876543210',
      operatorId: 'jio',
    ),
    const FamilyNumberEntry(
      label: 'Home',
      number: '9876543211',
      operatorId: 'airtel',
    ),
  ],
);

class FamilyNumberEntry {
  final String label;
  final String number;
  final String operatorId;
  const FamilyNumberEntry({
    required this.label,
    required this.number,
    required this.operatorId,
  });
}

/// Quick Data Top-up card: operator, alias, data + price for horizontal list.
class QuickTopUpEntry {
  final String operatorId;
  final String operatorName;
  final String alias;
  final String number;
  final String dataPlanLabel; // e.g. "1.5 GB for ₹26"
  const QuickTopUpEntry({
    required this.operatorId,
    required this.operatorName,
    required this.alias,
    required this.number,
    required this.dataPlanLabel,
  });
}

final dthQuickTopUpProvider = FutureProvider<List<QuickTopUpEntry>>((
  ref,
) async {
  await Future.delayed(const Duration(milliseconds: 150));
  return [
    const QuickTopUpEntry(
      operatorId: 'vi',
      operatorName: 'VI',
      alias: 'Krishna',
      number: '9739722974',
      dataPlanLabel: '1.5 GB for ₹26',
    ),
    const QuickTopUpEntry(
      operatorId: 'jio',
      operatorName: 'Jio',
      alias: 'hema mam',
      number: '8121793743',
      dataPlanLabel: '6 GB for ₹69',
    ),
    const QuickTopUpEntry(
      operatorId: 'airtel',
      operatorName: 'Airtel',
      alias: 'Home',
      number: '8050638973',
      dataPlanLabel: '2 GB for ₹49',
    ),
  ];
});
