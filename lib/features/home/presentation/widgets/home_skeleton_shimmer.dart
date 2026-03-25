import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeSkeletonShimmer extends StatelessWidget {
  const HomeSkeletonShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.grey.shade300;
    final highlightColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade700
        : Colors.grey.shade100;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, _) {
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 190,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        );
      },
    );
  }
}
