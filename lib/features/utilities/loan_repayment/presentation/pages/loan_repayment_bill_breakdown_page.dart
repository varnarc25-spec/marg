import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/loan_repayment_api_exceptions.dart';
import '../providers/loan_repayment_provider.dart';
import 'loan_repayment_accounts_page.dart';
import 'loan_repayment_payment_success_page.dart';

class LoanRepaymentBillBreakdownPage extends ConsumerStatefulWidget {
  const LoanRepaymentBillBreakdownPage({super.key});

  @override
  ConsumerState<LoanRepaymentBillBreakdownPage> createState() => _LoanRepaymentBillBreakdownPageState();
}

class _LoanRepaymentBillBreakdownPageState extends ConsumerState<LoanRepaymentBillBreakdownPage> {
  static const _paymentModes = ['UPI', 'CARD', 'NETBANKING', 'WALLET'];
  String _paymentMode = 'UPI';
  bool _paying = false;

  @override
  Widget build(BuildContext context) {
    final bill = ref.watch(fetchedLoanRepaymentBillProvider);
    final selectedAccountId = ref.watch(selectedLoanRepaymentSavedAccountIdProvider);

    if (bill == null) {
      return const Scaffold(body: Center(child: Text('No bill data')));
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Bill Details'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bill.consumerName, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('Account: ${bill.consumerNumber}'),
                  const SizedBox(height: 8),
                  Text(
                    'Amount due: Rs ${bill.amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text('Due date: ${bill.dueDate.toIso8601String().split('T').first}'),
                  if (bill.lateFee > 0) Text('Late fee: Rs ${bill.lateFee.toStringAsFixed(2)}'),
                  if (bill.convenienceFee > 0)
                    Text('Convenience fee: Rs ${bill.convenienceFee.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet_rounded),
              title: const Text('Saved account'),
              subtitle: Text(
                selectedAccountId == null || selectedAccountId.isEmpty
                    ? 'Select account to continue'
                    : 'Selected account id: $selectedAccountId',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.push<void>(
                context,
                MaterialPageRoute<void>(builder: (_) => const LoanRepaymentAccountsPage()),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _paymentMode,
            decoration: const InputDecoration(
              labelText: 'Payment mode',
              border: OutlineInputBorder(),
            ),
            items: _paymentModes.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
            onChanged: (v) {
              if (v != null) setState(() => _paymentMode = v);
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _paying
                ? null
                : () async {
                    final biller = ref.read(selectedLoanRepaymentBillerProvider);
                    final accountId = ref.read(selectedLoanRepaymentSavedAccountIdProvider);
                    if (biller == null) return;
                    if (accountId == null || accountId.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Select saved account first')),
                      );
                      return;
                    }
                    setState(() => _paying = true);
                    try {
                      final payRes = await ref.read(loanRepaymentRepositoryProvider).payBill(
                            billerId: biller.id,
                            bill: bill,
                            paymentMode: _paymentMode,
                            accountId: accountId.trim(),
                          );
                      final transactionId = (payRes['id'] ??
                              payRes['transactionId'] ??
                              payRes['paymentId'] ??
                              '')
                          .toString();
                      ref.read(lastLoanRepaymentTransactionIdProvider.notifier).state =
                          transactionId.isEmpty ? null : transactionId;
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const LoanRepaymentPaymentSuccessPage(),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loanRepaymentApiUserMessage(e))),
                      );
                    } finally {
                      if (mounted) setState(() => _paying = false);
                    }
                  },
            child: _paying
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Pay now'),
          ),
        ],
      ),
    );
  }
}
