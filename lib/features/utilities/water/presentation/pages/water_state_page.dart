import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../data/water_api_exceptions.dart';
import '../providers/water_provider.dart';
import 'water_fetch_bill_page.dart';
import 'water_history_page.dart';
import 'water_saved_accounts_page.dart';

class WaterStatePage extends ConsumerStatefulWidget {
  const WaterStatePage({super.key});

  @override
  ConsumerState<WaterStatePage> createState() => _WaterStatePageState();
}

class _WaterStatePageState extends ConsumerState<WaterStatePage> {
  final _consumerController = TextEditingController();

  @override
  void dispose() {
    _consumerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(waterAllBillersProvider);
    final selectedBiller = ref.watch(selectedWaterBillerProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Water Bill'),
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
                  builder: (_) => const WaterHistoryPage(),
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
                  builder: (_) => const WaterSavedAccountsPage(),
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
                ref.read(selectedWaterBillerProvider.notifier).state = selected;
              }
            });
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Pay water bill',
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
                        ref.read(selectedWaterBillerProvider.notifier).state = match;
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
                        final biller = ref.read(selectedWaterBillerProvider);
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
                        ref.read(waterConsumerNumberProvider.notifier).state = consumer;
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(builder: (_) => const WaterFetchBillPage()),
                        );
                      },
                icon: const Icon(Icons.receipt_long_rounded),
                label: const Text('Fetch bill'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(waterApiUserMessage(e))),
      ),
    );
  }
}
