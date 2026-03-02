import 'package:flutter/material.dart';
import 'gold_silver_common.dart';

class PriceAlertsPage extends StatelessWidget {
  const PriceAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoldSilverFeaturePlaceholderPage(
      title: 'Price Alerts',
      subtitle: 'Set custom alerts when gold or silver crosses your target levels.',
      icon: Icons.notifications_active_rounded,
    );
  }
}

