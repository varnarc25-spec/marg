import 'package:flutter/material.dart';
import '../pages/mobile_recharge_home_page.dart';
import '../pages/mobile_operator_selection_page.dart';
import '../pages/mobile_number_input_page.dart';
import '../pages/mobile_plan_list_page.dart';
import '../pages/mobile_payment_confirmation_page.dart';
import '../pages/mobile_success_page.dart';
import '../pages/mobile_recent_history_page.dart';
import '../pages/mobile_expiry_reminder_page.dart';

/// Feature-scoped routes for Mobile Recharge.
/// All navigation within this feature should use these routes.
class MobileRechargeRoutes {
  static const String operatorSelection = '/recharges/mobile/operator';
  static const String numberInput = '/recharges/mobile/number';
  static const String planList = '/recharges/mobile/plans';
  static const String paymentConfirmation = '/recharges/mobile/confirm';
  static const String success = '/recharges/mobile/success';
  static const String recentHistory = '/recharges/mobile/history';
  static const String expiryReminder = '/recharges/mobile/expiry';

  static Widget operatorSelectionPage() => const MobileOperatorSelectionPage();
  static Widget numberInputPage() => const MobileNumberInputPage();
  static Widget planListPage() => const MobilePlanListPage();
  static Widget paymentConfirmationPage() => const MobilePaymentConfirmationPage();
  static Widget successPage() => const MobileSuccessPage();
  static Widget recentHistoryPage() => const MobileRecentHistoryPage();
  static Widget expiryReminderPage({String menuItemSlug = 'mobile-recharge'}) =>
      MobileExpiryReminderPage(menuItemSlug: menuItemSlug);

  /// Entry: first screen when user opens Mobile Recharge from home.
  static Widget entryPage({String menuItemSlug = 'mobile-recharge'}) =>
      MobileRechargeHomePage(menuItemSlug: menuItemSlug);
}
