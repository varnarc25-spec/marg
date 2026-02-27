import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/data_card_operator.dart';
import '../../data/models/data_card_plan.dart';
import '../../data/repositories/data_card_repository.dart';

final dataCardRepositoryProvider = Provider<DataCardRepository>((ref) => DataCardRepository());
final dataCardOperatorsProvider = FutureProvider<List<DataCardOperator>>((ref) => ref.read(dataCardRepositoryProvider).getOperators());
final dataCardPlansProvider = FutureProvider.family<List<DataCardPlan>, String>((ref, id) => ref.read(dataCardRepositoryProvider).getPlans(id));
final selectedDataCardOperatorProvider = StateProvider<DataCardOperator?>((ref) => null);
final dataCardNumberProvider = StateProvider<String>((ref) => '');
final selectedDataCardPlanProvider = StateProvider<DataCardPlan?>((ref) => null);
