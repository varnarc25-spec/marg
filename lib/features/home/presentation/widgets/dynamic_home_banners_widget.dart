import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/app_banner_model.dart';
import '../../services_catalog_helpers.dart';
import '../utils/home_flow_router.dart';

/// Carousel of API-driven banners; tap uses link_url, then flow_type, then action_slug.
class DynamicHomeBannersWidget extends StatefulWidget {
  const DynamicHomeBannersWidget({super.key, required this.banners});

  final List<AppBanner> banners;

  @override
  State<DynamicHomeBannersWidget> createState() =>
      _DynamicHomeBannersWidgetState();
}

class _DynamicHomeBannersWidgetState extends State<DynamicHomeBannersWidget> {
  late final PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onTap(AppBanner b) async {
    final link = b.linkUrl?.trim();
    if (link != null && link.isNotEmpty) {
      final uri = Uri.tryParse(link);
      if (uri != null &&
          await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        return;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open link'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final flow = b.flowType?.trim();
    if (flow != null && flow.isNotEmpty) {
      if (!mounted) return;
      routeByFlowType(context, flow);
      return;
    }

    final slug = b.actionSlug?.trim();
    if (slug != null && slug.isNotEmpty) {
      if (!mounted) return;
      navigateToServiceBySlug(context, slug);
    }
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 148,
          child: PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, index) {
              final b = banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _onTap(b),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: b.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image_outlined),
                            ),
                          ),
                          if ((b.title ?? '').isNotEmpty ||
                              (b.subtitle ?? '').isNotEmpty)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.65),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    24,
                                    0,
                                    10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if ((b.title ?? '').isNotEmpty)
                                        Text(
                                          b.title!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ),
                                        ),
                                      if ((b.subtitle ?? '').isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          b.subtitle!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (banners.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(banners.length, (i) {
              final active = i == _page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: active
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.35),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
