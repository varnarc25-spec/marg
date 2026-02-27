import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/government_bills_provider.dart';
import 'government_reminder_setup_page.dart';
import 'government_receipt_download_page.dart';
import 'government_payment_success_page.dart';

/// Penalty & interest breakdown, annual reminder, receipt download.
class GovernmentBillBreakdownPage extends ConsumerWidget {
  const GovernmentBillBreakdownPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bill = ref.watch(governmentBillDetailProvider);
    if (bill == null) return const Scaffold(body: Center(child: Text('No bill')));

    final amount = bill['amount'] as num? ?? 0;
    final penalty = bill['penalty'] as num? ?? 0;
    final interest = bill['interest'] as num? ?? 0;
    final total = amount + penalty + interest;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Bill breakdown'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Base'), Text('₹$amount')]),
                  if (penalty > 0) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Penalty'), Text('₹$penalty')]),
                  if (interest > 0) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Interest'), Text('₹$interest')]),
                  const Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)), Text('₹$total', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue))]),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_rounded),
            title: const Text('Annual reminder'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GovernmentReminderSetupPage())),
          ),
          ListTile(
            leading: const Icon(Icons.download_rounded),
            title: const Text('Receipt download'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GovernmentReceiptDownloadPage())),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GovernmentPaymentSuccessPage())),
            child: const Text('Pay now'),
          ),
        ],
      ),
    );
  }
}
