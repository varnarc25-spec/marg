import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/services_catalog_utils.dart';
import '../../../../shared/models/hub_carousel_slide.dart';
import '../../../../shared/models/hub_menu_item.dart';
import '../../../../shared/models/services_catalog.dart';
import '../../../../core/services/marg_api_service.dart';
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
    case 'recharge-bill-payment':
    case 'recharges-bills':
    case 'recharges_bills':
      return true;
    default:
      return false;
  }
}

/// Query keys for [GET /api/hub-ads-slides] — tries home section slug first, then aliases
/// so admin can label slides `recharges-bills` while homescreen1 uses `recharge-home`, etc.
List<String> hubAdsSectionQueryKeys(String homeSectionSlug) {
  final s = homeSectionSlug.trim();
  if (s.isEmpty) return const [];
  final keys = <String>{s};
  if (isRechargesBillsHomeSectionSlug(s)) {
    keys.addAll(const [
      'recharge-bill-payment',
      'recharges-bills',
      'recharges_bills',
      'recharge-home',
    ]);
  }
  return keys.toList();
}

/// Targeting for [hubAdsSlidesProvider]: section slug from home/hub, optional category / menu item.
typedef HubAdsQuery = ({
  String section,
  String? category,
  String? menuItem,
});

bool _hubAdsHasNarrowTarget(String? category, String? menuItem) {
  final c = category?.trim();
  final m = menuItem?.trim();
  return (c != null && c.isNotEmpty) || (m != null && m.isNotEmpty);
}

/// Loads hub promo slides (tries [hubAdsSectionQueryKeys] for section aliases).
/// Uses [HubCarouselSample] only for wide hub queries with no slides; category/item queries return [] if empty.
Future<List<HubCarouselSlide>> fetchHubAdsSlidesForKeys(
  MargApiService api,
  String homeSectionSlug, {
  String? category,
  String? menuItem,
}) async {
  final candidates = hubAdsSectionQueryKeys(homeSectionSlug);
  if (candidates.isEmpty) return const <HubCarouselSlide>[];
  final narrow = _hubAdsHasNarrowTarget(category, menuItem);
  for (final section in candidates) {
    final slides = await api.getHubAdsSlides(
      section: section,
      category: category,
      menuItem: menuItem,
    );
    if (slides.isNotEmpty) {
      return slides;
    }
  }
  if (narrow) {
    return const <HubCarouselSlide>[];
  }
  return HubCarouselSample.slides;
}

/// Loads hub promo slides with optional [HubAdsQuery.category] / [HubAdsQuery.menuItem] for category/item screens.
final hubAdsSlidesProvider = FutureProvider.autoDispose
    .family<List<HubCarouselSlide>, HubAdsQuery>((ref, key) async {
      final api = ref.watch(margApiServiceProvider);
      return fetchHubAdsSlidesForKeys(
        api,
        key.section,
        category: key.category,
        menuItem: key.menuItem,
      );
    });

/// Hub overview: section-wide slides only (no category / menu item filter).
final hubAdsSlidesForSectionProvider = FutureProvider.autoDispose
    .family<List<HubCarouselSlide>, String>((ref, homeSectionSlug) async {
      final api = ref.watch(margApiServiceProvider);
      return fetchHubAdsSlidesForKeys(api, homeSectionSlug);
    });

/// Loads [GET /api/services/menu-items] using [hubAdsSectionQueryKeys] until a non-empty list is returned.
final hubMenuItemsBySectionProvider = FutureProvider.autoDispose
    .family<List<HubMenuItem>, String>((ref, homeSectionSlug) async {
      final candidates = hubAdsSectionQueryKeys(homeSectionSlug);
      if (candidates.isEmpty) return const <HubMenuItem>[];
      final api = ref.watch(margApiServiceProvider);
      for (final section in candidates) {
        final res = await api.getMenuItemsBySection(sectionSlug: section);
        if (res != null && res.items.isNotEmpty) {
          return res.items;
        }
      }
      return const <HubMenuItem>[];
    });

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
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => DthRechargeRoutes.entryPage())),
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
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => ElectricityRoutes.entryPage())),
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
  return ref
          .watch(servicesCatalogProvider)
          .whenOrNull<List<HomeIconGridItem>>(
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
  return ref
          .read(servicesCatalogProvider)
          .whenOrNull<List<HomeIconGridItem>>(
            data: (catalog) => _itemsFromCatalog(context, catalog),
          ) ??
      defaultRechargesBillsItems(context, l10n);
}

/// Pushes [HubDetailScreen] ([hub_detail_screen.dart]): carousel loads via
/// [hubAdsSlidesProvider] when [adsSectionSlug] is set.
void pushHubDetailScreen(
  BuildContext context, {
  required String title,
  required List<HomeIconGridItem> items,
  String? adsSectionSlug,
  String? adsCategorySlug,
  String? adsMenuItemSlug,

  /// When set, loads menu items from [hubMenuItemsBySectionProvider] and shows them grouped by category.
  String? menuSectionSlug,
  List<HubCarouselSlide> carouselSlides = const [],
}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/hub/recharges-bills'),
      builder: (_) => HubDetailScreen(
        title: title,
        items: items,
        adsSectionSlug: adsSectionSlug,
        adsCategorySlug: adsCategorySlug,
        adsMenuItemSlug: adsMenuItemSlug,
        menuSectionSlug: menuSectionSlug,
        carouselSlides: carouselSlides,
      ),
    ),
  );
}

void openRechargesBillsHubDetail(
  BuildContext context,
  WidgetRef ref, {
  String sectionSlug = 'recharge-bill-payment',
}) {
  final l10n = ref.read(l10nProvider);
  final items = resolveRechargesBillsHubItems(context, ref);
  if (!context.mounted) return;
  pushHubDetailScreen(
    context,
    title: l10n.homeHubRechargesBills,
    items: items,
    adsSectionSlug: sectionSlug,
    menuSectionSlug: sectionSlug,
  );
}
