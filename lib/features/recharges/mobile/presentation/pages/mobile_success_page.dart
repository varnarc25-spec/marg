import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../providers/mobile_recharge_provider.dart';
import 'mobile_operator_selection_page.dart';
import 'mobile_recent_history_page.dart';

/// Success screen after mobile recharge.
class MobileSuccessPage extends ConsumerWidget {
  const MobileSuccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(selectedMobilePlanProvider);
    final number = ref.watch(mobileRechargeNumberProvider);

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
                'Recharge successful',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              if (plan != null)
                Text(
                  '₹${plan.amount} recharged for $number',
                  style: const TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MobileOperatorSelectionPage()),
                      (route) => route.isFirst,
                    );
                  },
                  child: const Text('Recharge again'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MobileRecentHistoryPage()),
                    );
                  },
                  child: const Text('View history'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
