import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../data/broadband_api_exceptions.dart';
import '../providers/broadband_provider.dart';
import 'broadband_bill_breakdown_page.dart';

class BroadbandFetchBillPage extends ConsumerStatefulWidget {
  const BroadbandFetchBillPage({super.key});

  @override
  ConsumerState<BroadbandFetchBillPage> createState() => _BroadbandFetchBillPageState();
}

class _BroadbandFetchBillPageState extends ConsumerState<BroadbandFetchBillPage> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchBill());
  }

  Future<void> _fetchBill() async {
    final biller = ref.read(selectedBroadbandBillerProvider);
    final consumerNumber = ref.read(broadbandConsumerNumberProvider);
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
      final bill = await ref.read(broadbandRepositoryProvider).fetchBill(
            billerId: biller.id,
            consumerNumber: consumerNumber.trim(),
          );
      if (!mounted) return;
      ref.read(fetchedBroadbandBillProvider.notifier).state = bill;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const BroadbandBillBreakdownPage(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = broadbandApiUserMessage(e);
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
