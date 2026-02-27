import '../models/data_card_operator.dart';
import '../models/data_card_plan.dart';

class DataCardRepository {
  Future<List<DataCardOperator>> getOperators() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const DataCardOperator(id: 'jio', name: 'Jio'),
      const DataCardOperator(id: 'airtel', name: 'Airtel'),
      const DataCardOperator(id: 'vi', name: 'Vi'),
    ];
  }

  Future<List<DataCardPlan>> getPlans(String operatorId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      const DataCardPlan(id: '1', name: '₹199', amount: 199, dataAllowance: '1.5 GB/day', validity: '28 days'),
      const DataCardPlan(id: '2', name: '₹299', amount: 299, dataAllowance: '2 GB/day', validity: '28 days'),
      const DataCardPlan(id: '3', name: '₹399', amount: 399, dataAllowance: '2.5 GB/day', validity: '28 days'),
    ];
  }

  Future<bool> recharge({required String operatorId, required String number, required double amount}) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
