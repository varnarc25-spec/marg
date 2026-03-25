import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../data/water_api_exceptions.dart';
import '../providers/water_provider.dart';

/// `GET /api/utilities/water/history`
class WaterHistoryPage extends ConsumerWidget {
  const WaterHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(waterHistoryProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Payment history'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(waterHistoryProvider),
          ),
        ],
      ),
      body: async.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No payments yet',
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
                  leading: const Icon(Icons.receipt_long_rounded),
                  title: Text('₹${e.amount.toStringAsFixed(2)}'),
                  subtitle: Text(
                    [
                      if (e.billerName != null) e.billerName!,
                      if (e.status != null) e.status!,
                      if (e.paidAt != null)
                        e.paidAt!.toLocal().toString().split('.').first,
                    ].join(' · '),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(waterApiUserMessage(e))),
      ),
    );
  }
}
