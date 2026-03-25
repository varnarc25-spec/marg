import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/fastag_api_exceptions.dart';
import '../providers/fastag_provider.dart';

/// `GET /api/recharges/fastag/recharge/history`
class FastagRechargeHistoryPage extends ConsumerWidget {
  const FastagRechargeHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(fastagRechargeHistoryProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Recharge history'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(fastagRechargeHistoryProvider),
          ),
        ],
      ),
      body: async.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No recharge history yet',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final e = items[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.account_balance_wallet_rounded),
                  title: Text('₹${e.amount.toStringAsFixed(0)}'),
                  subtitle: Text(
                    [
                      if (e.vehicleLabel != null) e.vehicleLabel!,
                      if (e.status != null) e.status!,
                      if (e.createdAt != null)
                        e.createdAt!.toLocal().toString().split('.').first,
                    ].join(' · '),
                  ),
                  trailing: e.id.length > 6
                      ? Text(
                          e.id.substring(0, 6),
                          style: const TextStyle(fontSize: 12),
                        )
                      : null,
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
