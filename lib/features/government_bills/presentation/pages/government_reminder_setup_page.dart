import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class GovernmentReminderSetupPage extends ConsumerWidget {
  const GovernmentReminderSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Annual reminder'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Remind before due date'),
            subtitle: const Text('30 days before'),
            value: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 16),
          const Text('TODO: Save reminder via API', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
