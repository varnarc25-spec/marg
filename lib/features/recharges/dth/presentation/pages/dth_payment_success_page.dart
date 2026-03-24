import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../providers/dth_recharge_provider.dart';
import 'dth_recharge_home_page.dart';

class DthPaymentSuccessPage extends ConsumerWidget {
  const DthPaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(selectedDthPlanProvider);
    final txn = ref.watch(dthLastTransactionIdProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.accentGreen,
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                'DTH recharge initiated',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              if (plan != null) ...[
                const SizedBox(height: 8),
                Text(
                  '₹${plan.amount}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
              if (txn != null && txn.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Ref: $txn',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil<void>(
                      MaterialPageRoute(
                        builder: (_) => const DthRechargeHomePage(),
                      ),
                      (route) => route.isFirst,
                    );
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
