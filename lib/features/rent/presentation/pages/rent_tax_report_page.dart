import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

/// Tax-ready report for rent paid. TODO: API for FY summary.
class RentTaxReportPage extends ConsumerWidget {
  const RentTaxReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Tax report'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: const Center(child: Text('TODO: Annual rent paid summary for ITR')),
    );
  }
}
