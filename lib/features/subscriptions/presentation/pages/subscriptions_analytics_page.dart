import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/subscriptions_provider.dart';

class SubscriptionsAnalyticsPage extends ConsumerWidget {
  const SubscriptionsAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(subscriptionsListProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Monthly spend'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: async.when(
        data: (list) {
          final monthly = list.fold<double>(0, (sum, s) => sum + (s.cycle == 'monthly' ? s.amount : s.amount / 12));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('This month', style: TextStyle(color: AppColors.textSecondary)),
                      Text('₹${monthly.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('TODO: Chart by category', style: TextStyle(color: AppColors.textSecondary)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
