import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/dth_operator.dart';
import '../providers/dth_recharge_provider.dart';
import 'dth_number_input_page.dart';

class DthOperatorSelectionPage extends ConsumerWidget {
  const DthOperatorSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dthOperatorsProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('DTH Recharge'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: async.when(
        data: (list) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final op = list[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.tv_rounded),
                title: Text(op.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ref.read(selectedDthOperatorProvider.notifier).state = op;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DthNumberInputPage()));
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
