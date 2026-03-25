import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/fastag_api_exceptions.dart';
import '../providers/fastag_provider.dart';
import 'fastag_recharge_status_page.dart';

class FastagRechargePage extends ConsumerStatefulWidget {
  const FastagRechargePage({super.key});

  @override
  ConsumerState<FastagRechargePage> createState() => _FastagRechargePageState();
}

class _FastagRechargePageState extends ConsumerState<FastagRechargePage> {
  final _amountController = TextEditingController();
  static const _presets = [100, 250, 500, 1000, 2000];
  bool _submitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = ref.watch(selectedFastagVehicleProvider);
    if (v == null) {
      return const Scaffold(body: Center(child: Text('Select vehicle')));
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Recharge FASTag'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Vehicle: ${v.number}', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 16),
          const Text('Quick amount'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _presets
                .map(
                  (a) => ActionChip(
                    label: Text('₹$a'),
                    onPressed: () => _amountController.text = '$a',
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submitting
                ? null
                : () async {
                    final amt = num.tryParse(_amountController.text);
                    if (amt == null || amt <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enter a valid amount')),
                      );
                      return;
                    }
                    setState(() => _submitting = true);
                    try {
                      final result = await ref
                          .read(fastagRepositoryProvider)
                          .initiateRecharge(
                            vehicleId: v.id,
                            amount: amt,
                          );
                      ref.invalidate(fastagVehiclesProvider);
                      final txnId = fastagTransactionIdFromResponse(result);
                      if (!context.mounted) return;
                      if (txnId != null && txnId.isNotEmpty) {
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                FastagRechargeStatusPage(transactionId: txnId),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Started. Response: $result',
                            ),
                          ),
                        );
                        if (context.mounted) Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(fastagApiUserMessage(e))),
                      );
                    } finally {
                      if (mounted) setState(() => _submitting = false);
                    }
                  },
            child: _submitting
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Recharge'),
          ),
        ],
      ),
    );
  }
}
