import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/education_api_exceptions.dart';
import '../providers/education_provider.dart';
import 'education_bill_breakdown_page.dart';

class EducationFetchBillPage extends ConsumerStatefulWidget {
  const EducationFetchBillPage({super.key});

  @override
  ConsumerState<EducationFetchBillPage> createState() => _EducationFetchBillPageState();
}

class _EducationFetchBillPageState extends ConsumerState<EducationFetchBillPage> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchBill());
  }

  Future<void> _fetchBill() async {
    final biller = ref.read(selectedEducationBillerProvider);
    final consumerNumber = ref.read(educationConsumerNumberProvider);
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
      final bill = await ref.read(educationRepositoryProvider).fetchBill(
            billerId: biller.id,
            consumerNumber: consumerNumber.trim(),
          );
      if (!mounted) return;
      ref.read(fetchedEducationBillProvider.notifier).state = bill;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const EducationBillBreakdownPage(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = educationApiUserMessage(e);
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
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error ?? 'Fetching...'),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: _fetchBill, child: const Text('Retry')),
                  ],
                ),
              ),
            ),
    );
  }
}
