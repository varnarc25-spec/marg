import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/electricity_api_exceptions.dart';
import '../providers/electricity_provider.dart';
import 'electricity_consumer_id_page.dart';

class ElectricityBillerPage extends ConsumerWidget {
  const ElectricityBillerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectedElectricityStateProvider);
    final billersAsync = state != null ? ref.watch(electricityBillersProvider(state.id)) : null;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Select discom'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: billersAsync == null
          ? const Center(child: Text('Select state first'))
          : billersAsync.when(
              data: (billers) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: billers.length,
                itemBuilder: (_, i) {
                  final b = billers[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.business_rounded),
                      title: Text(b.name),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ref.read(selectedElectricityBillerProvider.notifier).state = b;
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ElectricityConsumerIdPage()));
                      },
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(electricityApiUserMessage(e))),
            ),
    );
  }
}
