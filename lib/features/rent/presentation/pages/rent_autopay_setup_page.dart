import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

/// AutoPay setup for rent. TODO: Mandate registration.
class RentAutopaySetupPage extends ConsumerWidget {
  const RentAutopaySetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('AutoPay setup'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Rent will be debited automatically on the 1st of every month.'),
          const SizedBox(height: 16),
          SwitchListTile(title: const Text('Enable AutoPay'), value: false, onChanged: (_) {}),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TODO: AutoPay mandate'))),
            child: const Text('Set up AutoPay'),
          ),
        ],
      ),
    );
  }
}
