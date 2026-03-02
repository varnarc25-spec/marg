import 'package:flutter/material.dart';
import 'gold_silver_common.dart';

class PortfolioHoldingsPage extends StatelessWidget {
  const PortfolioHoldingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoldSilverFeaturePlaceholderPage(
      title: 'Portfolio & Holdings',
      subtitle: 'Track quantity, average price, and current value of holdings.',
      icon: Icons.account_balance_wallet_rounded,
    );
  }
}

