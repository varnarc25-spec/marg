import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../gold_silver/presentation/screens/gold_silver_screens.dart';
import 'home_icon_grid_widget.dart';

/// Gold & Silver hub: Buy Gold, Daily Gold Savings, Buy 999 Silver, Daily Silver Savings.
class HomeGoldSilverHub extends ConsumerWidget {
  const HomeGoldSilverHub({super.key, this.items});

  /// Optional API-driven items. When null/empty, falls back to the default
  /// hardcoded tiles (using localized labels).
  final List<HomeIconGridItem>? items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    final defaultItems = <HomeIconGridItem>[
      HomeIconGridItem(
        Icons.monetization_on_rounded,
        l10n.homeGoldBuyGold,
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const BuyGoldPage()));
        },
      ),
      HomeIconGridItem(
        Icons.savings_rounded,
        l10n.homeGoldDailyGoldSavings,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const DailyGoldSavingsPage()),
          );
        },
      ),
      HomeIconGridItem(
        Icons.diamond_rounded,
        l10n.homeGoldBuy999Silver,
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const BuySilver999Page()));
        },
      ),
      HomeIconGridItem(
        Icons.savings_rounded,
        l10n.homeGoldDailySilverSavings,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const DailySilverSavingsPage()),
          );
        },
      ),
    ];

    final displayItems = (items == null || items!.isEmpty)
        ? defaultItems
        : items!;
    return HomeIconGrid(items: displayItems, columns: 4, maxItems: 4);
  }
}
