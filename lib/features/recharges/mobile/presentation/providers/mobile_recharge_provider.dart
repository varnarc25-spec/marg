import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/mobile_operator.dart';
import '../../data/models/mobile_plan.dart';
import '../../data/models/mobile_recharge_history_item.dart';
import '../../data/repositories/mobile_recharge_repository.dart';

final mobileRechargeRepositoryProvider = Provider<MobileRechargeRepository>((
  ref,
) {
  return MobileRechargeRepository();
});

final mobileOperatorsProvider = FutureProvider<List<MobileOperator>>((ref) {
  final repo = ref.watch(mobileRechargeRepositoryProvider);
  return repo.getOperators();
});

final mobilePlansProvider =
    FutureProvider.family<List<MobilePlan>, MobilePlansParams>((ref, params) {
      final repo = ref.watch(mobileRechargeRepositoryProvider);
      return repo.getPlans(
        operatorId: params.operatorId,
        number: params.number,
        type: params.type,
      );
    });

class MobilePlansParams {
  final String operatorId;
  final String number;
  final String type;
  MobilePlansParams({
    required this.operatorId,
    required this.number,
    this.type = 'prepaid',
  });
}

final mobileHistoryProvider = FutureProvider<List<MobileRechargeHistoryItem>>((
  ref,
) {
  final repo = ref.watch(mobileRechargeRepositoryProvider);
  return repo.getRecentHistory();
});

/// Selected operator for current flow (scoped to flow; can use StateProvider).
final selectedMobileOperatorProvider = StateProvider<MobileOperator?>(
  (ref) => null,
);

/// Selected number for current flow.
final mobileRechargeNumberProvider = StateProvider<String>((ref) => '');

/// Selected plan for payment.
final selectedMobilePlanProvider = StateProvider<MobilePlan?>((ref) => null);

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

final mobileQuickTopUpProvider = FutureProvider<List<QuickTopUpEntry>>((
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
