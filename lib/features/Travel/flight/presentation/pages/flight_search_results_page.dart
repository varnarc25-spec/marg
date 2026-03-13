import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/flight_list_data.dart';
import '../../data/flight_result_model.dart';
import '../providers/flight_search_provider.dart';
import 'flight_detail_sheet.dart';

/// Flight search results page: route header, date/fare strip, filters, sort, flight list.
/// Uses app theme colors and widgets. Data from flight_list_data and flight_results_provider (bike insurance structure).
class FlightSearchResultsPage extends ConsumerStatefulWidget {
  const FlightSearchResultsPage({
    super.key,
    required this.fromCode,
    required this.fromCity,
    required this.toCode,
    required this.toCity,
    this.dateLabel = 'Tue, 10 Mar',
    this.travellersLabel = '1 Traveller',
    this.cabinLabel = 'Economy',
  });

  final String fromCode;
  final String fromCity;
  final String toCode;
  final String toCity;
  final String dateLabel;
  final String travellersLabel;
  final String cabinLabel;

  @override
  ConsumerState<FlightSearchResultsPage> createState() =>
      _FlightSearchResultsPageState();
}

class _FlightSearchResultsPageState
    extends ConsumerState<FlightSearchResultsPage> {
  int _selectedDateIndex = 2; // 10 Tue
  FlightSortOption _sortOption = FlightSortOption.cheapest;
  bool _aiFiltersActive = false;
  bool _nonStopOnly = false;

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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal,
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
              '${widget.dateLabel} • ${widget.travellersLabel} • ${widget.cabinLabel}',
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
          _DateFareStrip(
            dates: flightDateFares,
            selectedIndex: _selectedDateIndex,
            onSelect: (i) => setState(() => _selectedDateIndex = i),
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          _FilterSortBar(
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
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: flights.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _FlightResultCard(
                flight: flights[i],
                colorScheme: colorScheme,
                textTheme: textTheme,
                onTap: () {
                  showFlightDetailSheet(
                    context,
                    flight: flights[i],
                    dateLabel: widget.dateLabel,
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

class _DateFareStrip extends StatelessWidget {
  const _DateFareStrip({
    required this.dates,
    required this.selectedIndex,
    required this.onSelect,
    required this.colorScheme,
    required this.textTheme,
  });

  final List<FlightDateFare> dates;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  String _formatPrice(int price) {
    final s = price.toString();
    if (s.length <= 3) return '₹$s';
    final parts = <String>[];
    parts.add(s.substring(s.length - 3));
    var i = s.length - 3;
    while (i > 0) {
      final end = i;
      final start = i - 2 >= 0 ? i - 2 : 0;
      parts.insert(0, s.substring(start, end));
      i -= 2;
    }
    return '₹${parts.join(',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 10),
              child: Text(
                'MAR',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Material(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'All Fares',
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ...List.generate(dates.length, (i) {
              final d = dates[i];
              final selected = i == selectedIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Material(
                  color: selected
                      ? colorScheme.primary.withValues(alpha: 0.15)
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => onSelect(i),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: selected
                            ? Border.all(color: colorScheme.primary, width: 1.5)
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${d.day} ${d.weekday}',
                            style: textTheme.labelMedium?.copyWith(
                              color: selected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatPrice(d.price),
                            style: textTheme.labelSmall?.copyWith(
                              color: selected
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FilterSortBar extends StatelessWidget {
  const _FilterSortBar({
    required this.sortLabel,
    required this.onSortTap,
    required this.aiFiltersActive,
    required this.onAiFiltersTap,
    required this.nonStopOnly,
    required this.onNonStopTap,
    required this.onFiltersTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final String sortLabel;
  final VoidCallback onSortTap;
  final bool aiFiltersActive;
  final VoidCallback onAiFiltersTap;
  final bool nonStopOnly;
  final VoidCallback onNonStopTap;
  final VoidCallback onFiltersTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _FilterChip(
            icon: Icons.tune_rounded,
            label: 'Filters',
            onTap: onFiltersTap,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            icon: Icons.keyboard_arrow_down_rounded,
            label: sortLabel,
            onTap: onSortTap,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            icon: Icons.auto_awesome_rounded,
            label: 'AI Filters',
            selected: aiFiltersActive,
            onTap: onAiFiltersTap,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            icon: Icons.flight_rounded,
            label: 'Non-Stop',
            selected: nonStopOnly,
            onTap: onNonStopTap,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.icon,
    required this.label,
    this.selected = false,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? colorScheme.primary.withValues(alpha: 0.12)
          : colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: selected ? colorScheme.primary : colorScheme.onSurface,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlightResultCard extends StatelessWidget {
  const _FlightResultCard({
    required this.flight,
    required this.colorScheme,
    required this.textTheme,
    this.onTap,
  });

  final FlightResultItem flight;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback? onTap;

  String _formatPrice(int price) {
    final s = price.toString();
    if (s.length <= 3) return '₹$s';
    final parts = <String>[];
    parts.add(s.substring(s.length - 3));
    var i = s.length - 3;
    while (i > 0) {
      final end = i;
      final start = i - 2 >= 0 ? i - 2 : 0;
      parts.insert(0, s.substring(start, end));
      i -= 2;
    }
    return '₹${parts.join(',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flight_rounded,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${flight.airlineName} • ${flight.flightNumbers}',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.departureTime,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        flight.departureCity,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        flight.duration,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1,
                            width: 40,
                            decoration: BoxDecoration(
                              color: colorScheme.outline.withValues(alpha: 0.4),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.flight_rounded,
                              size: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Container(
                            height: 1,
                            width: 40,
                            decoration: BoxDecoration(
                              color: colorScheme.outline.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        flight.stops,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        flight.arrivalNextDay
                            ? '+1d ${flight.arrivalTime}'
                            : flight.arrivalTime,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        flight.arrivalCity,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (flight.layoverText != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.circle, size: 6, color: AppColors.accentOrange),
                  const SizedBox(width: 6),
                  Text(
                    flight.layoverText!,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
            if (flight.offerText != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  flight.offerText!,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.accentGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _formatPrice(flight.price),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}
