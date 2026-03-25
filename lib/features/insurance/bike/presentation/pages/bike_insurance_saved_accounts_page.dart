import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/bike_saved_account_model.dart';
import '../providers/bike_accounts_provider.dart';

class BikeInsuranceSavedAccountsPage extends ConsumerWidget {
  const BikeInsuranceSavedAccountsPage({super.key});

  static Color _statusChipColor(ColorScheme cs, String type) {
    final t = type.toLowerCase();
    if (t.contains('upi')) return Colors.green;
    if (t.contains('card')) return cs.primary;
    return cs.primary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final selectedId = ref.watch(selectedBikeSavedAccountIdProvider);

    final async = ref.watch(bikeSavedAccountsProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Saved Accounts',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add account',
            onPressed: () => _showCreateAccountDialog(context, ref),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  e.toString().replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(bikeSavedAccountsProvider),
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (accounts) {
          if (accounts.isEmpty) {
            return Center(
              child: Text(
                'No saved accounts found.',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          final effectiveSelectedId = selectedId ?? accounts.first.id;

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: accounts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final a = accounts[i];
              final selected = a.id == effectiveSelectedId;
              final chipColor = _statusChipColor(colorScheme, a.accountType);

              return InkWell(
                onTap: () => ref
                    .read(selectedBikeSavedAccountIdProvider.notifier)
                    .state = a.id,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selected
                        ? colorScheme.primary.withValues(alpha: 0.12)
                        : colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.45,
                          ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              a.accountType.toLowerCase().contains('upi')
                                  ? Icons.qr_code_rounded
                                  : Icons.payment_rounded,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  a.title,
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                if (a.subtitle != null && a.subtitle!.isNotEmpty)
                                  Text(
                                    a.subtitle!,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: chipColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    a.accountType,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: chipColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            selected
                                ? Icons.check_circle_rounded
                                : Icons.circle_outlined,
                            size: 22,
                            color: selected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert_rounded, size: 20),
                            onSelected: (v) {
                              if (v == 'edit') {
                                _showEditAccountDialog(context, ref, a);
                              } else if (v == 'delete') {
                                _confirmDelete(context, ref, a.id);
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (selected)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account Number: ${a.masked != null && a.masked!.isNotEmpty ? a.masked : "—"}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Consumer Name: ${a.subtitle != null && a.subtitle!.isNotEmpty ? a.subtitle : "—"}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Label: ${a.title.isNotEmpty ? a.title : "—"}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (a.isDefault)
                                ...[
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 16,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Default account',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showCreateAccountDialog(BuildContext context, WidgetRef ref) async {
    final mut = ref.read(bikeSavedAccountsMutationsProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ts = theme.textTheme;

    final accountTypeController = TextEditingController(text: 'UPI');
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    final maskedController = TextEditingController();
    bool isDefault = false;

    await showDialog<void>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Saved Account'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: accountTypeController,
                      decoration: const InputDecoration(labelText: 'Account Type'),
                    ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: subtitleController,
                      decoration: const InputDecoration(labelText: 'Subtitle (optional)'),
                    ),
                    TextField(
                      controller: maskedController,
                      decoration: const InputDecoration(labelText: 'Masked (optional)'),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: isDefault,
                      onChanged: (v) => setState(() => isDefault = v ?? false),
                      title: Text('Set as default'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    final accountType = accountTypeController.text.trim();
                    final title = titleController.text.trim();
                    if (accountType.isEmpty || title.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Account Type and Title are required.',
                            style: ts.bodyMedium?.copyWith(color: cs.onSurface),
                          ),
                        ),
                      );
                      return;
                    }

                    try {
                      await mut.create(
                        accountType: accountType,
                        title: title,
                        subtitle: subtitleController.text.trim(),
                        masked: maskedController.text.trim(),
                        isDefault: isDefault,
                      );
                      if (context.mounted) Navigator.of(context).pop();
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showEditAccountDialog(
    BuildContext context,
    WidgetRef ref,
    BikeSavedAccount account,
  ) async {
    final mut = ref.read(bikeSavedAccountsMutationsProvider);
    final theme = Theme.of(context);
    final ts = theme.textTheme;

    final accountTypeController = TextEditingController(text: account.accountType);
    final titleController = TextEditingController(text: account.title);
    final subtitleController = TextEditingController(text: account.subtitle ?? '');
    final maskedController = TextEditingController(text: account.masked ?? '');
    bool isDefault = account.isDefault;

    await showDialog<void>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Saved Account'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: accountTypeController,
                      decoration: const InputDecoration(labelText: 'Account Type'),
                    ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: subtitleController,
                      decoration: const InputDecoration(labelText: 'Subtitle (optional)'),
                    ),
                    TextField(
                      controller: maskedController,
                      decoration: const InputDecoration(labelText: 'Masked (optional)'),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: isDefault,
                      onChanged: (v) => setState(() => isDefault = v ?? false),
                      title: Text(
                        'Set as default',
                        style: ts.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    final accountType = accountTypeController.text.trim();
                    final title = titleController.text.trim();
                    if (accountType.isEmpty || title.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Account Type and Title are required.')),
                      );
                      return;
                    }

                    try {
                      await mut.update(
                        id: account.id,
                        accountType: accountType,
                        title: title,
                        subtitle: subtitleController.text.trim(),
                        masked: maskedController.text.trim(),
                        isDefault: isDefault,
                      );
                      if (context.mounted) Navigator.of(context).pop();
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                      );
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final mut = ref.read(bikeSavedAccountsMutationsProvider);

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete account?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (ok != true) return;
    try {
      await mut.delete(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }
}

