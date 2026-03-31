import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../features/home/presentation/utils/home_flow_router.dart';
import '../../features/home/services_catalog_helpers.dart';
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

  /// Same priority as [DynamicHomeBannersWidget]: external link → flow type → service slug.
  Future<void> _handleCta(HubCarouselSlide slide) async {
    final link = slide.buttonLink?.trim();
    if (link != null && link.isNotEmpty) {
      final uri = Uri.tryParse(link);
      if (uri == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid link'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open link'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final flow = slide.buttonFlowType?.trim();
    if (flow != null && flow.isNotEmpty) {
      if (!mounted) return;
      routeByFlowType(context, flow);
      return;
    }

    final slug = slide.buttonActionSlug?.trim();
    if (slug != null && slug.isNotEmpty) {
      if (!mounted) return;
      navigateToServiceBySlug(context, slug);
    }
  }

  @override
  Widget build(BuildContext context) {
    final slides = widget.slides;
    if (slides.isEmpty) {
      return const SizedBox.shrink();
    }

    final anyButton = slides.any((s) => s.showsButton);
    final carouselHeight = anyButton ? 196.0 : widget.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: carouselHeight,
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
              final ctaFg = colors.isNotEmpty ? colors.first : const Color(0xFF1A237E);

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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (hasIcon)
                              Align(
                                alignment: Alignment.centerRight,
                                child: Opacity(
                                  opacity: 0.4,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: iconUrl,
                                      width: 52,
                                      height: 52,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) =>
                                          const SizedBox(width: 52, height: 52),
                                    ),
                                  ),
                                ),
                              ),
                            if (hasIcon) const SizedBox(height: 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    slide.title,
                                    style: GoogleFonts.mulish(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      height: 1.2,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (slide.subtitle != null &&
                                      slide.subtitle!.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      slide.subtitle!,
                                      style: GoogleFonts.mulish(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withValues(alpha: 0.9),
                                        height: 1.25,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (slide.showsButton) ...[
                              const SizedBox(height: 8),
                              FilledButton(
                                onPressed: slide.hasCtaTarget
                                    ? () => _handleCta(slide)
                                    : null,
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: ctaFg,
                                  disabledBackgroundColor:
                                      Colors.white.withValues(alpha: 0.65),
                                  disabledForegroundColor: ctaFg.withValues(alpha: 0.5),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        slide.buttonText!.trim(),
                                        style: GoogleFonts.mulish(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 18,
                                      color: slide.hasCtaTarget
                                          ? ctaFg
                                          : ctaFg.withValues(alpha: 0.45),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
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
