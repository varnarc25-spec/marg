import 'package:flutter/material.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/screens/otp_verification_screen.dart' show OtpVerificationScreen, AuthMethod;
import '../../../home/presentation/screens/home_screen.dart';
import '../../../home/presentation/screens/wealth_home_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../settings/presentation/screens/link_account_screen.dart';
import '../../../settings/presentation/screens/payment_method_screen.dart';
import '../../../settings/presentation/screens/push_notifications_screen.dart';
import '../../../settings/presentation/screens/referral_program_screen.dart';
import '../../../settings/presentation/screens/select_language_screen.dart';
import '../../../support/presentation/screens/about_app_screen.dart';
import '../../../support/presentation/screens/help_center_screen.dart';
import '../../../support/presentation/screens/faq_screen.dart';
import '../../../about/presentation/screens/privacy_policy_screen.dart';
import '../../../about/presentation/screens/terms_conditions_screen.dart';
import '../../../trade/presentation/screens/trade_guidance_screen.dart';
import '../../../trade/presentation/screens/options_strategy_builder_screen.dart';
import '../../../journal/presentation/screens/trade_journal_screen.dart';
import '../../../learning/presentation/screens/learning_hub_screen.dart';
import '../../../kyc/presentation/screens/pan_verification_screen.dart';
import '../../../kyc/presentation/screens/aadhaar_verification_screen.dart';
import '../../../kyc/presentation/screens/bank_verification_screen.dart';
import '../../../kyc/presentation/screens/kyc_completion_screen.dart';
import '../../../mpin/presentation/screens/mpin_setup_screen.dart';
import '../../../stocks/presentation/screens/stocks_home_page.dart';
import '../../../stocks/presentation/screens/market_sectors_screen.dart';
import '../../../stocks/presentation/screens/search_stock_screen.dart';
import '../../../stocks/presentation/screens/stock_details_screen.dart';
import '../../../stocks/presentation/screens/stock_portfolio_screen.dart';
import '../../../stocks/presentation/screens/buy_stock_screen.dart';
import '../../../stocks/presentation/screens/exchange_stock_screen.dart';
import '../../../stocks/presentation/screens/sell_stock_screen.dart';
import '../../../stocks/presentation/screens/stock_transactions_history.dart';
import '../../../commodities/presentation/screens/commodities_home_page.dart';
import '../../../commodities/presentation/screens/gold_details_screen.dart';
import '../../../commodities/presentation/screens/gold_loan_screen.dart';
import '../../../commodities/presentation/screens/gold_redeem_screen.dart';
import '../../../commodities/presentation/screens/gold_transactions_screen.dart';
import '../../../commodities/presentation/screens/gold_auto_invest_screen.dart';
import '../../../commodities/presentation/screens/silver_details_screen.dart';
import '../../../commodities/presentation/screens/silver_auto_invest_screen.dart';
import '../../../commodities/presentation/screens/silver_loan_screen.dart';
import '../../../commodities/presentation/screens/silver_redeem_screen.dart';
import '../../../commodities/presentation/screens/silver_transactions_screen.dart';
import '../../../onboarding/presentation/screens/app_splash_screen.dart';
import '../../../onboarding/presentation/screens/language_selection_screen.dart';
import '../../../onboarding/presentation/screens/account_mode_screen.dart';
import '../../../onboarding/presentation/screens/experience_level_screen.dart';
import '../../../onboarding/presentation/screens/user_goal_selection_screen.dart';
import '../../../onboarding/presentation/screens/risk_quiz_screen.dart';
import '../../../onboarding/presentation/screens/onboarding_success_screen.dart';
import '../../../mywallet/presentation/screens/my_wallet_screen.dart';
import '../../../mywallet/presentation/screens/topup_balance_screen.dart';
import '../../../mywallet/presentation/screens/topup_confirmation_screen.dart';
import '../../../mywallet/presentation/screens/topup_select_deposit_method_screen.dart';
import '../../../mywallet/presentation/screens/topup_success_screen.dart';
import '../../../mywallet/presentation/screens/withdraw_balance_screen.dart';
import '../../../mywallet/presentation/screens/withdraw_select_destination_screen.dart';
import '../../../mywallet/presentation/screens/transfer_balance_screen.dart';
import '../../../mywallet/presentation/screens/transfer_balance_list_contact_screen.dart';
import '../../../mywallet/presentation/screens/transfer_balance_confirmation_screen.dart';
import '../../../accounts/presentation/screens/my_account_screen.dart';
import '../../../accounts/presentation/screens/personal_data_screen.dart';
import '../../../accounts/presentation/screens/personal_data_edit_screen.dart';
import '../../../accounts/bank/presentation/screens/bank_account_screen.dart';
import '../../../accounts/bank/presentation/screens/bank_account_detail_screen.dart';
import '../../../accounts/bank/presentation/screens/bank_account_add_screen.dart';
import '../../../accounts/bank/presentation/screens/bank_account_list_screen.dart';
import '../../../messages_notifications/presentation/screens/message_list_screen.dart';
import '../../../messages_notifications/presentation/screens/message_search_screen.dart';
import '../../../messages_notifications/presentation/screens/message_chat_screen.dart';
import '../../../messages_notifications/presentation/screens/message_chat_media_screen.dart';
import '../../../messages_notifications/presentation/screens/notification_list_screen.dart';
import '../../../messages_notifications/presentation/screens/notification_verify_email_screen.dart';
import '../../../payments/presentation/screens/add_promo_screen.dart';
import '../../../payments/presentation/screens/confirm_order_screen.dart';
import '../../../payments/presentation/screens/create_order_screen.dart';
import '../../../payments/presentation/screens/order_success_screen.dart';
import '../../../payments/presentation/screens/select_payment_method_screen.dart';
import '../../../history/presentation/screens/transaction_history_screen.dart';
import '../../../history/presentation/screens/history_report_v1_screen.dart';
import '../../../history/presentation/screens/history_report_v2_screen.dart';
import '../../../history/presentation/screens/history_details_bar_screen.dart';
import '../../../history/presentation/screens/history_details_pie_screen.dart';
import '../../../history/presentation/screens/history_download_popup_screen.dart';
import '../../../myportfolio/presentation/screens/my_portfolio_screen.dart';

/// Central list of (menu category, label, screen builder) for splash screen dropdowns.
List<SplashScreenLink> get splashScreenLinks => [
  SplashScreenLink('Auth', 'Login', () => const LoginScreen()),
  SplashScreenLink('Auth', 'OTP Verification', () => OtpVerificationScreen(verificationId: 'dev', authMethod: AuthMethod.phone)),
  SplashScreenLink('Home', 'Home', () => const HomeScreen()),
  SplashScreenLink('Home', 'Wealth Home', () => const WealthHomeScreen()),
  SplashScreenLink('Onboarding', 'App Splash', () => const AppSplashScreen()),
  SplashScreenLink('Onboarding', 'Language Selection', () => const LanguageSelectionScreen()),
  SplashScreenLink('Onboarding', 'Account Mode', () => const AccountModeScreen()),
  SplashScreenLink('Onboarding', 'Experience Level', () => const ExperienceLevelScreen()),
  SplashScreenLink('Onboarding', 'User Goal Selection', () => const UserGoalSelectionScreen()),
  SplashScreenLink('Onboarding', 'Risk Quiz', () => const RiskQuizScreen()),
  SplashScreenLink('Onboarding', 'Onboarding Success', () => const OnboardingSuccessScreen()),
  SplashScreenLink('Settings', 'Settings', () => const SettingsScreen()),
  SplashScreenLink('Settings', 'Link Account', () => const LinkAccountScreen()),
  SplashScreenLink('Settings', 'Payment Method', () => const PaymentMethodScreen()),
  SplashScreenLink('Settings', 'Push Notifications', () => const PushNotificationsScreen()),
  SplashScreenLink('Settings', 'Referral Program', () => const ReferralProgramScreen()),
  SplashScreenLink('Settings', 'Select Language', () => const SelectLanguageScreen()),
  SplashScreenLink('Support', 'About App', () => const AboutAppScreen()),
  SplashScreenLink('Support', 'Help Center', () => const HelpCenterScreen()),
  SplashScreenLink('Support', 'FAQ', () => const FaqScreen()),
  SplashScreenLink('About', 'Privacy Policy', () => const PrivacyPolicyScreen()),
  SplashScreenLink('About', 'Terms & Conditions', () => const TermsConditionsScreen()),
  SplashScreenLink('Trade', 'Trade Guidance', () => const TradeGuidanceScreen()),
  SplashScreenLink('Trade', 'Options Strategy Builder', () => const OptionsStrategyBuilderScreen()),
  SplashScreenLink('Journal', 'Trade Journal', () => const TradeJournalScreen()),
  SplashScreenLink('Learning', 'Learning Hub', () => const LearningHubScreen()),
  SplashScreenLink('KYC', 'PAN Verification', () => const PanVerificationScreen()),
  SplashScreenLink('KYC', 'Aadhaar Verification', () => const AadhaarVerificationScreen()),
  SplashScreenLink('KYC', 'Bank Verification', () => const BankVerificationScreen()),
  SplashScreenLink('KYC', 'KYC Completion', () => const KycCompletionScreen()),
  SplashScreenLink('MPIN', 'MPIN Setup', () => const MpinSetupScreen()),
  SplashScreenLink('Stocks', 'Stocks Home', () => const StocksHomePage()),
  SplashScreenLink('Stocks', 'Market Sectors', () => const MarketSectorsScreen()),
  SplashScreenLink('Stocks', 'Search Stock', () => const SearchStockScreen()),
  SplashScreenLink('Stocks', 'Stock Details', () => const StockDetailsScreen()),
  SplashScreenLink('Stocks', 'Stock Portfolio', () => const StockPortfolioScreen()),
  SplashScreenLink('Stocks', 'Buy Stock', () => const BuyStockScreen()),
  SplashScreenLink('Stocks', 'Sell Stock', () => const SellStockScreen()),
  SplashScreenLink('Stocks', 'Exchange Stock', () => const ExchangeStockScreen()),
  SplashScreenLink('Stocks', 'Stock Transactions History', () => const StockTransactionsHistory()),
  SplashScreenLink('Commodities', 'Commodities Home', () => const CommoditiesHomePage()),
  SplashScreenLink('Commodities', 'Gold Details', () => const GoldDetailsScreen()),
  SplashScreenLink('Commodities', 'Gold Loan', () => const GoldLoanScreen()),
  SplashScreenLink('Commodities', 'Gold Redeem', () => const GoldRedeemScreen()),
  SplashScreenLink('Commodities', 'Gold Transactions', () => const GoldTransactionsScreen()),
  SplashScreenLink('Commodities', 'Gold Auto Invest', () => const GoldAutoInvestScreen()),
  SplashScreenLink('Commodities', 'Silver Details', () => const SilverDetailsScreen()),
  SplashScreenLink('Commodities', 'Silver Auto Invest', () => const SilverAutoInvestScreen()),
  SplashScreenLink('Commodities', 'Silver Loan', () => const SilverLoanScreen()),
  SplashScreenLink('Commodities', 'Silver Redeem', () => const SilverRedeemScreen()),
  SplashScreenLink('Commodities', 'Silver Transactions', () => const SilverTransactionsScreen()),
  SplashScreenLink('Wallet', 'My Wallet', () => const MyWalletScreen()),
  SplashScreenLink('Wallet', 'Topup Balance', () => const TopupBalanceScreen()),
  SplashScreenLink('Wallet', 'Topup Confirmation', () => const TopupConfirmationScreen(amount: 100, fee: 2)),
  SplashScreenLink('Wallet', 'Topup Select Method', () => const TopupSelectDepositMethodScreen()),
  SplashScreenLink('Wallet', 'Topup Success', () => const TopupSuccessScreen()),
  SplashScreenLink('Wallet', 'Withdraw Balance', () => const WithdrawBalanceScreen()),
  SplashScreenLink('Wallet', 'Withdraw Select Destination', () => const WithdrawSelectDestinationScreen()),
  SplashScreenLink('Wallet', 'Transfer Balance', () => const TransferBalanceScreen()),
  SplashScreenLink('Wallet', 'Transfer List Contact', () => const TransferBalanceListContactScreen()),
  SplashScreenLink('Wallet', 'Transfer Confirmation', () => TransferBalanceConfirmationScreen(
        amount: 567,
        contact: TransferContact(name: 'Aileen Fullbright', phone: '+17896 8797 908', initial: 'A'),
      )),
  SplashScreenLink('Accounts', 'My Account', () => const MyAccountScreen()),
  SplashScreenLink('Accounts', 'Personal Data', () => const PersonalDataScreen()),
  SplashScreenLink('Accounts', 'Personal Data Edit', () => const PersonalDataEditScreen()),
  SplashScreenLink('Bank', 'Bank Account', () => const BankAccountScreen()),
  SplashScreenLink('Bank', 'Bank Account Detail', () => const BankAccountDetailScreen(bankName: 'Bank of America', lastFour: '7777')),
  SplashScreenLink('Bank', 'Bank Account Add', () => const BankAccountAddScreen()),
  SplashScreenLink('Bank', 'Bank Account List', () => const BankAccountListScreen()),
  SplashScreenLink('Messages', 'Message List', () => const MessageListScreen()),
  SplashScreenLink('Messages', 'Message Search', () => const MessageSearchScreen()),
  SplashScreenLink('Messages', 'Message Chat', () => const MessageChatScreen(name: 'Marielle Wigington', initial: 'M', isOnline: true)),
  SplashScreenLink('Messages', 'Message Chat Media', () => const MessageChatMediaScreen()),
  SplashScreenLink('Messages', 'Notification List', () => const NotificationListScreen()),
  SplashScreenLink('Messages', 'Notification Verify Email', () => const NotificationVerifyEmailScreen()),
  SplashScreenLink('Payments', 'Add Promo', () => const AddPromoScreen()),
  SplashScreenLink('Payments', 'Confirm Order', () => const ConfirmOrderScreen()),
  SplashScreenLink('Payments', 'Create Order', () => const CreateOrderScreen()),
  SplashScreenLink('Payments', 'Order Success', () => const OrderSuccessScreen()),
  SplashScreenLink('Payments', 'Select Payment Method', () => const SelectPaymentMethodScreen()),
  SplashScreenLink('History', 'Transaction History', () => const TransactionHistoryScreen()),
  SplashScreenLink('History', 'History Report V1', () => const HistoryReportV1Screen()),
  SplashScreenLink('History', 'History Report V2', () => const HistoryReportV2Screen()),
  SplashScreenLink('History', 'History Details Bar', () => const HistoryDetailsBarScreen()),
  SplashScreenLink('History', 'History Details Pie', () => const HistoryDetailsPieScreen()),
  SplashScreenLink('History', 'History Download Popup', () => const HistoryDownloadPopupScreen()),
  SplashScreenLink('Portfolio', 'My Portfolio', () => const MyPortfolioScreen()),
];

class SplashScreenLink {
  final String category;
  final String label;
  final Widget Function() createScreen;

  const SplashScreenLink(this.category, this.label, this.createScreen);
}
