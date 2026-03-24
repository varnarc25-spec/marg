import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/loan_repayment_api_exceptions.dart';
import '../providers/loan_repayment_provider.dart';

class LoanRepaymentPaymentSuccessPage extends ConsumerStatefulWidget {
  const LoanRepaymentPaymentSuccessPage({super.key});

  @override
  ConsumerState<LoanRepaymentPaymentSuccessPage> createState() =>
      _LoanRepaymentPaymentSuccessPageState();
}

class _LoanRepaymentPaymentSuccessPageState extends ConsumerState<LoanRepaymentPaymentSuccessPage> {
  bool _loading = true;
  String? _statusText;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStatus());
  }

  Future<void> _loadStatus() async {
    final id = ref.read(lastLoanRepaymentTransactionIdProvider);
    if (id == null || id.isEmpty) {
      setState(() {
        _loading = false;
        _statusText = 'Payment submitted';
      });
      return;
    }

    try {
      final res = await ref.read(loanRepaymentRepositoryProvider).getPaymentStatus(id);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _statusText = (res['status'] ?? res['paymentStatus'] ?? 'Payment submitted').toString();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = loanRepaymentApiUserMessage(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 80),
              const SizedBox(height: 20),
              Text('Payment initiated', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              if (_loading) const CircularProgressIndicator(),
              if (!_loading && _statusText != null) Text(_statusText!, textAlign: TextAlign.center),
              if (!_loading && _error != null) Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
