import '../models/dth_operator.dart';
import '../models/dth_plan.dart';

/// DTH recharge repository. TODO: BBPS/recharge API integration.
class DthRechargeRepository {
  Future<List<DthOperator>> getOperators() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const DthOperator(id: 'dish_tv', name: 'Dish TV'),
      const DthOperator(id: 'd2h', name: 'D2H'),
      const DthOperator(id: 'airtel_dth', name: 'Airtel DTH'),
      const DthOperator(id: 'sun_direct', name: 'Sun Direct'),
      const DthOperator(id: 'tatasky', name: 'Tata Sky'),
    ];
  }

  Future<List<DthPlan>> getPlans(String operatorId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      const DthPlan(id: '1', name: '₹299 Pack', amount: 299, validity: '1 month', isBestValue: true),
      const DthPlan(id: '2', name: '₹499 Pack', amount: 499, validity: '2 months'),
      const DthPlan(id: '3', name: '₹999 Pack', amount: 999, validity: '6 months'),
    ];
  }

  Future<bool> performRecharge({required String operatorId, required String subscriberId, required double amount}) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
