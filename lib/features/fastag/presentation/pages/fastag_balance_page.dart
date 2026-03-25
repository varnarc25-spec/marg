import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/fastag_provider.dart';
import 'fastag_recharge_page.dart';
import 'fastag_recharge_history_page.dart';
import 'fastag_toll_history_page.dart';
import 'fastag_autorecharge_rules_page.dart';
import 'fastag_gst_invoice_page.dart';

class FastagBalancePage extends ConsumerWidget {
  const FastagBalancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(selectedFastagVehicleProvider);
    if (v == null) {
      return const Scaffold(body: Center(child: Text('Select vehicle')));
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(v.number),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'FASTag balance',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${v.balance}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.add_circle_rounded),
            title: const Text('Recharge'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const FastagRechargePage(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_rounded),
            title: const Text('All recharge history'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const FastagRechargeHistoryPage(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history_rounded),
            title: const Text('Toll history'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const FastagTollHistoryPage(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.autorenew_rounded),
            title: const Text('Auto-recharge rules'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const FastagAutorechargeRulesPage(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_rounded),
            title: const Text('GST invoice'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const FastagGstInvoicePage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
