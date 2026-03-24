import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/fastag_api_exceptions.dart';
import '../providers/fastag_provider.dart';
import 'fastag_add_vehicle_page.dart';
import 'fastag_balance_page.dart';
import 'fastag_recharge_history_page.dart';

class FastagVehicleListPage extends ConsumerWidget {
  const FastagVehicleListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(fastagVehiclesProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('FASTag'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Recharge history',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const FastagRechargeHistoryPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(fastagVehiclesProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(
              builder: (_) => const FastagAddVehiclePage(),
            ),
          );
          if (added == true && context.mounted) {
            ref.invalidate(fastagVehiclesProvider);
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add vehicle'),
      ),
      body: async.when(
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.directions_car_outlined,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No vehicles yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add a vehicle to recharge your FASTag.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(fastagVehiclesProvider);
              await ref.read(fastagVehiclesProvider.future);
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              itemCount: vehicles.length,
              itemBuilder: (_, i) {
                final v = vehicles[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.directions_car_rounded),
                    title: Text(v.number),
                    subtitle: Text(
                      [
                        if (v.label != null && v.label!.isNotEmpty) v.label!,
                        if (v.tagId != '—') 'Tag: ${v.tagId}',
                        '₹${v.balance}',
                        if (v.status != null) v.status!,
                      ].join(' · '),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ref.read(selectedFastagVehicleProvider.notifier).state = v;
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const FastagBalancePage(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(fastagApiUserMessage(e))),
      ),
    );
  }
}
