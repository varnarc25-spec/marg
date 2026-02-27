import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/dth_plan.dart';
import '../providers/dth_recharge_provider.dart';
import 'dth_payment_success_page.dart';

class DthPlanListPage extends ConsumerWidget {
  const DthPlanListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final op = ref.watch(selectedDthOperatorProvider);
    final plansAsync = op != null ? ref.watch(dthPlansProvider(op.id)) : null;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Select plan'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: plansAsync == null
          ? const Center(child: Text('Select operator first'))
          : plansAsync.when(
              data: (plans) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: plans.length,
                itemBuilder: (_, i) {
                  final plan = plans[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: plan.isBestValue ? AppColors.primaryBlueLight.withValues(alpha: 0.15) : null,
                    child: ListTile(
                      title: Text(plan.name),
                      subtitle: plan.validity.isNotEmpty ? Text(plan.validity) : null,
                      trailing: Text('₹${plan.amount}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                      onTap: () async {
                        ref.read(selectedDthPlanProvider.notifier).state = plan;
                        final repo = ref.read(dthRechargeRepositoryProvider);
                        final sid = ref.read(dthSubscriberIdProvider);
                        final ok = await repo.performRecharge(operatorId: op!.id, subscriberId: sid, amount: plan.amount);
                        if (context.mounted && ok) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DthPaymentSuccessPage()));
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
