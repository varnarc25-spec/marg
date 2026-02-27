import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/education_provider.dart';
import 'education_fee_schedule_page.dart';
import 'education_receipt_archive_page.dart';

class EducationStudentProfilePage extends ConsumerWidget {
  const EducationStudentProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inst = ref.watch(selectedEducationInstitutionProvider);
    if (inst == null) return const Scaffold(body: Center(child: Text('Select institution')));

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: Text(inst.name), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const TextField(decoration: InputDecoration(labelText: 'Student name')),
          const SizedBox(height: 8),
          const TextField(decoration: InputDecoration(labelText: 'Student ID / Roll no')),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: const Text('Fee schedule'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EducationFeeSchedulePage())),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_rounded),
            title: const Text('Receipt archive'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EducationReceiptArchivePage())),
          ),
        ],
      ),
    );
  }
}
