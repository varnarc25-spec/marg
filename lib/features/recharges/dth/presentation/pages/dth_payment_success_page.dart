import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../providers/dth_recharge_provider.dart';
import 'dth_operator_selection_page.dart';

class DthPaymentSuccessPage extends ConsumerWidget {
  const DthPaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(selectedDthPlanProvider);
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
              Text('DTH recharge successful', style: Theme.of(context).textTheme.headlineSmall),
              if (plan != null) Text('₹${plan.amount}', style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const DthOperatorSelectionPage()),
                    (r) => r.isFirst,
                  ),
                  child: const Text('Recharge again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
