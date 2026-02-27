import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/rent_provider.dart';

/// Rent receipt generator. TODO: Generate PDF from API.
class RentReceiptPage extends ConsumerWidget {
  const RentReceiptPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(selectedRentPropertyProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Rent receipt'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (p != null) Text('Property: ${p.address}'),
          const SizedBox(height: 16),
          const Text('No receipts yet. TODO: List and generate PDF from API', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
