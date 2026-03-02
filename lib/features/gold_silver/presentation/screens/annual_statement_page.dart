import 'package:flutter/material.dart';
import 'gold_silver_common.dart';

class AnnualStatementPage extends StatelessWidget {
  const AnnualStatementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoldSilverFeaturePlaceholderPage(
      title: 'Annual Statement',
      subtitle: 'Get a consolidated annual summary of your holdings and flows.',
      icon: Icons.description_rounded,
    );
  }
}

