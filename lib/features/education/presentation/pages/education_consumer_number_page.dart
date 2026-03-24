import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/education_provider.dart';
import 'education_fetch_bill_page.dart';

class EducationConsumerNumberPage extends ConsumerStatefulWidget {
  const EducationConsumerNumberPage({super.key});

  @override
  ConsumerState<EducationConsumerNumberPage> createState() =>
      _EducationConsumerNumberPageState();
}

class _EducationConsumerNumberPageState extends ConsumerState<EducationConsumerNumberPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Consumer number'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Consumer number',
              hintText: 'Enter consumer number',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => ref.read(educationConsumerNumberProvider.notifier).state = v,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ref.read(educationConsumerNumberProvider.notifier).state = _controller.text.trim();
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const EducationFetchBillPage(),
                ),
              );
            },
            child: const Text('Fetch bill'),
          ),
        ],
      ),
    );
  }
}
