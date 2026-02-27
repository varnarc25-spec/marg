import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/government_bills_provider.dart';
import 'government_tax_type_page.dart';

class GovernmentPropertySelectionPage extends ConsumerWidget {
  const GovernmentPropertySelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(governmentBillsPropertiesProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Government & Tax'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: async.when(
        data: (list) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final p = list[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.account_balance_rounded),
                title: Text(p.name),
                subtitle: Text(p.type),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ref.read(selectedGovernmentPropertyProvider.notifier).state = p;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const GovernmentTaxTypePage()));
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
