import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/data_card_operator.dart';
import '../providers/data_card_provider.dart';
import 'data_card_plan_page.dart';

class DataCardOperatorPage extends ConsumerWidget {
  const DataCardOperatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dataCardOperatorsProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Data Card Recharge'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: async.when(
        data: (list) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final op = list[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.sim_card_rounded),
                title: Text(op.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ref.read(selectedDataCardOperatorProvider.notifier).state = op;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DataCardPlanPage()));
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
