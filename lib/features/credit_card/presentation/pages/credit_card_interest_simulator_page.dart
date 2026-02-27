import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/credit_card_provider.dart';

/// Interest cost simulator: min vs full payment. TODO: Use real APR from API.
class CreditCardInterestSimulatorPage extends ConsumerWidget {
  const CreditCardInterestSimulatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(selectedCreditCardProvider);
    if (card == null) return const Scaffold(body: Center(child: Text('No card')));

    // Mock: ~3% monthly on outstanding
    final outstanding = card.totalDue - card.minimumDue;
    final interestPerMonth = outstanding * 0.03;
    final monthsToRepay = outstanding > 0 ? (outstanding / (card.minimumDue * 0.5)).ceil() : 0;
    final totalInterest = interestPerMonth * monthsToRepay;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Interest simulator'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('If you pay only minimum due:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Outstanding: ₹${outstanding.toStringAsFixed(0)}'),
                  Text('Est. interest (≈3% pm): ₹${totalInterest.toStringAsFixed(0)} over ~$monthsToRepay months'),
                  const SizedBox(height: 8),
                  const Text('Paying full amount avoids interest.', style: TextStyle(color: AppColors.accentGreen, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('TODO: Slider for custom payment amount and tenure', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
