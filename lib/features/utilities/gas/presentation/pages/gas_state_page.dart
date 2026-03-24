import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../data/gas_api_exceptions.dart';
import '../providers/gas_provider.dart';
import 'gas_fetch_bill_page.dart';
import 'gas_history_page.dart';
import 'gas_saved_accounts_page.dart';

class GasStatePage extends ConsumerStatefulWidget {
  const GasStatePage({super.key});

  @override
  ConsumerState<GasStatePage> createState() => _GasStatePageState();
}

class _GasStatePageState extends ConsumerState<GasStatePage> {
  final _consumerController = TextEditingController();

  @override
  void dispose() {
    _consumerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(gasAllBillersProvider);
    final selectedBiller = ref.watch(selectedGasBillerProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Piped Gas Bill'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Payment history',
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const GasHistoryPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_rounded),
            tooltip: 'Saved accounts',
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const GasSavedAccountsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: async.when(
        data: (billers) {
          final selected = selectedBiller ?? (billers.isNotEmpty ? billers.first : null);
          if (selected != null && selectedBiller == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ref.read(selectedGasBillerProvider.notifier).state = selected;
              }
            });
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Pay piped gas bill',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Select biller and enter consumer number to fetch bill.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: selected?.id,
                decoration: const InputDecoration(
                  labelText: 'Select biller',
                  border: OutlineInputBorder(),
                ),
                items: billers.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))).toList(),
                onChanged: billers.isEmpty
                    ? null
                    : (id) {
                        if (id == null) return;
                        final match = billers.firstWhere((e) => e.id == id);
                        ref.read(selectedGasBillerProvider.notifier).state = match;
                      },
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _consumerController,
                decoration: const InputDecoration(
                  labelText: 'Consumer number',
                  hintText: 'Enter consumer number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: billers.isEmpty
                    ? null
                    : () {
                        final consumer = _consumerController.text.trim();
                        final biller = ref.read(selectedGasBillerProvider);
                        if (biller == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Select biller first')),
                          );
                          return;
                        }
                        if (consumer.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enter consumer number')),
                          );
                          return;
                        }
                        ref.read(gasConsumerNumberProvider.notifier).state = consumer;
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(builder: (_) => const GasFetchBillPage()),
                        );
                      },
                icon: const Icon(Icons.receipt_long_rounded),
                label: const Text('Fetch bill'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(gasApiUserMessage(e))),
      ),
    );
  }
}
