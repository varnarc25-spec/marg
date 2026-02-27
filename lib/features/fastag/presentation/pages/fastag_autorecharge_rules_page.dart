import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

/// Auto-recharge rules. TODO: Mandate/API to set low-balance auto top-up.
class FastagAutorechargeRulesPage extends ConsumerWidget {
  const FastagAutorechargeRulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Auto-recharge'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Auto-recharge when balance low'),
            subtitle: const Text('Top up ₹500 when balance < ₹100'),
            value: false,
            onChanged: (_) {},
          ),
          const SizedBox(height: 16),
          const Text('TODO: Configure threshold and amount via API', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
