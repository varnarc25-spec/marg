import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../providers/dth_recharge_provider.dart';
import '../widgets/dth_plan_tile.dart';
import 'dth_payment_confirmation_page.dart';

/// Plans from `POST /api/recharges/dth/plans`.
class DthPlanListPage extends ConsumerWidget {
  const DthPlanListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final op = ref.watch(selectedDthOperatorProvider);
    final sub = ref.watch(dthSubscriberIdProvider).trim();

    if (op == null || sub.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Select plan'),
          backgroundColor: AppColors.surfaceLight,
          foregroundColor: AppColors.textPrimary,
        ),
        body: const Center(
          child: Text('Select operator and subscriber ID first.'),
        ),
      );
    }

    final plansAsync = ref.watch(dthPlansProvider(op.id));

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Select plan'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: plansAsync.when(
        data: (plans) {
          if (plans.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No data',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,
            itemBuilder: (_, i) {
              final plan = plans[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DthPlanTile(
                  plan: plan,
                  onTap: () {
                    ref.read(selectedDthPlanProvider.notifier).state = plan;
                    Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) => const DthPaymentConfirmationPage(),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'No data',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
