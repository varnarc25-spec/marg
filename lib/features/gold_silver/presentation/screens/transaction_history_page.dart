import 'package:flutter/material.dart';
import 'gold_silver_common.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoldSilverFeaturePlaceholderPage(
      title: 'Transaction History',
      subtitle: 'Browse all buy, sell, convert and gift transactions.',
      icon: Icons.history_rounded,
    );
  }
}

