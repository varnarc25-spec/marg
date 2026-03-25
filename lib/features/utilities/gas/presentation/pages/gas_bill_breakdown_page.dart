import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../data/gas_api_exceptions.dart';
import '../../data/models/gas_saved_account.dart';
import '../providers/gas_provider.dart';
import 'gas_autopay_page.dart';
import 'gas_payment_success_page.dart';

/// Bill details + payment, then `POST /pay`.
class GasBillBreakdownPage extends ConsumerStatefulWidget {
  const GasBillBreakdownPage({super.key});

  @override
  ConsumerState<GasBillBreakdownPage> createState() => _GasBillBreakdownPageState();
}

class _GasBillBreakdownPageState extends ConsumerState<GasBillBreakdownPage> {
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
    final bill = ref.watch(fetchedGasBillProvider);

    if (bill == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bill details')),
        body: const Center(child: Text('No bill data')),
      );
    }

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
                  Text('Due: ${bill.dueDate.day}/${bill.dueDate.month}/${bill.dueDate.year}'),
                  if (bill.billPeriod.isNotEmpty) Text('Bill period: ${bill.billPeriod}'),
                  if (bill.breakdown.isNotEmpty)
                    Text(
                      bill.breakdown,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  if (bill.lateFee > 0 || bill.convenienceFee > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Late fee: ₹${bill.lateFee} · Convenience: ₹${bill.convenienceFee}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'Amount: ₹${bill.amount}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.autorenew_rounded),
            title: const Text('Enable AutoPay'),
            subtitle: const Text('Pay automatically before due date'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(builder: (_) => const GasAutopayPage()),
            ),
          ),
          const SizedBox(height: 16),
          Text('Payment', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
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
              hintText: 'Saved account / payment account id',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Consumer(
            builder: (context, ref, _) {
              final accountsAsync = ref.watch(gasSavedAccountsProvider);
              return accountsAsync.when(
                data: (accounts) {
                  if (accounts.isEmpty) return const SizedBox.shrink();
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () async {
                        final picked = await showModalBottomSheet<GasSavedAccount>(
                          context: context,
                          showDragHandle: true,
                          builder: (ctx) => SafeArea(
                            child: ListView(
                              shrinkWrap: true,
                              children: accounts
                                  .map(
                                    (a) => ListTile(
                                      title: Text(a.label ?? a.accountNumber),
                                      subtitle: Text(a.accountNumber),
                                      onTap: () => Navigator.pop(ctx, a),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                        if (picked != null && mounted) {
                          setState(() {
                            _accountIdController.text = picked.id;
                          });
                        }
                      },
                      child: const Text('Use saved account'),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _paying
                ? null
                : () async {
                    final biller = ref.read(selectedGasBillerProvider);
                    if (biller == null) return;
                    final accountId = _accountIdController.text.trim();
                    if (accountId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enter account ID for payment')),
                      );
                      return;
                    }
                    setState(() => _paying = true);
                    try {
                      await ref.read(gasRepositoryProvider).payBill(
                            billerId: biller.id,
                            bill: bill,
                            paymentMode: _paymentMode,
                            accountId: accountId,
                          );
                      ref.invalidate(gasHistoryProvider);
                      if (!context.mounted) return;
                      await Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const GasPaymentSuccessPage(),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(gasApiUserMessage(e))),
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
