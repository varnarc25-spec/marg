import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';

/// Enable AutoPay. TODO: mandate integration when backend supports it.
class BroadbandAutopayPage extends ConsumerWidget {
  const BroadbandAutopayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Enable AutoPay'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'AutoPay will debit your bill amount automatically before the due date.',
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Enable AutoPay'),
            value: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('TODO: Mandate registration with payment gateway'),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Set up AutoPay'),
          ),
        ],
      ),
    );
  }
}
