import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../providers/dth_recharge_provider.dart';
import '../widgets/dth_plan_tile.dart';
import 'dth_payment_success_page.dart';

/// Plan list for DTH recharge (mirrors [MobilePlanListPage] layout and tiles).
class DthPlanListPage extends ConsumerWidget {
  const DthPlanListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final op = ref.watch(selectedDthOperatorProvider);
    final plansAsync = op != null ? ref.watch(dthPlansProvider(op.id)) : null;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Select plan'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: plansAsync == null
          ? const Center(child: Text('Select operator first'))
          : plansAsync.when(
              data: (plans) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: plans.length,
                itemBuilder: (_, i) {
                  final plan = plans[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DthPlanTile(
                      plan: plan,
                      onTap: () async {
                        ref.read(selectedDthPlanProvider.notifier).state = plan;
                        final repo = ref.read(dthRechargeRepositoryProvider);
                        final sid = ref.read(dthSubscriberIdProvider);
                        final ok = await repo.performRecharge(
                          operatorId: op!.id,
                          subscriberId: sid,
                          amount: plan.amount,
                        );
                        if (context.mounted && ok) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const DthPaymentSuccessPage()),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
    );
  }
}
