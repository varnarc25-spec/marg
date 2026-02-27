import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/rent_provider.dart';
import 'rent_autopay_setup_page.dart';
import 'rent_receipt_page.dart';
import 'rent_tax_report_page.dart';
import 'rent_payment_success_page.dart';

class RentPropertyDetailPage extends ConsumerWidget {
  const RentPropertyDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(selectedRentPropertyProvider);
    if (p == null) return const Scaffold(body: Center(child: Text('No property')));

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Property'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.address, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Owner: ${p.ownerName}'),
                  Text('Monthly rent: ₹${p.monthlyRent}'),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.autorenew_rounded),
            title: const Text('AutoPay setup'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RentAutopaySetupPage())),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_rounded),
            title: const Text('Rent receipt'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RentReceiptPage())),
          ),
          ListTile(
            leading: const Icon(Icons.description_rounded),
            title: const Text('Tax-ready report'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RentTaxReportPage())),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final ok = await ref.read(rentRepositoryProvider).payRent(p.id, p.monthlyRent);
              if (context.mounted && ok) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RentPaymentSuccessPage()));
              }
            },
            child: const Text('Pay rent'),
          ),
        ],
      ),
    );
  }
}
