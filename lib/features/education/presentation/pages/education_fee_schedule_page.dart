import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/education_provider.dart';

class EducationFeeSchedulePage extends ConsumerStatefulWidget {
  const EducationFeeSchedulePage({super.key});

  @override
  ConsumerState<EducationFeeSchedulePage> createState() => _EducationFeeSchedulePageState();
}

class _EducationFeeSchedulePageState extends ConsumerState<EducationFeeSchedulePage> {
  List<Map<String, dynamic>> _schedule = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final inst = ref.read(selectedEducationInstitutionProvider);
    if (inst != null) {
      ref.read(educationRepositoryProvider).getFeeSchedule(inst.id).then((list) {
        if (mounted) {
          setState(() {
            _schedule = list;
            _loading = false;
          });
        }
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Fee schedule'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _schedule.length,
              itemBuilder: (_, i) {
                final s = _schedule[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(s['term']?.toString() ?? ''),
                    subtitle: Text(s['dueDate']?.toString() ?? ''),
                    trailing: Text('₹${s['amount']}'),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TODO: Installment payment'))),
                  ),
                );
              },
            ),
    );
  }
}
