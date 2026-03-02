import 'package:flutter/material.dart';
import 'gold_silver_common.dart';

class DailyGoldSavingsPage extends StatelessWidget {
  const DailyGoldSavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoldSilverFeaturePlaceholderPage(
      title: 'Daily Gold Savings',
      subtitle: 'Automate small daily contributions into digital gold.',
      icon: Icons.savings_rounded,
    );
  }
}

