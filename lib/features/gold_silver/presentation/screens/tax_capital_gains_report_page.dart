import 'package:flutter/material.dart';
import 'gold_silver_common.dart';

class TaxCapitalGainsReportPage extends StatelessWidget {
  const TaxCapitalGainsReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoldSilverFeaturePlaceholderPage(
      title: 'Tax & Capital Gains Report',
      subtitle: 'Download ready-to-file capital gains statements for tax filing.',
      icon: Icons.receipt_long_rounded,
    );
  }
}

