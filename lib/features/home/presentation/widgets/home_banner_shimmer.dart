import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Placeholder while GET /api/banners loads.
class HomeBannerShimmer extends StatelessWidget {
  const HomeBannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.grey.shade300;
    final highlight = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade700
        : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        height: 148,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
