import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../providers/dth_recharge_provider.dart';
import 'dth_success_page.dart';

/// Payment confirmation before initiating DTH recharge.
/// TODO: Integrate with payment gateway (UPI/card/netbanking).
class DthPaymentConfirmationPage extends ConsumerWidget {
  const DthPaymentConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operator = ref.watch(selectedDthOperatorProvider);
    final number = ref.watch(dthSubscriberIdProvider);
    final plan = ref.watch(selectedDthPlanProvider);
    var isLoading = false;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Confirm payment'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      operator?.name ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      number,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (plan != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        plan.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '₹${plan.amount}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pay with',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet_rounded),
                title: const Text('UPI'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Payment gateway - UPI intent
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.credit_card_rounded),
                title: const Text('Card / Net Banking'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Payment gateway - card/netbanking
                },
              ),
            ),
            const SizedBox(height: 32),
            StatefulBuilder(
              builder: (context, setState) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (operator == null || plan == null) return;
                            setState(() => isLoading = true);
                            final repo = ref.read(
                              dthRechargeRepositoryProvider,
                            );
                            final ok = await repo.performRecharge(
                              operatorId: operator.id,
                              subscriberId: number,
                              amount: plan.amount,
                            );
                            if (context.mounted) {
                              setState(() => isLoading = false);
                              if (ok) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const DthSuccessPage(),
                                  ),
                                  (route) => route.isFirst,
                                );
                              }
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text('Pay ₹${plan?.amount ?? 0}'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
