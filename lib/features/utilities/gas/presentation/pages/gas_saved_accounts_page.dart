import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../data/gas_api_exceptions.dart';
import '../providers/gas_provider.dart';
import 'gas_add_account_page.dart';

/// `GET /api/utilities/piped-gas/accounts`
class GasSavedAccountsPage extends ConsumerWidget {
  const GasSavedAccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(gasSavedAccountsProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Saved accounts'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(gasSavedAccountsProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(builder: (_) => const GasAddAccountPage()),
          );
          if (added == true && context.mounted) {
            ref.invalidate(gasSavedAccountsProvider);
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
      body: async.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No saved accounts'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () async {
                        final added = await Navigator.of(context).push<bool>(
                          MaterialPageRoute<bool>(builder: (_) => const GasAddAccountPage()),
                        );
                        if (added == true && context.mounted) {
                          ref.invalidate(gasSavedAccountsProvider);
                        }
                      },
                      child: const Text('Add account'),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            itemCount: accounts.length,
            itemBuilder: (_, i) {
              final a = accounts[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.local_fire_department_rounded),
                  title: Text(a.label ?? a.accountNumber),
                  subtitle: Text(
                    [
                      a.accountNumber,
                      if (a.billerName != null) a.billerName!,
                      if (a.isAutopay) 'Autopay',
                    ].join(' · '),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Remove account?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      );
                      if (ok != true || !context.mounted) return;
                      try {
                        await ref.read(gasRepositoryProvider).deleteSavedAccount(a.id);
                        ref.invalidate(gasSavedAccountsProvider);
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(gasApiUserMessage(e))),
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
        error: (e, _) => Center(child: Text(gasApiUserMessage(e))),
      ),
    );
  }
}
