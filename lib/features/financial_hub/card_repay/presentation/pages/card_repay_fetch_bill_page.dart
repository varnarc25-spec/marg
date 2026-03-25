import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/card_repay_api_exceptions.dart';
import '../providers/card_repay_provider.dart';
import 'card_repay_bill_breakdown_page.dart';

class CardRepayFetchBillPage extends ConsumerStatefulWidget {
  const CardRepayFetchBillPage({super.key});

  @override
  ConsumerState<CardRepayFetchBillPage> createState() => _CardRepayFetchBillPageState();
}

class _CardRepayFetchBillPageState extends ConsumerState<CardRepayFetchBillPage> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchBill());
  }

  Future<void> _fetchBill() async {
    final biller = ref.read(selectedCardRepayBillerProvider);
    final consumerNumber = ref.read(cardRepayConsumerNumberProvider);
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
      final bill = await ref.read(cardRepayRepositoryProvider).fetchBill(
            billerId: biller.id,
            consumerNumber: consumerNumber.trim(),
          );
      if (!mounted) return;
      ref.read(fetchedCardRepayBillProvider.notifier).state = bill;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const CardRepayBillBreakdownPage(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = cardRepayApiUserMessage(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Fetch Bill'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error ?? 'Fetching...'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _fetchBill,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
