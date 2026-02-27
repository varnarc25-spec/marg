import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/government_bills_provider.dart';
import 'government_bill_breakdown_page.dart';

class GovernmentTaxTypePage extends ConsumerStatefulWidget {
  const GovernmentTaxTypePage({super.key});

  @override
  ConsumerState<GovernmentTaxTypePage> createState() => _GovernmentTaxTypePageState();
}

class _GovernmentTaxTypePageState extends ConsumerState<GovernmentTaxTypePage> {
  List<Map<String, String>> _taxTypes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final p = ref.read(selectedGovernmentPropertyProvider);
    if (p != null) {
      ref.read(governmentBillsRepositoryProvider).getTaxTypes(p.id).then((list) {
        if (mounted) setState(() {
          _taxTypes = list;
          _loading = false;
        });
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Tax type'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _taxTypes.length,
              itemBuilder: (_, i) {
                final t = _taxTypes[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(t['name'] ?? ''),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final p = ref.read(selectedGovernmentPropertyProvider);
                      if (p == null) return;
                      final bill = await ref.read(governmentBillsRepositoryProvider).fetchBill(p.id, t['id'] ?? '');
                      if (mounted && bill != null) {
                        ref.read(governmentBillDetailProvider.notifier).state = bill;
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const GovernmentBillBreakdownPage()));
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
