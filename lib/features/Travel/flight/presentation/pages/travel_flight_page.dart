import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/flight_city_model.dart';
import '../../data/services/flight_search_service.dart';
import '../providers/flight_search_provider.dart';
import '../widgets/travel_flight_bottom_nav.dart';
import '../widgets/travel_flight_home_sections.dart';
import '../widgets/travel_flight_search_card.dart';
import 'flight_city_select_page.dart';
import 'flight_my_bookings_page.dart';
import 'flight_search_results_page.dart';

/// Single Travel Flights page: app bar, promo, search card,
/// discovery sections, bank offers, recent searches, bottom nav. Uses app theme.
/// Category tabs (Flights, Bus, Trains, Hotels, Intl. Flight) removed per design.
/// Uses providers for from/to (same structure as bike insurance).
class TravelFlightPage extends ConsumerStatefulWidget {
  const TravelFlightPage({super.key});

  @override
  ConsumerState<TravelFlightPage> createState() => _TravelFlightPageState();
}

class _TravelFlightPageState extends ConsumerState<TravelFlightPage> {
  bool _oneWay = true;
  int _specialFareIndex = 0; // Student, Armed Forces, Senior Citizen
  bool _nonStopOnly = false;
  int _bottomNavIndex = 3; // Flight Tracker selected
  DateTime _departureDate = DateTime.now();
  int _adults = 1;
  String _cabinClass = 'Economy';

  Future<void> _openCitySelect({required bool selectingFrom}) async {
    final from = ref.read(flightFromProvider);
    final to = ref.read(flightToProvider);
    final result = await Navigator.of(context).push<FlightCityResult>(
      MaterialPageRoute(
        builder: (_) => FlightCitySelectPage(
          selectingFrom: selectingFrom,
          initialFromCode: from.code,
          initialFromCity: from.cityName,
          initialToCode: to.code,
          initialToCity: to.cityName,
        ),
      ),
    );
    if (result != null && mounted) {
      if (selectingFrom) {
        ref.read(flightFromProvider.notifier).state = result;
      } else {
        ref.read(flightToProvider.notifier).state = result;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final from = ref.watch(flightFromProvider);
    final to = ref.watch(flightToProvider);

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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              children: [
                const SizedBox(height: 12),
                FlightPromoBanner(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 16),
                FlightSearchCard(
                  fromCode: from.code,
                  fromCity: from.cityName,
                  toCode: to.code,
                  toCity: to.cityName,
                  departureDate: _departureDate,
                  onFromTap: () => _openCitySelect(selectingFrom: true),
                  onToTap: () => _openCitySelect(selectingFrom: false),
                  onSwapTap: () {
                    final currentFrom = ref.read(flightFromProvider);
                    final currentTo = ref.read(flightToProvider);
                    ref.read(flightFromProvider.notifier).state = currentTo;
                    ref.read(flightToProvider.notifier).state = currentFrom;
                  },
                  onDepartureDateTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _departureDate.isAfter(now)
                          ? _departureDate
                          : now,
                      firstDate: now,
                      lastDate: now.add(const Duration(days: 365)),
                    );
                    if (picked != null && mounted) {
                      setState(() {
                        _departureDate = picked;
                      });
                    }
                  },
                  adults: _adults,
                  cabinClass: _cabinClass,
                  onTravellersTap: () async {
                    final result =
                        await showModalBottomSheet<
                          ({int adults, String cabinClass})
                        >(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            final theme = Theme.of(context);
                            final colorScheme = theme.colorScheme;
                            final textTheme = theme.textTheme;
                            int tmpAdults = _adults;
                            String tmpCabin = _cabinClass;
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    20,
                                    16,
                                    20,
                                    16 + MediaQuery.paddingOf(context).bottom,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Travellers & Cabin Class',
                                            style: textTheme.titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme.onSurface,
                                                ),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            icon: Icon(
                                              Icons.close_rounded,
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Adults',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurface,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (tmpAdults > 1) {
                                                setModalState(
                                                  () => tmpAdults--,
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.remove_circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$tmpAdults Adult${tmpAdults > 1 ? "s" : ""}',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Cabin Class',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurface,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        children: [
                                          for (final label in const [
                                            'Economy',
                                            'Premium Economy',
                                            'Business',
                                            'First',
                                          ])
                                            ChoiceChip(
                                              label: Text(label),
                                              selected: tmpCabin == label,
                                              onSelected: (_) {
                                                setModalState(
                                                  () => tmpCabin = label,
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 48,
                                        child: FilledButton(
                                          onPressed: () {
                                            Navigator.of(context).pop((
                                              adults: tmpAdults,
                                              cabinClass: tmpCabin,
                                            ));
                                          },
                                          child: const Text('Done'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                    if (result != null && mounted) {
                      setState(() {
                        _adults = result.adults;
                        _cabinClass = result.cabinClass;
                      });
                    }
                  },
                  onSearchPressed: () async {
                    final api = ref.read(flightApiServiceProvider);

                    final departureDateStr = _departureDate
                        .toIso8601String()
                        .split('T')
                        .first;

                    try {
                      final flights = await api.searchOneWay(
                        fromCode: from.code,
                        toCode: to.code,
                        departureDate: departureDateStr,
                        adults: _adults,
                      );
                      if (!mounted) return;
                      ref.read(flightResultsProvider.notifier).state = flights;
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Could not fetch live flights. Showing demo data instead.',
                          ),
                        ),
                      );
                      ref
                          .read(flightResultsProvider.notifier)
                          .state = FlightSearchService.getFallbackFlights(
                        fromCode: from.code,
                        toCode: to.code,
                        fromCity: from.cityName,
                        toCity: to.cityName,
                      );
                    }

                    if (!mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FlightSearchResultsPage(
                          fromCode: from.code,
                          fromCity: from.cityName,
                          toCode: to.code,
                          toCity: to.cityName,
                          departureDate: _departureDate,
                          adults: _adults,
                          travellersLabel:
                              '$_adults Adult${_adults > 1 ? "s" : ""}',
                          cabinLabel: _cabinClass,
                        ),
                      ),
                    );
                  },
                  oneWay: _oneWay,
                  onOneWayChanged: (v) => setState(() => _oneWay = v),
                  specialFareIndex: _specialFareIndex,
                  onSpecialFareTap: (i) =>
                      setState(() => _specialFareIndex = i),
                  nonStopOnly: _nonStopOnly,
                  onNonStopChanged: (v) => setState(() => _nonStopOnly = v),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                FlightSectionTitle(
                  title: 'Destination of the Week: Malaysia',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                FlightDestinationWeekRow(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                FlightSectionTitle(
                  title: 'Long Weekend Getaways',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                FlightLongWeekendRow(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                FlightSectionTitle(
                  title: 'Bank Offers',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                FlightBankOffersRow(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                FlightCricketFeverBanner(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                FlightSectionTitle(
                  title: 'Exotic places now Visa-free',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                FlightVisaFreeRow(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                FlightSectionTitle(
                  title: 'Recent Searches',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                FlightRecentSearchesRow(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          TravelBottomNav(
            selectedIndex: _bottomNavIndex,
            onTap: (i) {
              if (i == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FlightMyBookingsPage(),
                  ),
                );
                return;
              }
              setState(() => _bottomNavIndex = i);
            },
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }
}
