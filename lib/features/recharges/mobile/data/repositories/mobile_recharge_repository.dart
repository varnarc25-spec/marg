import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/mobile_operator.dart';
import '../models/mobile_plan.dart';
import '../models/mobile_recharge_history_item.dart';

/// Repository for mobile recharge: operators, plans, history.
/// TODO: Replace mock implementation with BBPS/recharge API integration.
class MobileRechargeRepository {
  Future<List<MobileOperator>> getOperators() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const MobileOperator(id: 'airtel', name: 'Airtel', circle: 'All India'),
      const MobileOperator(id: 'jio', name: 'Jio', circle: 'All India'),
      const MobileOperator(id: 'vi', name: 'Vi', circle: 'All India'),
      const MobileOperator(id: 'bsnl', name: 'BSNL', circle: 'All India'),
    ];
  }

  Future<List<MobilePlan>> getPlans({
    required String operatorId,
    required String number,
    String type = 'prepaid',
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (type == 'topup') {
      return [
        const MobilePlan(
            id: 't1', name: '₹10', amount: 10, planType: 'topup', talktime: '₹10'),
        const MobilePlan(
            id: 't2', name: '₹20', amount: 20, planType: 'topup', talktime: '₹20'),
        const MobilePlan(
            id: 't3', name: '₹50', amount: 50, planType: 'topup', talktime: '₹50'),
        const MobilePlan(
            id: 't4', name: '₹100', amount: 100, planType: 'topup', talktime: '₹100'),
      ];
    }
    return [
      const MobilePlan(
        id: 'p1',
        name: '₹299',
        amount: 299,
        validity: '28 days',
        dataAllowance: '2 GB/day',
        talktime: 'Unlimited',
        planType: 'prepaid',
        isBestValue: true,
      ),
      const MobilePlan(
        id: 'p2',
        name: '₹399',
        amount: 399,
        validity: '28 days',
        dataAllowance: '2.5 GB/day',
        talktime: 'Unlimited',
        planType: 'prepaid',
      ),
      const MobilePlan(
        id: 'p3',
        name: '₹499',
        amount: 499,
        validity: '56 days',
        dataAllowance: '1.5 GB/day',
        talktime: 'Unlimited',
        planType: 'prepaid',
      ),
      const MobilePlan(
        id: 'p4',
        name: '₹666',
        amount: 666,
        validity: '84 days',
        dataAllowance: '1.5 GB/day',
        talktime: 'Unlimited',
        planType: 'prepaid',
      ),
    ];
  }

  static const String _sampleTransactionsAsset =
      'assets/data/mobile_recharge_transactions.json';

  /// Loads recent recharge history from global sample data JSON.
  Future<List<MobileRechargeHistoryItem>> getRecentHistory() async {
    try {
      final str = await rootBundle.loadString(_sampleTransactionsAsset);
      final map = jsonDecode(str) as Map<String, dynamic>;
      final list = map['transactions'] as List<dynamic>? ?? [];
      return list
          .map((e) => MobileRechargeHistoryItem.fromTransactionJson(
              e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// TODO: Call payment gateway and BBPS API for actual recharge.
  Future<bool> performRecharge({
    required String operatorId,
    required String number,
    required double amount,
    required String planId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
