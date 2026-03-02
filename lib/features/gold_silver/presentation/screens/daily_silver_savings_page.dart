import 'package:flutter/material.dart';
import 'gold_silver_common.dart';

class DailySilverSavingsPage extends StatelessWidget {
  const DailySilverSavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoldSilverFeaturePlaceholderPage(
      title: 'Daily Silver Savings',
      subtitle: 'Build long-term silver exposure with SIP-style investments.',
      icon: Icons.savings_outlined,
    );
  }
}

