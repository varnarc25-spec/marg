import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/credit_card_provider.dart';
import 'credit_card_interest_simulator_page.dart';
import 'credit_card_payment_success_page.dart';

/// Bill summary, min vs total due, interest simulator, schedule payment.
class CreditCardBillSummaryPage extends ConsumerWidget {
  const CreditCardBillSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(selectedCreditCardProvider);
    if (card == null) {
      return Scaffold(appBar: AppBar(title: const Text('Bill')), body: const Center(child: Text('Select a card')));
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Bill summary'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('**** ${card.lastFour} • ${card.bankName}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total due'),
                      Text('₹${card.totalDue}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Minimum due'),
                      Text('₹${card.minimumDue}', style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Due date'),
                      Text('${card.dueDate.day}/${card.dueDate.month}/${card.dueDate.year}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.calculate_rounded),
            title: const Text('Interest cost simulator'),
            subtitle: const Text('See cost of paying only minimum'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreditCardInterestSimulatorPage())),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              final repo = ref.read(creditCardRepositoryProvider);
              final ok = await repo.payBill(cardId: card.id, amount: card.totalDue);
              if (context.mounted && ok) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CreditCardPaymentSuccessPage()));
              }
            },
            child: const Text('Pay total due'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async {
              final repo = ref.read(creditCardRepositoryProvider);
              final ok = await repo.payBill(cardId: card.id, amount: card.minimumDue);
              if (context.mounted && ok) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CreditCardPaymentSuccessPage()));
              }
            },
            child: const Text('Pay minimum due'),
          ),
        ],
      ),
    );
  }
}
