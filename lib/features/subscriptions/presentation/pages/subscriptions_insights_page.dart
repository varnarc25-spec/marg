import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class SubscriptionsInsightsPage extends ConsumerWidget {
  const SubscriptionsInsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Insights'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: const Center(child: Text('TODO: Savings tips, shared subscription UI')),
    );
  }
}
