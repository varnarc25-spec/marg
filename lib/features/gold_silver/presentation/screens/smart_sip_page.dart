import 'package:flutter/material.dart';
import 'gold_silver_common.dart';

class SmartSipPage extends StatelessWidget {
  const SmartSipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoldSilverFeaturePlaceholderPage(
      title: 'Smart SIP (Auto-buy on dips)',
      subtitle: 'Configure rules to auto-buy gold/silver when prices dip.',
      icon: Icons.auto_graph_rounded,
    );
  }
}

