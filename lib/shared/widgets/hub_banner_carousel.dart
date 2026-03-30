import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../models/hub_carousel_slide.dart';

/// Promo carousel for hub detail and similar screens. Slide count follows [slides].
/// When [slides] is empty, [build] returns [SizedBox.shrink] — hide the whole block in the parent.
class HubBannerCarousel extends StatefulWidget {
  const HubBannerCarousel({
    super.key,
    required this.slides,
    this.height = 160,
    this.viewportFraction = 0.92,
  });

  final List<HubCarouselSlide> slides;
  final double height;
  final double viewportFraction;

  @override
  State<HubBannerCarousel> createState() => _HubBannerCarouselState();
}

class _HubBannerCarouselState extends State<HubBannerCarousel> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Color> _gradientFor(HubCarouselSlide slide) {
    final hexes = slide.gradientColors;
    if (hexes != null && hexes.isNotEmpty) {
      return hexes.map(hubCarouselParseHexColor).toList();
    }
    return const [
      Color(0xFF1565C0),
      Color(0xFF1976D2),
      Color(0xFF1E88E5),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final slides = widget.slides;
    if (slides.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            itemBuilder: (context, index) {
              final slide = slides[index];
              final colors = _gradientFor(slide);
              final bgImage = slide.image;
              final hasImage = bgImage != null && bgImage.isNotEmpty;
              final iconUrl = slide.icon;
              final hasIcon = iconUrl != null && iconUrl.isNotEmpty;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (hasImage)
                        CachedNetworkImage(
                          imageUrl: bgImage,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: hasImage
                                ? [
                                    colors.first.withValues(alpha: 0.88),
                                    colors.last.withValues(alpha: 0.82),
                                  ]
                                : colors,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (hasIcon) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: iconUrl,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) =>
                                        const SizedBox(width: 44, height: 44),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                              Text(
                                slide.title,
                                style: GoogleFonts.mulish(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (slide.subtitle != null &&
                                  slide.subtitle!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  slide.subtitle!,
                                  style: GoogleFonts.mulish(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.92),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (slides.length > 1) ...[
          const SizedBox(height: 12),
          _HubCarouselDotIndicator(
            controller: _controller,
            itemCount: slides.length,
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

class _HubCarouselDotIndicator extends StatelessWidget {
  const _HubCarouselDotIndicator({
    required this.controller,
    required this.itemCount,
  });

  final PageController controller;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final page = controller.hasClients ? controller.page ?? 0 : 0.0;
        final current = page.round().clamp(0, itemCount - 1);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (i) {
            final isActive = i == current;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryBlue
                    : AppColors.textSecondary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}
