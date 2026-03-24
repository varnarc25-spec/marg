import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/loan_repayment_api_exceptions.dart';
import '../providers/loan_repayment_provider.dart';
import 'loan_repayment_accounts_page.dart';
import 'loan_repayment_fetch_bill_page.dart';
import 'loan_repayment_history_page.dart';

class LoanRepaymentHomePage extends ConsumerStatefulWidget {
  const LoanRepaymentHomePage({super.key});

  @override
  ConsumerState<LoanRepaymentHomePage> createState() => _LoanRepaymentHomePageState();
}

class _LoanRepaymentHomePageState extends ConsumerState<LoanRepaymentHomePage> {
  final _consumerController = TextEditingController();

  @override
  void dispose() {
    _consumerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final billersAsync = ref.watch(loanRepaymentBillersProvider);
    final selectedBiller = ref.watch(selectedLoanRepaymentBillerProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Loan Repayment'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Payment history',
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(builder: (_) => const LoanRepaymentHistoryPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_rounded),
            tooltip: 'Saved accounts',
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(builder: (_) => const LoanRepaymentAccountsPage()),
              );
            },
          ),
        ],
      ),
      body: billersAsync.when(
        data: (billers) {
          final selected = selectedBiller ??
              (billers.isNotEmpty
                  ? billers.first
                  : null);
          if (selected != null && selectedBiller == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ref.read(selectedLoanRepaymentBillerProvider.notifier).state = selected;
              }
            });
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Pay loan EMI',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your lender, enter consumer number, and fetch outstanding bill.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: selected?.id,
                decoration: const InputDecoration(
                  labelText: 'Lender / Biller',
                  border: OutlineInputBorder(),
                ),
                items: billers
                    .map(
                      (b) => DropdownMenuItem<String>(
                        value: b.id,
                        child: Text(b.name),
                      ),
                    )
                    .toList(),
                onChanged: billers.isEmpty
                    ? null
                    : (id) {
                        if (id == null) return;
                        final match = billers.firstWhere((e) => e.id == id);
                        ref.read(selectedLoanRepaymentBillerProvider.notifier).state = match;
                      },
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _consumerController,
                decoration: const InputDecoration(
                  labelText: 'Consumer Number / Loan Account Number',
                  hintText: 'Enter account number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: billers.isEmpty
                    ? null
                    : () {
                        final consumer = _consumerController.text.trim();
                        final biller = ref.read(selectedLoanRepaymentBillerProvider);
                        if (biller == null) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(const SnackBar(content: Text('Select biller first')));
                          return;
                        }
                        if (consumer.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enter consumer number')),
                          );
                          return;
                        }
                        ref.read(loanRepaymentConsumerNumberProvider.notifier).state = consumer;
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const LoanRepaymentFetchBillPage(),
                          ),
                        );
                      },
                icon: const Icon(Icons.receipt_long_rounded),
                label: const Text('Fetch bill'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(loanRepaymentApiUserMessage(e))),
      ),
    );
  }
}
