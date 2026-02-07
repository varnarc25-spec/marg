import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'home_icon_grid_widget.dart';

/// Convenient Hub: Travel, Top Up, Utilities, City Services, Rewards, Family Center, Credit Life, More.
class HomeConvenientHub extends ConsumerWidget {
  const HomeConvenientHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    final items = [
      HomeIconGridItem(Icons.directions_car_rounded, l10n.homeIconTravel),
      HomeIconGridItem(Icons.add_circle_outline_rounded, l10n.homeIconTopUp),
      HomeIconGridItem(Icons.local_fire_department_rounded, l10n.homeIconUtilities),
      HomeIconGridItem(Icons.business_rounded, l10n.homeIconCityServices),
      HomeIconGridItem(Icons.card_giftcard_rounded, l10n.homeIconRewards),
      HomeIconGridItem(Icons.family_restroom_rounded, l10n.homeIconFamilyCenter),
      HomeIconGridItem(Icons.eco_rounded, l10n.homeIconCreditLife),
      HomeIconGridItem(Icons.apps_rounded, l10n.homeIconMore),
    ];
    return HomeIconGrid(items: items, columns: 4);
  }
}
