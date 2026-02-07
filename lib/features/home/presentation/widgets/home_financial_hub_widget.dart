import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'home_icon_grid_widget.dart';

/// Financial Hub: Card Repay, Savings, Invest, Exchange.
class HomeFinancialHub extends ConsumerWidget {
  const HomeFinancialHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    final items = [
      HomeIconGridItem(Icons.credit_card_rounded, l10n.homeIconCardRepay),
      HomeIconGridItem(Icons.savings_rounded, l10n.homeIconSavings),
      HomeIconGridItem(Icons.trending_up_rounded, l10n.homeIconInvest),
      HomeIconGridItem(Icons.swap_horiz_rounded, l10n.homeIconExchange),
    ];
    return HomeIconGrid(items: items, columns: 4);
  }
}
