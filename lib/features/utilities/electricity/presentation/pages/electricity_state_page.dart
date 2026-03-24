import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/electricity_api_exceptions.dart';
import '../providers/electricity_provider.dart';
import 'electricity_fetch_bill_page.dart';
import 'electricity_history_page.dart';
import 'electricity_saved_accounts_page.dart';

class ElectricityStatePage extends ConsumerStatefulWidget {
  const ElectricityStatePage({super.key});

  @override
  ConsumerState<ElectricityStatePage> createState() => _ElectricityStatePageState();
}

class _ElectricityStatePageState extends ConsumerState<ElectricityStatePage> {
  final _consumerController = TextEditingController();

  @override
  void dispose() {
    _consumerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(electricityAllBillersProvider);
    final selectedBiller = ref.watch(selectedElectricityBillerProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Electricity Bill'),
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
                  builder: (_) => const ElectricityHistoryPage(),
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
                  builder: (_) => const ElectricitySavedAccountsPage(),
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
                ref.read(selectedElectricityBillerProvider.notifier).state = selected;
              }
            });
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Pay electricity bill',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Select discom and enter consumer number to fetch bill.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: selected?.id,
                decoration: const InputDecoration(
                  labelText: 'Select discom',
                  border: OutlineInputBorder(),
                ),
                items: billers
                    .map((b) => DropdownMenuItem<String>(value: b.id, child: Text(b.name)))
                    .toList(),
                onChanged: billers.isEmpty
                    ? null
                    : (id) {
                        if (id == null) return;
                        final match = billers.firstWhere((e) => e.id == id);
                        ref.read(selectedElectricityBillerProvider.notifier).state = match;
                      },
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _consumerController,
                keyboardType: TextInputType.text,
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
                        final biller = ref.read(selectedElectricityBillerProvider);
                        if (biller == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Select discom first')),
                          );
                          return;
                        }
                        if (consumer.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enter consumer number')),
                          );
                          return;
                        }
                        ref.read(electricityConsumerNumberProvider.notifier).state = consumer;
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(builder: (_) => const ElectricityFetchBillPage()),
                        );
                      },
                icon: const Icon(Icons.receipt_long_rounded),
                label: const Text('Fetch bill'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(electricityApiUserMessage(e))),
      ),
    );
  }
}
