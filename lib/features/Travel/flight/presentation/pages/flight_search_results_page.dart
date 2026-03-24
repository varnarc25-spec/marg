import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/flight_list_data.dart';
import '../../data/models/flight_result_model.dart';
import '../../data/services/flight_search_service.dart';
import '../providers/flight_search_provider.dart';
import '../widgets/flight_date_fare_strip.dart';
import '../widgets/flight_detail_sheet.dart';
import '../widgets/flight_filter_sort_bar.dart';
import '../widgets/flight_result_card.dart';

class FlightSearchResultsPage extends ConsumerStatefulWidget {
  const FlightSearchResultsPage({
    super.key,
    required this.fromCode,
    required this.fromCity,
    required this.toCode,
    required this.toCity,
    required this.departureDate,
    this.travellersLabel = '1 Traveller',
    this.cabinLabel = 'Economy',
    this.adults = 1,
  });

  final String fromCode;
  final String fromCity;
  final String toCode;
  final String toCity;
  final DateTime departureDate;
  final String travellersLabel;
  final String cabinLabel;
  final int adults;

  @override
  ConsumerState<FlightSearchResultsPage> createState() =>
      _FlightSearchResultsPageState();
}

class _FlightSearchResultsPageState
    extends ConsumerState<FlightSearchResultsPage> {
  late DateTime _selectedDate;
  late List<FlightDateFare> _dateFares;
  late int _selectedDateIndex;
  FlightSortOption _sortOption = FlightSortOption.cheapest;
  bool _aiFiltersActive = false;
  bool _nonStopOnly = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.departureDate;
    _rebuildDateStrip();
  }

  void _rebuildDateStrip() {
    final result = generateDateStrip(_selectedDate);
    _dateFares = result.dates;
    _selectedDateIndex = result.selectedIndex;
  }

  String get _dateLabel {
    final d = _selectedDate;
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  List<FlightResultItem> get _flights {
    final list = List<FlightResultItem>.from(ref.watch(flightResultsProvider));
    switch (_sortOption) {
      case FlightSortOption.cheapest:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case FlightSortOption.earlyDeparture:
        list.sort((a, b) => a.departureTime.compareTo(b.departureTime));
        break;
      case FlightSortOption.earlyArrival:
        list.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
        break;
      case FlightSortOption.lateDeparture:
        list.sort((a, b) => b.departureTime.compareTo(a.departureTime));
        break;
      case FlightSortOption.lateArrival:
        list.sort((a, b) => b.arrivalTime.compareTo(a.arrivalTime));
        break;
      case FlightSortOption.fastest:
        list.sort((a, b) => a.duration.compareTo(b.duration));
        break;
    }
    return list;
  }

  Future<void> _fetchFlightsForDate(DateTime date) async {
    setState(() {
      _selectedDate = date;
      _loading = true;
      _rebuildDateStrip();
    });

    final api = ref.read(flightApiServiceProvider);
    final departureStr = date.toIso8601String().split('T').first;

    try {
      final flights = await api.searchOneWay(
        fromCode: widget.fromCode,
        toCode: widget.toCode,
        departureDate: departureStr,
        adults: widget.adults,
      );
      if (!mounted) return;
      ref.read(flightResultsProvider.notifier).state = flights;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not fetch live flights. Showing demo data instead.',
          ),
        ),
      );
      ref.read(flightResultsProvider.notifier).state =
          FlightSearchService.getFallbackFlights(
        fromCode: widget.fromCode,
        toCode: widget.toCode,
        fromCity: widget.fromCity,
        toCity: widget.toCity,
      );
    }

    if (mounted) setState(() => _loading = false);
  }

  void _showSortBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final textTheme = theme.textTheme;
        final maxHeight = MediaQuery.sizeOf(context).height * 0.6;
        return Container(
          height: maxHeight,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sort By',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    0,
                    24,
                    24 + MediaQuery.paddingOf(context).bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: FlightSortOption.values.map((option) {
                      final label = switch (option) {
                        FlightSortOption.cheapest => 'Cheapest',
                        FlightSortOption.earlyDeparture => 'Early Departure',
                        FlightSortOption.earlyArrival => 'Early Arrival',
                        FlightSortOption.lateDeparture => 'Late Departure',
                        FlightSortOption.lateArrival => 'Late Arrival',
                        FlightSortOption.fastest => 'Fastest',
                      };
                      final selected = _sortOption == option;
                      return RadioListTile<FlightSortOption>(
                        value: option,
                        groupValue: _sortOption,
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => _sortOption = v);
                            Navigator.pop(context);
                          }
                        },
                        title: Text(
                          label,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        activeColor: colorScheme.primary,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final flights = _flights;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.fromCity} (${widget.fromCode}) - ${widget.toCity} (${widget.toCode})',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '$_dateLabel • ${widget.travellersLabel} • ${widget.cabinLabel}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_rounded,
              size: 22,
              color: colorScheme.primary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FlightDateFareStrip(
            dates: _dateFares,
            selectedIndex: _selectedDateIndex,
            onSelect: (i) {
              final tappedDate = _dateFares[i].date;
              if (tappedDate == _selectedDate) return;
              _fetchFlightsForDate(tappedDate);
            },
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          FlightFilterSortBar(
            sortLabel: _sortOption == FlightSortOption.cheapest
                ? 'Cheapest'
                : 'Sort',
            onSortTap: _showSortBottomSheet,
            aiFiltersActive: _aiFiltersActive,
            onAiFiltersTap: () =>
                setState(() => _aiFiltersActive = !_aiFiltersActive),
            nonStopOnly: _nonStopOnly,
            onNonStopTap: () => setState(() => _nonStopOnly = !_nonStopOnly),
            onFiltersTap: () {},
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          Expanded(
            child: _loading
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Searching flights…',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : flights.isEmpty
                    ? Center(
                        child: Text(
                          'No flights found for this date.',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: flights.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) => FlightResultCard(
                          flight: flights[i],
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                          onTap: () {
                            showFlightDetailSheet(
                              context,
                              flight: flights[i],
                              dateLabel: _dateLabel,
                              route:
                                  '${widget.fromCity} - ${widget.toCity}',
                              fromCode: widget.fromCode,
                              toCode: widget.toCode,
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
