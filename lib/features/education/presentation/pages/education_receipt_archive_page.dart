import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class EducationReceiptArchivePage extends ConsumerWidget {
  const EducationReceiptArchivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Receipt archive'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: const Center(child: Text('TODO: List receipts from API')),
    );
  }
}
