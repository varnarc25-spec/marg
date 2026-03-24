import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/models/dth_operator.dart';
import '../../data/models/dth_saved_account.dart';
import '../providers/dth_recharge_provider.dart';
import '../widgets/dth_operator_picker_sheet.dart';
import '../widgets/dth_promo_banner.dart';
import '../widgets/dth_saved_account_card.dart';
import 'dth_number_input_page.dart';
import 'dth_plan_list_page.dart';
import 'dth_recent_history_page.dart';

/// DTH home: saved accounts, promo strip, Add New → operator sheet → subscriber ID → plans.
class DthRechargeHomePage extends ConsumerStatefulWidget {
  const DthRechargeHomePage({super.key});

  @override
  ConsumerState<DthRechargeHomePage> createState() =>
      _DthRechargeHomePageState();
}

class _DthRechargeHomePageState extends ConsumerState<DthRechargeHomePage> {
  Future<void> _refresh() async {
    ref.invalidate(dthSavedAccountsProvider);
    await ref.read(dthSavedAccountsProvider.future);
  }

  Future<void> _onAddNew() async {
    final op = await showDthOperatorPicker(context);
    if (op == null || !mounted) return;
    ref.read(selectedDthOperatorProvider.notifier).state = op;
    ref.read(dthSubscriberIdProvider.notifier).state = '';
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const DthNumberInputPage()),
    );
  }

  Future<void> _openSaved(DthSavedAccount account) async {
    ref.read(selectedDthOperatorProvider.notifier).state = DthOperator(
      id: account.operatorId,
      name: account.operatorName,
      logoUrl: account.logoUrl,
    );
    ref.read(dthSubscriberIdProvider.notifier).state = account.subscriberId;
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const DthPlanListPage()),
    );
  }

  Future<void> _confirmDelete(DthSavedAccount account) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove saved account?'),
        content: Text(account.subtitleLine),
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
    if (ok != true || !mounted) return;
    try {
      final repo = ref.read(dthRechargeRepositoryProvider);
      await repo.deleteSavedAccount(account.id);
      if (mounted) {
        ref.invalidate(dthSavedAccountsProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final savedAsync = ref.watch(dthSavedAccountsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Recharge DTH or TV',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'History',
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => const DthRecentHistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: savedAsync.when(
              data: (accounts) => RefreshIndicator(
                onRefresh: _refresh,
                child: accounts.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        children: const [
                          DthPromoBanner(),
                          SizedBox(height: 48),
                          Center(
                            child: Text(
                              'No data',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                        children: [
                          const DthPromoBanner(),
                          const SizedBox(height: 20),
                          Text(
                            'Saved connections',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...accounts.map(
                            (a) => DthSavedAccountCard(
                              account: a,
                              onTap: () => _openSaved(a),
                              onDelete: () => _confirmDelete(a),
                            ),
                          ),
                        ],
                      ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: const [
                    DthPromoBanner(),
                    SizedBox(height: 48),
                    Center(
                      child: Text(
                        'No data',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: FilledButton.icon(
                onPressed: _onAddNew,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add New'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
