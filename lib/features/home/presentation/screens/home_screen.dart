import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../shared/providers/app_providers.dart';
import '../widgets/home_widgets.dart';
import 'hub_detail_screen.dart';
import 'gold_silver_all_services_screen.dart';
import 'wealth_home_screen.dart';
import '../../../accounts/presentation/screens/my_account_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../learning/presentation/screens/learning_hub_screen.dart';
import '../../../messages_notifications/presentation/screens/notification_list_screen.dart';
import '../../../payments/presentation/screens/add_promo_screen.dart';
import '../../../scan/presentation/screens/scan_qr_screen.dart';
// Recharges & Bills feature entries (feature-scoped navigation)
import '../../../recharges/mobile/presentation/routes/mobile_recharge_routes.dart';
import '../../../recharges/dth/presentation/routes/dth_recharge_routes.dart';
import '../../../utilities/electricity/presentation/routes/electricity_routes.dart';
import '../../../utilities/broadband/presentation/routes/broadband_routes.dart';
import '../../../credit_card/presentation/routes/credit_card_routes.dart';
import '../../../fastag/presentation/routes/fastag_routes.dart';
import '../../../education/presentation/routes/education_routes.dart';
import '../../../government_bills/presentation/routes/government_bills_routes.dart';

/// Home Dashboard Screen
/// Search, quick actions, Financial Hub, Convenient Hub, Service Hub, Rewards Hub, bottom nav
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// Recharges & Bills hub items with navigation to each feature. Used for grid and View All.
  static List<HomeIconGridItem> _rechargesBillsItems(BuildContext context, AppLocalizations l10n) {
    return [
      HomeIconGridItem(Icons.phone_android_rounded, l10n.homeRechargeMobile, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MobileRechargeRoutes.entryPage()))),
      HomeIconGridItem(Icons.tv_rounded, l10n.homeRechargeDth, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DthRechargeRoutes.entryPage()))),
      HomeIconGridItem(Icons.directions_car_rounded, l10n.homeRechargeFastag, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FastagRoutes.entryPage()))),
      HomeIconGridItem(Icons.bolt_rounded, l10n.homeRechargeElectricity, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ElectricityRoutes.entryPage()))),
      HomeIconGridItem(Icons.wifi_rounded, l10n.homeRechargeBroadband, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BroadbandRoutes.entryPage()))),
      HomeIconGridItem(Icons.credit_card_rounded, l10n.homeRechargeCreditCard, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreditCardRoutes.entryPage()))),
      HomeIconGridItem(Icons.school_rounded, l10n.homeRechargeSchoolFees, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EducationRoutes.entryPage()))),
      HomeIconGridItem(Icons.water_drop_rounded, l10n.homeRechargeMunicipal, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => GovernmentBillsRoutes.entryPage()))),
      HomeIconGridItem(Icons.account_balance_rounded, l10n.homeRechargeLoanEmi, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreditCardRoutes.entryPage()))),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  const HomePromoBanner(),
                  HomeSectionTitle(
                    title: l10n.homeHubRechargesBills,
                    showViewAll: true,
                    onViewAllTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HubDetailScreen(
                            title: l10n.homeHubRechargesBills,
                            items: _rechargesBillsItems(context, l10n),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  HomeRechargesBillsHub(items: _rechargesBillsItems(context, l10n)),
                  const SizedBox(height: 24),
                  HomeSectionTitle(
                    title: l10n.homeHubGoldSilver,
                    showViewAll: true,
                    onViewAllTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const GoldSilverAllServicesScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  const HomeGoldSilverHub(),
                  const SizedBox(height: 24),
                  const HomeInsuranceBanner(),
                  HomeSectionTitle(title: l10n.homeHubInsurance),
                  const SizedBox(height: 12),
                  const HomeInsuranceHub(),
                  const SizedBox(height: 24),
                  HomeSectionTitle(title: l10n.homeHubTravel),
                  const SizedBox(height: 12),
                  const HomeTravelHub(),
                  const SizedBox(height: 24),
                  HomeSectionTitle(title: l10n.homeHubFinancial),
                  const SizedBox(height: 12),
                  const HomeFinancialHub(),
                  const SizedBox(height: 24),
                  HomeSectionTitle(
                    title: l10n.homeHubConvenient,
                    showViewAll: true,
                    onViewAllTap: () {
                      final items = [
                        HomeIconGridItem(Icons.directions_car_rounded, l10n.homeIconTravel),
                        HomeIconGridItem(Icons.add_circle_outline_rounded, l10n.homeIconTopUp),
                        HomeIconGridItem(Icons.local_fire_department_rounded, l10n.homeIconUtilities),
                        HomeIconGridItem(Icons.business_rounded, l10n.homeIconCityServices),
                        HomeIconGridItem(Icons.card_giftcard_rounded, l10n.homeIconRewards),
                        HomeIconGridItem(Icons.family_restroom_rounded, l10n.homeIconFamilyCenter),
                        HomeIconGridItem(Icons.eco_rounded, l10n.homeIconCreditLife),
                        HomeIconGridItem(Icons.apps_rounded, l10n.homeIconMore),
                      ];
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HubDetailScreen(
                            title: l10n.homeHubConvenient,
                            items: items,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  const HomeConvenientHub(),
                  const SizedBox(height: 24),
                  HomeSectionTitle(title: l10n.homeHubService),
                  const SizedBox(height: 12),
                  HomeServiceHub(
                    onFirstMessageTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NotificationListScreen()),
                      );
                    },
                    onSecondMessageTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AddPromoScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  HomeSectionTitle(title: l10n.homeHubRewards),
                  const SizedBox(height: 12),
                  const HomeRewardsHub(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            HomeBottomNav(
              onWealthTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WealthHomeScreen()),
                );
              },
              onScanTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ScanQrScreen()),
                );
              },
              onDiscoverTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LearningHubScreen()),
                );
              },
              onProfileTap: () async {
                final authService = ref.read(firebaseAuthServiceProvider);
                if (authService.isLoggedIn()) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MyAccountScreen()),
                  );
                } else {
                  final loggedIn = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                  if (loggedIn == true && context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MyAccountScreen()),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
