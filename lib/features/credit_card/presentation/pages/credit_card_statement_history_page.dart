import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

/// Statement history. TODO: API for past statements.
class CreditCardStatementHistoryPage extends ConsumerWidget {
  const CreditCardStatementHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Statement history'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: const Center(child: Text('No statements yet. TODO: Fetch from API')),
    );
  }
}
