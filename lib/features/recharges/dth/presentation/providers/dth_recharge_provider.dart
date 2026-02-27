import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/dth_operator.dart';
import '../../data/models/dth_plan.dart';
import '../../data/repositories/dth_recharge_repository.dart';

final dthRechargeRepositoryProvider = Provider<DthRechargeRepository>((ref) => DthRechargeRepository());

final dthOperatorsProvider = FutureProvider<List<DthOperator>>((ref) {
  return ref.watch(dthRechargeRepositoryProvider).getOperators();
});

final dthPlansProvider = FutureProvider.family<List<DthPlan>, String>((ref, operatorId) {
  return ref.watch(dthRechargeRepositoryProvider).getPlans(operatorId);
});

final selectedDthOperatorProvider = StateProvider<DthOperator?>((ref) => null);
final dthSubscriberIdProvider = StateProvider<String>((ref) => '');
final selectedDthPlanProvider = StateProvider<DthPlan?>((ref) => null);
