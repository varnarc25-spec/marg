import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/card_repay_api_exceptions.dart';
import '../providers/card_repay_provider.dart';
import 'card_repay_payment_success_page.dart';

class CardRepayBillBreakdownPage extends ConsumerStatefulWidget {
  const CardRepayBillBreakdownPage({super.key});

  @override
  ConsumerState<CardRepayBillBreakdownPage> createState() => _CardRepayBillBreakdownPageState();
}

class _CardRepayBillBreakdownPageState extends ConsumerState<CardRepayBillBreakdownPage> {
  static const _paymentModes = ['UPI', 'CARD', 'NETBANKING', 'WALLET'];
  String _paymentMode = 'UPI';
  bool _paying = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bill = ref.watch(fetchedCardRepayBillProvider);
    if (bill == null) {
      return const Scaffold(body: Center(child: Text('No bill data')));
    }
    final accountId = ref.watch(selectedCardRepaySavedAccountIdProvider);
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
                  Text('Consumer number: ${bill.consumerNumber}'),
                  const SizedBox(height: 8),
                  Text('Amount: ₹${bill.amount}'),
                  Text('Due: ${bill.dueDate.toIso8601String().split('T').first}'),
                  if (accountId != null && accountId.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text('Card ending •••• $accountId'),
                  ],
                ],
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
                    final biller = ref.read(selectedCardRepayBillerProvider);
                    if (biller == null) return;
                    final selectedId = ref.read(selectedCardRepaySavedAccountIdProvider);
                    if (selectedId == null || selectedId.trim().isEmpty) return;
                    setState(() => _paying = true);
                    try {
                      await ref.read(cardRepayRepositoryProvider).payBill(
                            billerId: biller.id,
                            bill: bill,
                            paymentMode: _paymentMode,
                            accountId: selectedId.trim(),
                          );
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const CardRepayPaymentSuccessPage(),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(cardRepayApiUserMessage(e))),
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
