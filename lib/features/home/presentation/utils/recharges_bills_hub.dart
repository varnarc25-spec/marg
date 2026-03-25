import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/services_catalog_utils.dart';
import '../../../../shared/models/services_catalog.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../credit_card/presentation/routes/credit_card_routes.dart';
import '../../../education/presentation/routes/education_routes.dart';
import '../../../fastag/presentation/routes/fastag_routes.dart';
import '../../../government_bills/presentation/routes/government_bills_routes.dart';
import '../../../recharges/dth/presentation/routes/dth_recharge_routes.dart';
import '../../../recharges/mobile/presentation/routes/mobile_recharge_routes.dart';
import '../../../utilities/broadband/presentation/routes/broadband_routes.dart';
import '../../../utilities/electricity/presentation/routes/electricity_routes.dart';
import '../../services_catalog_helpers.dart';
import '../screens/gold_silver_all_services_screen.dart';
import '../screens/hub_detail_screen.dart';
import '../widgets/home_icon_grid_widget.dart';

/// API home section slugs that should open the same hub as [HomeScreen] "View all".
bool isRechargesBillsHomeSectionSlug(String slug) {
  switch (slug.toLowerCase()) {
    case 'recharge-home':
    case 'recharges-bills':
    case 'recharges_bills':
      return true;
    default:
      return false;
  }
}

/// API home section slugs for Gold & Silver — same destination as [HomeScreen] View all.
bool isGoldSilverHomeSectionSlug(String slug) {
  switch (slug.toLowerCase().trim()) {
    case 'digigold':
    case 'gold-silver':
    case 'gold_silver':
    case 'gold-and-silver':
      return true;
    default:
      return false;
  }
}

/// Same navigation as [HomeScreen] Gold & Silver "View all".
void openGoldSilverAllServicesScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const GoldSilverAllServicesScreen(),
    ),
  );
}

/// View All for dynamic home ([homescreen1.dart]): mirrors [HomeScreen] where we have a dedicated full page.
///
/// Returns `null` when the generic [HomeSectionAllScreen] (all API items for that section) should be used.
VoidCallback? viewAllOnTapForDynamicHomeSection(
  BuildContext context,
  WidgetRef ref,
  String sectionSlug,
) {
  if (isRechargesBillsHomeSectionSlug(sectionSlug)) {
    return () => openRechargesBillsHubDetail(context, ref);
  }
  if (isGoldSilverHomeSectionSlug(sectionSlug)) {
    return () => openGoldSilverAllServicesScreen(context);
  }
  return null;
}

/// Static grid when catalog is unavailable (matches [HomeScreen] fallback).
List<HomeIconGridItem> defaultRechargesBillsItems(
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
      Icons.wifi_rounded,
      l10n.homeRechargeBroadband,
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => BroadbandRoutes.entryPage())),
    ),
    HomeIconGridItem(
      Icons.credit_card_rounded,
      l10n.homeRechargeCreditCard,
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => CreditCardRoutes.entryPage())),
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
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => CreditCardRoutes.entryPage())),
    ),
  ];
}

List<HomeIconGridItem>? _itemsFromCatalog(
  BuildContext context,
  ServicesCatalog? catalog,
) {
  if (catalog == null || catalog.categories.isEmpty) return null;
  final items = catalogItemsByCategorySlugs(
    catalog,
    categorySlugs: {'recharges', 'utilities'},
  );
  if (items.isEmpty) return null;
  return items
      .map(
        (e) => HomeIconGridItem(
          iconForCatalogItem(e),
          e.name,
          onTap: () => navigateToServiceBySlug(context, e.slug),
        ),
      )
      .toList();
}

/// For widgets: rebuilds when catalog loads (same logic as [HomeScreen] grid).
List<HomeIconGridItem> watchRechargesBillsHubItems(
  BuildContext context,
  WidgetRef ref,
) {
  final l10n = ref.watch(l10nProvider);
  return ref.watch(servicesCatalogProvider).whenOrNull<List<HomeIconGridItem>>(
        data: (catalog) => _itemsFromCatalog(context, catalog),
      ) ??
      defaultRechargesBillsItems(context, l10n);
}

/// For navigation callbacks: snapshot at tap time.
List<HomeIconGridItem> resolveRechargesBillsHubItems(
  BuildContext context,
  WidgetRef ref,
) {
  final l10n = ref.read(l10nProvider);
  return ref.read(servicesCatalogProvider).whenOrNull<List<HomeIconGridItem>>(
        data: (catalog) => _itemsFromCatalog(context, catalog),
      ) ??
      defaultRechargesBillsItems(context, l10n);
}

void openRechargesBillsHubDetail(BuildContext context, WidgetRef ref) {
  final l10n = ref.read(l10nProvider);
  final items = resolveRechargesBillsHubItems(context, ref);
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => HubDetailScreen(
        title: l10n.homeHubRechargesBills,
        items: items,
      ),
    ),
  );
}
