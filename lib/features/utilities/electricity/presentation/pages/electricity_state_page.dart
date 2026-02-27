import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/electricity_state.dart';
import '../providers/electricity_provider.dart';
import 'electricity_biller_page.dart';

class ElectricityStatePage extends ConsumerWidget {
  const ElectricityStatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(electricityStatesProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Electricity Bill'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: async.when(
        data: (states) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: states.length,
          itemBuilder: (_, i) {
            final s = states[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.bolt_rounded),
                title: Text(s.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ref.read(selectedElectricityStateProvider.notifier).state = s;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ElectricityBillerPage()));
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
