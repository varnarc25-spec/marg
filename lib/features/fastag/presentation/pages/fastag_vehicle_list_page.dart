import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/fastag_provider.dart';
import 'fastag_balance_page.dart';

class FastagVehicleListPage extends ConsumerWidget {
  const FastagVehicleListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(fastagVehiclesProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('FASTag'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: async.when(
        data: (vehicles) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vehicles.length,
          itemBuilder: (_, i) {
            final v = vehicles[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.directions_car_rounded),
                title: Text(v.number),
                subtitle: Text('Balance: ₹${v.balance}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ref.read(selectedFastagVehicleProvider.notifier).state = v;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FastagBalancePage()));
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
