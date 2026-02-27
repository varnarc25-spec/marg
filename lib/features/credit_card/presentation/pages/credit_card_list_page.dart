import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/credit_card_provider.dart';
import 'credit_card_bill_summary_page.dart';
import 'credit_card_add_page.dart';

class CreditCardListPage extends ConsumerWidget {
  const CreditCardListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(creditCardsProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Credit Card Bill'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreditCardAddPage())),
          ),
        ],
      ),
      body: async.when(
        data: (cards) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cards.length,
          itemBuilder: (_, i) {
            final c = cards[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.credit_card_rounded),
                title: Text('**** ${c.lastFour}'),
                subtitle: Text('${c.bankName} • Due ${c.dueDate.day}/${c.dueDate.month}'),
                trailing: Text('₹${c.totalDue}', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryBlue)),
                onTap: () {
                  ref.read(selectedCreditCardProvider.notifier).state = c;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CreditCardBillSummaryPage()));
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
