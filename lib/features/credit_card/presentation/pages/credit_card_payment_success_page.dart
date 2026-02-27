import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/credit_card_provider.dart';

class CreditCardPaymentSuccessPage extends ConsumerWidget {
  const CreditCardPaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(selectedCreditCardProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 80),
              const SizedBox(height: 24),
              Text('Payment successful', style: Theme.of(context).textTheme.headlineSmall),
              if (card != null) Text('₹${card.totalDue} paid', style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
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
