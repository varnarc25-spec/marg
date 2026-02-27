import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../providers/electricity_provider.dart';
import 'electricity_bill_breakdown_page.dart';

class ElectricityFetchBillPage extends ConsumerStatefulWidget {
  const ElectricityFetchBillPage({super.key});

  @override
  ConsumerState<ElectricityFetchBillPage> createState() => _ElectricityFetchBillPageState();
}

class _ElectricityFetchBillPageState extends ConsumerState<ElectricityFetchBillPage> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchBill());
  }

  Future<void> _fetchBill() async {
    final biller = ref.read(selectedElectricityBillerProvider);
    final consumerId = ref.read(electricityConsumerIdProvider);
    if (biller == null) {
      setState(() {
        _loading = false;
        _error = 'Select biller first';
      });
      return;
    }
    final bill = await ref.read(electricityRepositoryProvider).fetchBill(biller.id, consumerId);
    if (!mounted) return;
    setState(() => _loading = false);
    if (bill != null) {
      ref.read(fetchedElectricityBillProvider.notifier).state = bill;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ElectricityBillBreakdownPage()));
    } else {
      setState(() => _error = 'Could not fetch bill');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Fetch bill'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : const Center(child: Text('Fetching...')),
    );
  }
}
