import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/loan_repayment_api_exceptions.dart';
import '../providers/loan_repayment_provider.dart';

class LoanRepaymentHistoryPage extends ConsumerWidget {
  const LoanRepaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(loanRepaymentHistoryProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Loan Repayment History'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: async.when(
        data: (items) {
          if (items.isEmpty) return const Center(child: Text('No payments yet'));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.receipt_long_rounded),
                  title: Text('Rs ${item.amount.toStringAsFixed(2)}'),
                  subtitle: Text([
                    if (item.billerName != null) item.billerName!,
                    if (item.status != null) item.status!,
                  ].join('  •  ')),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(loanRepaymentApiUserMessage(e))),
      ),
    );
  }
}
