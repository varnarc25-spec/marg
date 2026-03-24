import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/education_api_exceptions.dart';
import '../providers/education_provider.dart';
import 'education_fetch_bill_page.dart';
import 'education_history_page.dart';
import 'education_saved_accounts_page.dart';

class EducationStatePage extends ConsumerStatefulWidget {
  const EducationStatePage({super.key});

  @override
  ConsumerState<EducationStatePage> createState() => _EducationStatePageState();
}

class _EducationStatePageState extends ConsumerState<EducationStatePage> {
  final _consumerController = TextEditingController();

  @override
  void dispose() {
    _consumerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(educationAllBillersProvider);
    final selectedBiller = ref.watch(selectedEducationBillerProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Education Fee'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const EducationHistoryPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const EducationSavedAccountsPage(),
              ),
            ),
          ),
        ],
      ),
      body: async.when(
        data: (billers) {
          final selected = selectedBiller ?? (billers.isNotEmpty ? billers.first : null);
          if (selected != null && selectedBiller == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ref.read(selectedEducationBillerProvider.notifier).state = selected;
              }
            });
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Pay education fee',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Select institution and enter consumer number to fetch bill.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: selected?.id,
                decoration: const InputDecoration(
                  labelText: 'Select institution/biller',
                  border: OutlineInputBorder(),
                ),
                items: billers.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))).toList(),
                onChanged: billers.isEmpty
                    ? null
                    : (id) {
                        if (id == null) return;
                        final match = billers.firstWhere((e) => e.id == id);
                        ref.read(selectedEducationBillerProvider.notifier).state = match;
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
                        final biller = ref.read(selectedEducationBillerProvider);
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
                        ref.read(educationConsumerNumberProvider.notifier).state = consumer;
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(builder: (_) => const EducationFetchBillPage()),
                        );
                      },
                icon: const Icon(Icons.receipt_long_rounded),
                label: const Text('Fetch bill'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(educationApiUserMessage(e))),
      ),
    );
  }
}
