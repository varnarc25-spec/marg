import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/loan_repayment_api_exceptions.dart';
import '../providers/loan_repayment_provider.dart';
import 'loan_repayment_bill_breakdown_page.dart';

class LoanRepaymentFetchBillPage extends ConsumerStatefulWidget {
  const LoanRepaymentFetchBillPage({super.key});

  @override
  ConsumerState<LoanRepaymentFetchBillPage> createState() => _LoanRepaymentFetchBillPageState();
}

class _LoanRepaymentFetchBillPageState extends ConsumerState<LoanRepaymentFetchBillPage> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchBill());
  }

  Future<void> _fetchBill() async {
    final biller = ref.read(selectedLoanRepaymentBillerProvider);
    final consumerNumber = ref.read(loanRepaymentConsumerNumberProvider);
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
      final bill = await ref.read(loanRepaymentRepositoryProvider).fetchBill(
            billerId: biller.id,
            consumerNumber: consumerNumber.trim(),
          );
      if (!mounted) return;
      ref.read(fetchedLoanRepaymentBillProvider.notifier).state = bill;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const LoanRepaymentBillBreakdownPage(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        final msg = loanRepaymentApiUserMessage(e).trim();
        _error = msg.isEmpty || msg == kLoanRepaymentApiErrorMessage
            ? 'Data not available or invalid details'
            : msg;
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
