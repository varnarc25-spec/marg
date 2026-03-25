import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/education_api_exceptions.dart';
import '../providers/education_provider.dart';
import 'education_add_account_page.dart';

class EducationSavedAccountsPage extends ConsumerWidget {
  const EducationSavedAccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(educationSavedAccountsProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Saved accounts'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const EducationAddAccountPage()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
      body: async.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return Center(
              child: FilledButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const EducationAddAccountPage(),
                  ),
                ),
                child: const Text('Add account'),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            itemCount: accounts.length,
            itemBuilder: (_, i) {
              final a = accounts[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.school_rounded),
                  title: Text(a.label ?? a.accountNumber),
                  subtitle: Text(a.accountNumber),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () async {
                      try {
                        await ref.read(educationRepositoryProvider).deleteSavedAccount(a.id);
                        ref.invalidate(educationSavedAccountsProvider);
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(educationApiUserMessage(e))),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(educationApiUserMessage(e))),
      ),
    );
  }
}
