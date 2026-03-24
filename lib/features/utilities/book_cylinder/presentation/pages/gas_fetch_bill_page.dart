import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../data/gas_api_exceptions.dart';
import '../providers/gas_provider.dart';
import 'gas_bill_breakdown_page.dart';

class GasFetchBillPage extends ConsumerStatefulWidget {
  const GasFetchBillPage({super.key});

  @override
  ConsumerState<GasFetchBillPage> createState() => _GasFetchBillPageState();
}

class _GasFetchBillPageState extends ConsumerState<GasFetchBillPage> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchBill());
  }

  Future<void> _fetchBill() async {
    final biller = ref.read(selectedGasBillerProvider);
    final consumerNumber = ref.read(gasConsumerNumberProvider);
    if (biller == null) {
      setState(() {
        _loading = false;
        _error = 'Select biller first';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final bill = await ref.read(gasRepositoryProvider).fetchBill(
            billerId: biller.id,
            consumerNumber: consumerNumber.trim(),
          );
      if (!mounted) return;
      ref.read(fetchedGasBillProvider.notifier).state = bill;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const GasBillBreakdownPage(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = gasApiUserMessage(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Fetch bill'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_error!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              _loading = true;
                              _error = null;
                            });
                            _fetchBill();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(child: Text('Fetching...')),
    );
  }
}

