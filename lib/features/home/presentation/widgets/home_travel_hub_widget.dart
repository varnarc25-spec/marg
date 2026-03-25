import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'home_icon_grid_widget.dart';
import '../../../travel/flight/presentation/pages/travel_flight_page.dart';
import '../../../travel/bus/presentation/pages/travel_bus_page.dart';
import '../../../travel/train/presentation/pages/travel_train_page.dart';
import '../../../travel/hotels/presentation/pages/travel_hotels_page.dart';

/// Travel hub: Flight, Bus, Train, Hotel.
class HomeTravelHub extends ConsumerWidget {
  const HomeTravelHub({super.key, required this.items});

  final List<HomeIconGridItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final l10n = ref.watch(l10nProvider);
    // final items = [
    //   HomeIconGridItem(
    //     Icons.flight_rounded,
    //     l10n.homeTravelFlight,
    //     onTap: () {
    //       Navigator.of(
    //         context,
    //       ).push(MaterialPageRoute(builder: (_) => const TravelFlightPage()));
    //     },
    //   ),
    //   HomeIconGridItem(
    //     Icons.directions_bus_rounded,
    //     l10n.homeTravelBus,
    //     onTap: () {
    //       Navigator.of(
    //         context,
    //       ).push(MaterialPageRoute(builder: (_) => const TravelBusPage()));
    //     },
    //   ),
    //   HomeIconGridItem(
    //     Icons.train_rounded,
    //     l10n.homeTravelTrain,
    //     onTap: () {
    //       Navigator.of(
    //         context,
    //       ).push(MaterialPageRoute(builder: (_) => const TravelTrainPage()));
    //     },
    //   ),
    //   HomeIconGridItem(
    //     Icons.hotel_rounded,
    //     l10n.homeTravelHotel,
    //     onTap: () {
    //       Navigator.of(
    //         context,
    //       ).push(MaterialPageRoute(builder: (_) => const TravelHotelsPage()));
    //     },
    //   ),
    // ];
    // return HomeIconGrid(items: items, columns: 4);
    return HomeIconGrid(items: items, columns: 4, maxItems: 4);
  }
}
