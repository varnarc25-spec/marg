import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../data/water_api_exceptions.dart';
import '../providers/water_provider.dart';
import 'water_add_account_page.dart';

/// `GET /api/utilities/water/accounts`
class WaterSavedAccountsPage extends ConsumerWidget {
  const WaterSavedAccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(waterSavedAccountsProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Saved accounts'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(waterSavedAccountsProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(
              builder: (_) => const WaterAddAccountPage(),
            ),
          );
          if (added == true && context.mounted) {
            ref.invalidate(waterSavedAccountsProvider);
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
                          MaterialPageRoute<bool>(
                            builder: (_) => const WaterAddAccountPage(),
                          ),
                        );
                        if (added == true && context.mounted) {
                          ref.invalidate(waterSavedAccountsProvider);
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
                  leading: const Icon(Icons.water_drop_rounded),
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
                        await ref
                            .read(waterRepositoryProvider)
                            .deleteSavedAccount(a.id);
                        ref.invalidate(waterSavedAccountsProvider);
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(waterApiUserMessage(e)),
                          ),
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
        error: (e, _) => Center(child: Text(waterApiUserMessage(e))),
      ),
    );
  }
}
