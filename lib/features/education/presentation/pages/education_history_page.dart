import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/education_api_exceptions.dart';
import '../providers/education_provider.dart';

class EducationHistoryPage extends ConsumerWidget {
  const EducationHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(educationHistoryProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Payment history'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: async.when(
        data: (items) {
          if (items.isEmpty) return const Center(child: Text('No payments yet'));
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
                    ].join(' · '),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(educationApiUserMessage(e))),
      ),
    );
  }
}
