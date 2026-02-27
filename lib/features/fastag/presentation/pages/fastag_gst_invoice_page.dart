import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/fastag_provider.dart';

/// GST invoice for toll payments. TODO: Fetch from NPCI/FASTag API.
class FastagGstInvoicePage extends ConsumerWidget {
  const FastagGstInvoicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(selectedFastagVehicleProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('GST invoice'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (v != null) Text('Vehicle: ${v.number}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          const Text('No invoices yet. TODO: List from API with download', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
