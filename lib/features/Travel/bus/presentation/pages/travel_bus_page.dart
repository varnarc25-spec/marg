import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/bus_city_model.dart';
import '../../data/models/bus_list_data.dart';
import '../providers/bus_search_provider.dart';
import '../widgets/bus_floating_action.dart';
import '../widgets/bus_home_sections.dart';
import '../widgets/bus_search_card.dart';
import 'bus_city_search_page.dart';
import 'bus_search_results_page.dart';
import 'travel_bookings_page.dart';

/// Bus travel home page: app bar, previous journey, promo, search card,
/// partner offers, explore feature, exclusive features, calendar, travel blogs,
/// bottom floating action (Offers / My Bookings).
class TravelBusPage extends ConsumerStatefulWidget {
  const TravelBusPage({super.key});

  @override
  ConsumerState<TravelBusPage> createState() => _TravelBusPageState();
}

class _TravelBusPageState extends ConsumerState<TravelBusPage> {
  int _selectedDateIndex = 1;
  int _busTypeIndex = -1;
  int _floatingNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final from = ref.watch(busFromProvider);
    final to = ref.watch(busToProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Paytm ',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              'travel',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Help',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              0,
              16,
              90 + MediaQuery.paddingOf(context).bottom,
            ),
            children: [
              const SizedBox(height: 12),
              BusPreviousJourneyCard(
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: 12),
              BusPromoBanner(colorScheme: colorScheme, textTheme: textTheme),
              const SizedBox(height: 16),
              BusSearchCard(
                fromCity: from.cityName,
                toCity: to.cityName,
                onFromTap: () => _openCitySelect(selectingFrom: true),
                onToTap: () => _openCitySelect(selectingFrom: false),
                onSwapTap: () {
                  final currentFrom = ref.read(busFromProvider);
                  final currentTo = ref.read(busToProvider);
                  ref.read(busFromProvider.notifier).state = currentTo;
                  ref.read(busToProvider.notifier).state = currentFrom;
                },
                selectedDateIndex: _selectedDateIndex,
                onDateTap: (i) => setState(() => _selectedDateIndex = i),
                busTypeIndex: _busTypeIndex,
                onBusTypeTap: (i) => setState(() => _busTypeIndex = i),
                onSearchPressed: () {
                  final date = busDepartureDates[_selectedDateIndex];
                  final dateLabel = '${date.weekday}, ${date.day} Mar';
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BusSearchResultsPage(
                        fromCity: from.cityName,
                        toCity: to.cityName,
                        dateLabel: dateLabel,
                      ),
                    ),
                  );
                },
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: 24),
              BusSectionTitle(
                'Partner Offers',
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 10),
              BusPartnerOffersRow(
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: 24),
              BusSectionTitle(
                'Explore Our New Feature',
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 10),
              BusExploreFeatureBanner(
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: 24),
              BusSectionTitle(
                'Exclusive features on Paytm',
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: BusExclusiveFeaturesRow(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              const SizedBox(height: 24),
              BusLongWeekendBanner(
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: 24),
              BusSectionTitle(
                'Travel Blogs',
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 10),
              BusTravelBlogsRow(
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: 24),
            ],
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 16 + MediaQuery.paddingOf(context).bottom,
            child: Center(
              child: BusFloatingAction(
                selectedIndex: _floatingNavIndex,
                onTap: (i) {
                  if (i == 1) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TravelBookingsPage(),
                      ),
                    );
                  } else {
                    setState(() => _floatingNavIndex = i);
                  }
                },
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCitySelect({required bool selectingFrom}) async {
    final from = ref.read(busFromProvider);
    final to = ref.read(busToProvider);
    final result = await Navigator.of(context).push<BusCitySearchResult>(
      MaterialPageRoute(
        builder: (context) => BusCitySearchPage(
          initialFrom: from.cityName,
          initialTo: to.cityName,
          selectingFrom: selectingFrom,
        ),
      ),
    );
    if (result != null && mounted) {
      if (selectingFrom) {
        ref.read(busFromProvider.notifier).state =
            BusCityResult(cityName: result.cityName);
      } else {
        ref.read(busToProvider.notifier).state =
            BusCityResult(cityName: result.cityName);
      }
    }
  }
}
