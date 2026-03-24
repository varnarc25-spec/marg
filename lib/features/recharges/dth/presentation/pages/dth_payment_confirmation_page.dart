import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../providers/dth_recharge_provider.dart';
import 'dth_payment_success_page.dart';

/// Confirm and call `POST /api/recharges/dth/initiate`.
class DthPaymentConfirmationPage extends ConsumerStatefulWidget {
  const DthPaymentConfirmationPage({super.key});

  @override
  ConsumerState<DthPaymentConfirmationPage> createState() =>
      _DthPaymentConfirmationPageState();
}

class _DthPaymentConfirmationPageState
    extends ConsumerState<DthPaymentConfirmationPage> {
  bool _loading = false;

  Future<void> _pay() async {
    final operator = ref.read(selectedDthOperatorProvider);
    final number = ref.read(dthSubscriberIdProvider);
    final plan = ref.read(selectedDthPlanProvider);
    if (operator == null || plan == null || number.trim().isEmpty) return;

    setState(() => _loading = true);
    try {
      final repo = ref.read(dthRechargeRepositoryProvider);
      final res = await repo.initiateRecharge(
        operatorId: operator.id,
        subscriberId: number.trim(),
        plan: plan,
      );
      final txnId = res['id']?.toString() ??
          res['transactionId']?.toString() ??
          res['rechargeId']?.toString();
      ref.read(dthLastTransactionIdProvider.notifier).state = txnId;
      ref.invalidate(dthSavedAccountsProvider);
      ref.invalidate(dthHistoryProvider);
      if (!mounted) return;
      await Navigator.of(context).pushAndRemoveUntil<void>(
        MaterialPageRoute(builder: (_) => const DthPaymentSuccessPage()),
        (route) => route.isFirst,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final operator = ref.watch(selectedDthOperatorProvider);
    final number = ref.watch(dthSubscriberIdProvider);
    final plan = ref.watch(selectedDthPlanProvider);

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
              'Complete payment to recharge your DTH.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: (_loading || plan == null) ? null : _pay,
                child: _loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text('Pay ₹${plan?.amount ?? 0}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
