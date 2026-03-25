import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/education_api_exceptions.dart';
import '../providers/education_provider.dart';
import 'education_consumer_number_page.dart';

class EducationBillerPage extends ConsumerWidget {
  const EducationBillerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectedEducationStateProvider);
    final billersAsync = state != null ? ref.watch(educationBillersProvider(state.id)) : null;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Select institution'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: billersAsync == null
          ? const Center(child: Text('Select state first'))
          : billersAsync.when(
              data: (billers) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: billers.length,
                itemBuilder: (_, i) {
                  final b = billers[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.account_balance_rounded),
                      title: Text(b.name),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ref.read(selectedEducationBillerProvider.notifier).state = b;
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const EducationConsumerNumberPage(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(educationApiUserMessage(e))),
            ),
    );
  }
}
