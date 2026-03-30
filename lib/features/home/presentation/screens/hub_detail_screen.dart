import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/hub_carousel_slide.dart';
import '../../../../shared/models/hub_menu_item.dart';
import '../../../../shared/models/services_catalog.dart';
import '../../../../shared/widgets/hub_banner_carousel.dart';
import '../../services_catalog_helpers.dart';
import '../utils/recharges_bills_hub.dart'
    show hubAdsSlidesForSectionProvider, hubMenuItemsBySectionProvider;
import '../widgets/home_icon_grid_widget.dart';

/// Detail screen for a hub: carousel from [GET /api/hub-ads-slides] when [adsSectionSlug] is set,
/// menu from [GET /api/services/menu-items] when [menuSectionSlug] is set (grouped by category),
/// with fallback to [items].
class HubDetailScreen extends ConsumerWidget {
  const HubDetailScreen({
    super.key,
    required this.title,
    required this.items,
    this.adsSectionSlug,
    this.menuSectionSlug,
    this.carouselSlides = const [],
  });

  final String title;
  final List<HomeIconGridItem> items;

  /// Home / hub section slug; triggers [hubAdsSlidesForSectionProvider] (API + slug aliases).
  final String? adsSectionSlug;

  /// Same slug family as ads; loads [hubMenuItemsBySectionProvider] and shows items by category.
  final String? menuSectionSlug;

  /// Static slides when [adsSectionSlug] is null (e.g. tests).
  final List<HubCarouselSlide> carouselSlides;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ads = adsSectionSlug?.trim();
    if (ads != null && ads.isNotEmpty) {
      final asyncSlides = ref.watch(hubAdsSlidesForSectionProvider(ads));
      return asyncSlides.when(
        data: (slides) => _HubDetailScaffold(
          title: title,
          items: items,
          slides: slides,
          menuSectionSlug: menuSectionSlug,
        ),
        loading: () => _HubDetailScaffold(
          title: title,
          items: items,
          slides: const [],
          loadingCarousel: true,
          menuSectionSlug: menuSectionSlug,
        ),
        error: (_, __) => _HubDetailScaffold(
          title: title,
          items: items,
          slides: HubCarouselSample.slides,
          menuSectionSlug: menuSectionSlug,
        ),
      );
    }

    return _HubDetailScaffold(
      title: title,
      items: items,
      slides: carouselSlides,
      menuSectionSlug: menuSectionSlug,
    );
  }
}

class _HubDetailScaffold extends ConsumerWidget {
  const _HubDetailScaffold({
    required this.title,
    required this.items,
    required this.slides,
    this.loadingCarousel = false,
    this.menuSectionSlug,
  });

  final String title;
  final List<HomeIconGridItem> items;
  final List<HubCarouselSlide> slides;
  final bool loadingCarousel;
  final String? menuSectionSlug;

  List<Widget> _menuWidgets(BuildContext context, List<HubMenuItem> apiItems) {
    if (apiItems.isEmpty) {
      return [HomeIconGrid(items: items, columns: 4)];
    }
    final groups = groupHubMenuItemsByCategory(apiItems);
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
    final orderStyle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
    );
    final out = <Widget>[];
    for (var i = 0; i < groups.length; i++) {
      final g = groups[i];
      final orderLabel =
          g.categoryDisplayOrder >= HubMenuItem.unorderedCategorySortKey
              ? '—'
              : '${g.categoryDisplayOrder}';
      out.add(
        Padding(
          padding: EdgeInsets.fromLTRB(16, i == 0 ? 8 : 20, 16, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(g.title, style: titleStyle),
              ),
              Text(orderLabel, style: orderStyle),
            ],
          ),
        ),
      );
      out.add(
        HomeIconGrid(
          columns: 4,
          items: g.items
              .map(
                (m) => HomeIconGridItem(
                  iconForCatalogItem(
                    CatalogItem(
                      id: 0,
                      name: m.name,
                      slug: m.slug,
                      iconName: m.iconName,
                    ),
                  ),
                  m.name,
                  onTap: () => navigateToServiceBySlug(context, m.slug),
                ),
              )
              .toList(),
        ),
      );
    }
    return out;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showCarousel = loadingCarousel || slides.isNotEmpty;
    final menuKey = menuSectionSlug?.trim();

    final List<Widget> menuSection;
    if (menuKey != null && menuKey.isNotEmpty) {
      final asyncMenu = ref.watch(hubMenuItemsBySectionProvider(menuKey));
      menuSection = asyncMenu.when(
        data: (list) => _menuWidgets(context, list),
        loading: () => [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
        error: (_, __) => [HomeIconGrid(items: items, columns: 4)],
      );
    } else {
      menuSection = [HomeIconGrid(items: items, columns: 4)];
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
        children: [
          const SizedBox(height: 12),
          if (loadingCarousel)
            const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (showCarousel)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: HubBannerCarousel(slides: slides),
            ),
          ...menuSection,
        ],
      ),
    );
  }
}
