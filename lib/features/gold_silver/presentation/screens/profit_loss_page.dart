import 'package:flutter/material.dart';
import 'gold_silver_common.dart';

class ProfitLossPage extends StatelessWidget {
  const ProfitLossPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoldSilverFeaturePlaceholderPage(
      title: 'Profit / Loss',
      subtitle: 'View mark-to-market P&L across all gold & silver positions.',
      icon: Icons.show_chart_rounded,
    );
  }
}

