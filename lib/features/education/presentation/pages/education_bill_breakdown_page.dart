import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/education_api_exceptions.dart';
import '../providers/education_provider.dart';
import 'education_payment_success_page.dart';

class EducationBillBreakdownPage extends ConsumerStatefulWidget {
  const EducationBillBreakdownPage({super.key});

  @override
  ConsumerState<EducationBillBreakdownPage> createState() =>
      _EducationBillBreakdownPageState();
}

class _EducationBillBreakdownPageState extends ConsumerState<EducationBillBreakdownPage> {
  static const _paymentModes = ['UPI', 'CARD', 'NETBANKING', 'WALLET'];
  String _paymentMode = 'UPI';
  final _accountIdController = TextEditingController();
  bool _paying = false;

  @override
  void dispose() {
    _accountIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bill = ref.watch(fetchedEducationBillProvider);
    if (bill == null) return const Scaffold(body: Center(child: Text('No bill data')));

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Bill details'),
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
          const SizedBox(height: 12),
          TextField(
            controller: _accountIdController,
            decoration: const InputDecoration(
              labelText: 'Account ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _paying
                ? null
                : () async {
                    final biller = ref.read(selectedEducationBillerProvider);
                    if (biller == null) return;
                    final accountId = _accountIdController.text.trim();
                    if (accountId.isEmpty) return;
                    setState(() => _paying = true);
                    try {
                      await ref.read(educationRepositoryProvider).payBill(
                            billerId: biller.id,
                            bill: bill,
                            paymentMode: _paymentMode,
                            accountId: accountId,
                          );
                      ref.invalidate(educationHistoryProvider);
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const EducationPaymentSuccessPage(),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(educationApiUserMessage(e))),
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
