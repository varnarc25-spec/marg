import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../providers/electricity_provider.dart';
import 'electricity_autopay_page.dart';
import 'electricity_payment_success_page.dart';

/// Bill breakdown, Enable AutoPay, pay. TODO: AutoPay mandate API.
class ElectricityBillBreakdownPage extends ConsumerWidget {
  const ElectricityBillBreakdownPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bill = ref.watch(fetchedElectricityBillProvider);

    if (bill == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bill details')),
        body: const Center(child: Text('No bill data')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Bill details'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bill.name, style: Theme.of(context).textTheme.titleMedium),
                  Text('Consumer ID: ${bill.consumerId}'),
                  const SizedBox(height: 8),
                  Text('Due: ${bill.dueDate.day}/${bill.dueDate.month}/${bill.dueDate.year}'),
                  if (bill.breakdown.isNotEmpty) Text(bill.breakdown, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text('Amount: ₹${bill.amount}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.autorenew_rounded),
            title: const Text('Enable AutoPay'),
            subtitle: const Text('Pay automatically before due date'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ElectricityAutopayPage())),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              final repo = ref.read(electricityRepositoryProvider);
              final biller = ref.read(selectedElectricityBillerProvider);
              if (biller == null) return;
              final ok = await repo.payBill(billerId: biller.id, consumerId: bill.consumerId, amount: bill.amount);
              if (context.mounted && ok) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ElectricityPaymentSuccessPage()));
              }
            },
            child: const Text('Pay now'),
          ),
        ],
      ),
    );
  }
}
