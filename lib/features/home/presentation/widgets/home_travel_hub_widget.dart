import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'home_icon_grid_widget.dart';

/// Travel hub: Flight, Bus, Train, Hotel.
class HomeTravelHub extends ConsumerWidget {
  const HomeTravelHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    final items = [
      HomeIconGridItem(Icons.flight_rounded, l10n.homeTravelFlight),
      HomeIconGridItem(Icons.directions_bus_rounded, l10n.homeTravelBus),
      HomeIconGridItem(Icons.train_rounded, l10n.homeTravelTrain),
      HomeIconGridItem(Icons.hotel_rounded, l10n.homeTravelHotel),
    ];
    return HomeIconGrid(items: items, columns: 4);
  }
}
