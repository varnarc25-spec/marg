import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/fastag_api_exceptions.dart';
import '../providers/fastag_provider.dart';

class FastagTollHistoryPage extends ConsumerWidget {
  const FastagTollHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(selectedFastagVehicleProvider);
    if (v == null) {
      return const Scaffold(
        body: Center(child: Text('Select vehicle')),
      );
    }

    final async = ref.watch(fastagTollHistoryProvider(v.id));
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Toll history'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                ref.invalidate(fastagTollHistoryProvider(v.id)),
          ),
        ],
      ),
      body: async.when(
        data: (trips) {
          if (trips.isEmpty) {
            return const Center(
              child: Text(
                'No toll transactions yet',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            itemBuilder: (_, i) {
              final t = trips[i];
              final dateStr = t.at != null
                  ? t.at!.toLocal().toString().split('.').first
                  : '';
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.toll_rounded),
                  title: Text(t.tollName),
                  subtitle: Text(dateStr),
                  trailing: Text('₹${t.amount.toStringAsFixed(0)}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(fastagApiUserMessage(e))),
      ),
    );
  }
}
