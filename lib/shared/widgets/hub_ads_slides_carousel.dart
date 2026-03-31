import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/presentation/utils/recharges_bills_hub.dart';
import '../models/hub_carousel_slide.dart';
import 'hub_banner_carousel.dart';

/// Generic hub ads carousel that can be embedded anywhere.
///
/// Target slides by `section` + optional `category` + optional `menuItem`.
class HubAdsSlidesCarousel extends ConsumerWidget {
  const HubAdsSlidesCarousel({
    super.key,
    required this.section,
    this.category,
    this.menuItem,
    this.height = 160,
  });

  final String section;
  final String? category;
  final String? menuItem;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSlides = ref.watch(
      hubAdsSlidesProvider(
        (
          section: section,
          category: category,
          menuItem: menuItem,
        ),
      ),
    );

    return asyncSlides.when(
      data: (List<HubCarouselSlide> slides) {
        if (slides.isEmpty) return const SizedBox.shrink();
        return HubBannerCarousel(
          slides: slides,
          height: height,
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

