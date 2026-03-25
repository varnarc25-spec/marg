import 'package:flutter/material.dart';

import '../../data/models/life_benefit_item.dart';

/// Benefits grid when API bootstrap has no items or failed.
class LifeHomeBenefitsGrid extends StatelessWidget {
  const LifeHomeBenefitsGrid({
    super.key,
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  static const List<MapEntry<String, IconData>> _items = [
    MapEntry('Pre-approved Offers', Icons.verified_user_rounded),
    MapEntry('Zero Cost Insurance', Icons.money_off_rounded),
    MapEntry('Upto 10% discount', Icons.discount_rounded),
    MapEntry('Relationship Manager', Icons.support_agent_rounded),
    MapEntry('Claims Support', Icons.shield_rounded),
    MapEntry('Customizable Payment Options', Icons.payment_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: _items.map((e) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(e.value, size: 28, color: colorScheme.primary),
                const SizedBox(height: 8),
                Text(
                  e.key,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Benefits grid from `GET` home bootstrap API.
class LifeHomeBenefitsFromApi extends StatelessWidget {
  const LifeHomeBenefitsFromApi({
    super.key,
    required this.items,
    required this.colorScheme,
    required this.textTheme,
  });

  final List<LifeBenefitItem> items;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: items.take(6).map((e) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(e.resolveIcon(), size: 28, color: colorScheme.primary),
                const SizedBox(height: 8),
                Text(
                  e.title,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
