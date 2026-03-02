import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import 'dth_operator_selection_page.dart';

/// Expiry reminder UI: numbers with upcoming expiry (mock).
/// TODO: Integrate with backend for real expiry data.
class MobileExpiryReminderPage extends ConsumerWidget {
  const MobileExpiryReminderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock: numbers "expiring soon"
    const mockExpiry = [
      _ExpiryEntry(number: '98765*****', operator: 'Jio', expiryInDays: 2),
      _ExpiryEntry(number: '98765*****', operator: 'Airtel', expiryInDays: 5),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Expiry reminders'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Recharge before expiry to avoid service interruption.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ...mockExpiry.map(
            (e) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(
                  Icons.schedule_rounded,
                  color: AppColors.accentOrange,
                ),
                title: Text(e.number),
                subtitle: Text(
                  '${e.operator} • Expires in ${e.expiryInDays} days',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const DthOperatorSelectionPage(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiryEntry {
  final String number;
  final String operator;
  final int expiryInDays;
  const _ExpiryEntry({
    required this.number,
    required this.operator,
    required this.expiryInDays,
  });
}
