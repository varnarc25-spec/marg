import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/loan_repayment_api_exceptions.dart';
import '../../data/models/loan_repayment_saved_account.dart';
import '../providers/loan_repayment_provider.dart';

class LoanRepaymentAccountsPage extends ConsumerWidget {
  const LoanRepaymentAccountsPage({super.key});

  Future<void> _openAddDialog(BuildContext context, WidgetRef ref) async {
    final biller = ref.read(selectedLoanRepaymentBillerProvider);
    if (biller == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select biller in Loan Repayment page first')),
      );
      return;
    }
    final accountController = TextEditingController();
    final labelController = TextEditingController();
    final nameController = TextEditingController();
    var autoPay = false;

    final save = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: const Text('Add account'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: accountController,
                    decoration: const InputDecoration(labelText: 'Account number'),
                  ),
                  TextField(
                    controller: labelController,
                    decoration: const InputDecoration(labelText: 'Label'),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Consumer name'),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: autoPay,
                    onChanged: (v) => setState(() => autoPay = v),
                    title: const Text('Enable autopay'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
            ],
          ),
        );
      },
    );

    if (save != true) return;
    try {
      await ref.read(loanRepaymentRepositoryProvider).createAccount(
            accountNumber: accountController.text.trim(),
            label: labelController.text.trim(),
            billerId: biller.id,
            billerName: biller.name,
            consumerName: nameController.text.trim(),
            isAutopay: autoPay,
          );
      ref.invalidate(loanRepaymentSavedAccountsProvider);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loanRepaymentApiUserMessage(e))));
    }
  }

  Future<void> _openEditDialog(
    BuildContext context,
    WidgetRef ref,
    LoanRepaymentSavedAccount account,
  ) async {
    final labelController = TextEditingController(text: account.label ?? '');
    final nameController = TextEditingController(text: account.consumerName ?? '');
    var autoPay = account.isAutopay;
    final update = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: const Text('Update account'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: labelController,
                  decoration: const InputDecoration(labelText: 'Label'),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Consumer name'),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: autoPay,
                  onChanged: (v) => setState(() => autoPay = v),
                  title: const Text('Enable autopay'),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Update')),
            ],
          ),
        );
      },
    );

    if (update != true) return;
    try {
      await ref.read(loanRepaymentRepositoryProvider).updateAccount(
            accountId: account.id,
            label: labelController.text.trim(),
            consumerName: nameController.text.trim(),
            isAutopay: autoPay,
          );
      ref.invalidate(loanRepaymentSavedAccountsProvider);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loanRepaymentApiUserMessage(e))));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(loanRepaymentSavedAccountsProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Saved Loan Accounts'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddDialog(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
      body: async.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return const Center(child: Text('No saved accounts yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: accounts.length,
            itemBuilder: (_, i) {
              final account = accounts[i];
              final accountName = account.label ?? account.billerName ?? 'Loan account';
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  onTap: () {
                    ref.read(selectedLoanRepaymentSavedAccountIdProvider.notifier).state = account.id;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved account selected for payment')),
                    );
                  },
                  title: Text(accountName),
                  subtitle: Text('A/C: ${account.accountNumber}'),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      IconButton(
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _openEditDialog(context, ref, account),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () async {
                          try {
                            await ref.read(loanRepaymentRepositoryProvider).deleteSavedAccount(account.id);
                            ref.invalidate(loanRepaymentSavedAccountsProvider);
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(loanRepaymentApiUserMessage(e))));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(loanRepaymentApiUserMessage(e))),
      ),
    );
  }
}
