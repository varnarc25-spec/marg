import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../shared/providers/app_providers.dart';
import '../widgets/home_widgets.dart';
import '../../../../shared/widgets/marg_header.dart';
import '../../../../shared/widgets/app_logo.dart';
import 'gold_silver_all_services_screen.dart';
import 'wealth_home_screen.dart';
import 'ai_assistant_screen.dart';
import '../../../accounts/presentation/screens/my_account_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../learning/presentation/screens/learning_hub_screen.dart';
import '../../../messages_notifications/presentation/screens/notification_list_screen.dart';
import '../../../payments/presentation/screens/add_promo_screen.dart';
import '../../../scan/presentation/screens/scan_qr_screen.dart';
import '../../services_catalog_helpers.dart';
import '../../../../core/utils/services_catalog_utils.dart';
import '../utils/recharges_bills_hub.dart';
// Recharges & Bills feature entries (feature-scoped navigation)
import '../../../recharges/mobile/presentation/routes/mobile_recharge_routes.dart';
import '../../../recharges/dth/presentation/routes/dth_recharge_routes.dart';
import '../../../utilities/electricity/presentation/routes/electricity_routes.dart';
import '../../../utilities/water/presentation/routes/water_routes.dart';
import '../../../utilities/gas/presentation/routes/gas_routes.dart';
import '../../../utilities/book_cylinder/presentation/routes/gas_routes.dart';
import '../../../utilities/broadband/presentation/routes/broadband_routes.dart';
import '../../../utilities/loan_repayment/presentation/routes/loan_repayment_routes.dart';
import '../../../fastag/presentation/routes/fastag_routes.dart';
import '../../../education/presentation/routes/education_routes.dart';
import '../../../government_bills/presentation/routes/government_bills_routes.dart';

/// Home Dashboard Screen
/// Search, quick actions, Financial Hub, Convenient Hub, Service Hub, Rewards Hub, bottom nav
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// Recharges & Bills hub items with navigation to each feature. Used for grid and View All.
  static List<HomeIconGridItem> _rechargesBillsItems(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return [
      HomeIconGridItem(
        Icons.phone_android_rounded,
        l10n.homeRechargeMobile,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MobileRechargeRoutes.entryPage()),
        ),
      ),
      HomeIconGridItem(
        Icons.tv_rounded,
        l10n.homeRechargeDth,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DthRechargeRoutes.entryPage()),
        ),
      ),
      HomeIconGridItem(
        Icons.directions_car_rounded,
        l10n.homeRechargeFastag,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => FastagRoutes.entryPage())),
      ),
      HomeIconGridItem(
        Icons.bolt_rounded,
        l10n.homeRechargeElectricity,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ElectricityRoutes.entryPage()),
        ),
      ),
      HomeIconGridItem(
        Icons.plumbing_rounded,
        l10n.homeRechargeWater,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => WaterRoutes.entryPage())),
      ),
      HomeIconGridItem(
        Icons.propane_tank_rounded,
        l10n.homeRechargeBookCylinder,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => BookCylinderRoutes.entryPage()),
        ),
      ),
      HomeIconGridItem(
        Icons.gas_meter_rounded,
        l10n.homeRechargePipedGas,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => GasRoutes.entryPage())),
      ),
      HomeIconGridItem(
        Icons.wifi_rounded,
        l10n.homeRechargeBroadband,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => BroadbandRoutes.entryPage())),
      ),
      HomeIconGridItem(
        Icons.school_rounded,
        l10n.homeRechargeSchoolFees,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => EducationRoutes.entryPage())),
      ),
      HomeIconGridItem(
        Icons.water_drop_rounded,
        l10n.homeRechargeMunicipal,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => GovernmentBillsRoutes.entryPage()),
        ),
      ),
      HomeIconGridItem(
        Icons.account_balance_rounded,
        l10n.homeRechargeLoanEmi,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => LoanRepaymentRoutes.entryPage()),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    final catalogAsync = ref.watch(servicesCatalogProvider);
    final rechargesItems = watchRechargesBillsHubItems(context, ref);
    final remoteBrand = ref.watch(appRemoteSettingsProvider).valueOrNull;

    final List<HomeIconGridItem>? digigoldItems = catalogAsync
        .whenOrNull<List<HomeIconGridItem>>(
          data: (catalog) {
            return mappedCatalogItemsByCategorySlug<HomeIconGridItem>(
              catalog,
              categorySlug: 'digigold',
              itemMapper: (e) => HomeIconGridItem(
                iconForCatalogItem(e),
                e.name,
                onTap: () => navigateToServiceBySlug(context, e.slug),
              ),
            );
          },
        );

    final List<HomeIconGridItem>? insuranceItems = catalogAsync
        .whenOrNull<List<HomeIconGridItem>>(
          data: (catalog) {
            return mappedCatalogItemsByCategory<HomeIconGridItem>(
              catalog,
              category: 'insurance',
              itemMapper: (e) => HomeIconGridItem(
                iconForCatalogItem(e),
                e.name,
                onTap: () => navigateToServiceBySlug(context, e.slug),
              ),
            );
          },
        );

    final List<HomeIconGridItem>? travelItems = catalogAsync
        .whenOrNull<List<HomeIconGridItem>>(
          data: (catalog) {
            return mappedCatalogItemsByCategory<HomeIconGridItem>(
              catalog,
              category: 'travel',
              itemMapper: (e) => HomeIconGridItem(
                iconForCatalogItem(e),
                e.name,
                onTap: () => navigateToServiceBySlug(context, e.slug),
              ),
            );
          },
        );
    final List<HomeIconGridItem>? financialItems = catalogAsync
        .whenOrNull<List<HomeIconGridItem>>(
          data: (catalog) {
            return mappedCatalogItemsByCategory<HomeIconGridItem>(
              catalog,
              category: 'financial',
              itemMapper: (e) => HomeIconGridItem(
                iconForCatalogItem(e),
                e.name,
                onTap: () => navigateToServiceBySlug(context, e.slug),
              ),
            );
          },
        );

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            MargHeader(
              l10n: l10n,
              brandName: remoteBrand?.displayAppName,
              logoUrl: remoteBrand?.logoUrl,
              onAiTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AiAssistantScreen()),
                );
              },
            ),
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
                      pushHubDetailScreen(
                        context,
                        title: l10n.homeHubRechargesBills,
                        items: rechargesItems,
                        adsSectionSlug: 'recharges-bills',
                        menuSectionSlug: 'recharges-bills',
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  HomeRechargesBillsHub(items: rechargesItems),
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
                  HomeGoldSilverHub(items: digigoldItems),
                  if (insuranceItems != null) ...[
                    const SizedBox(height: 24),
                    const HomeInsuranceBanner(),
                    HomeSectionTitle(title: l10n.homeHubInsurance),
                    const SizedBox(height: 12),
                    HomeInsuranceHub(items: insuranceItems),
                  ],
                  if (travelItems != null) ...[
                    HomeSectionTitle(title: l10n.homeHubTravel),
                    const SizedBox(height: 12),
                    HomeTravelHub(items: travelItems),
                  ],
                  if (financialItems != null) ...[
                    HomeSectionTitle(title: l10n.homeHubFinancial),
                    const SizedBox(height: 12),
                    HomeTravelHub(items: financialItems),
                  ],
                  // const SizedBox(height: 24),
                  // HomeSectionTitle(title: l10n.homeHubFinancial),
                  // const SizedBox(height: 12),
                  // const HomeFinancialHub(),
                  const SizedBox(height: 24),
                  HomeSectionTitle(title: l10n.homeHubConvenient),
                  const SizedBox(height: 12),
                  const HomeConvenientHub(),
                  const SizedBox(height: 24),
                  HomeSectionTitle(title: l10n.homeHubService),
                  const SizedBox(height: 12),
                  HomeServiceHub(
                    onFirstMessageTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NotificationListScreen(),
                        ),
                      );
                    },
                    onSecondMessageTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddPromoScreen(),
                        ),
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
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const ScanQrScreen()));
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
                      MaterialPageRoute(
                        builder: (_) => const MyAccountScreen(),
                      ),
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

Widget _buildMargHeader(BuildContext context, AppLocalizations l10n) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        const AppLogo(size: 28),
        const SizedBox(width: 8),
        Text(
          l10n.appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.appLogo,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AiAssistantScreen()),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'AI',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
          onPressed: () {},
        ),
      ],
    ),
  );
}
