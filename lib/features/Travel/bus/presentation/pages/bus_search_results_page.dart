import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/models/bus_list_data.dart';
import '../widgets/bus_filter_chip.dart';
import '../widgets/bus_result_card.dart';
import 'bus_filter_by_page.dart';

/// Bus search results page: route header, date, Filters/Sort/AI Filters/Departure chips,
/// summary bar (X Buses found, Starting from ₹X), and list of bus cards.
class BusSearchResultsPage extends StatefulWidget {
  const BusSearchResultsPage({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.dateLabel,
  });

  final String fromCity;
  final String toCity;
  final String dateLabel;

  @override
  State<BusSearchResultsPage> createState() => _BusSearchResultsPageState();
}

class _BusSearchResultsPageState extends State<BusSearchResultsPage> {
  BusSortOption _sortOption = BusSortOption.recommended;
  bool _aiFiltersActive = false;
  List<BusResultItem> _buses = List.from(busSearchResults);

  void _sortBuses() {
    final list = List<BusResultItem>.from(_buses);
    switch (_sortOption) {
      case BusSortOption.recommended:
      case BusSortOption.mostPopular:
        break;
      case BusSortOption.cheapest:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case BusSortOption.bestRated:
        list.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case BusSortOption.earlyDeparture:
        list.sort((a, b) => a.departureTime.compareTo(b.departureTime));
        break;
      case BusSortOption.lateDeparture:
        list.sort((a, b) => b.departureTime.compareTo(a.departureTime));
        break;
    }
    setState(() => _buses = list);
  }

  void _openFilterBy() async {
    final result = await Navigator.of(context).push<BusSortOption>(
      MaterialPageRoute(
        builder: (context) => BusFilterByPage(
          initialSortOption: _sortOption,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _sortOption = result;
        _sortBuses();
      });
    }
  }

  String _sortChipLabel() {
    return switch (_sortOption) {
      BusSortOption.recommended => 'Recommended',
      BusSortOption.mostPopular => 'Most Popular',
      BusSortOption.cheapest => 'Cheapest',
      BusSortOption.bestRated => 'Best Rated',
      BusSortOption.earlyDeparture => 'Early Departure',
      BusSortOption.lateDeparture => 'Late Departure',
    };
  }

  int get _minPrice =>
      _buses.isEmpty
          ? 0
          : _buses.map((e) => e.price).reduce((a, b) => a < b ? a : b);

  String _formatPrice(int price) {
    final s = price.toString();
    if (s.length <= 3) return '₹$s';
    final buf = StringBuffer();
    var i = 0;
    final len = s.length;
    while (i < len) {
      if (i > 0) buf.write(',');
      final end = i + 3 > len ? len : i + 3;
      buf.write(s.substring(i, end));
      i = end;
    }
    return '₹${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    '${widget.fromCity} - ${widget.toCity}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.edit_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
              ],
            ),
            Text(
              widget.dateLabel,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                BusFilterChipWidget(
                  icon: Icons.tune_rounded,
                  label: 'Filters',
                  selected: false,
                  onTap: _openFilterBy,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                BusFilterChipWidget(
                  icon: Icons.keyboard_arrow_down_rounded,
                  label: _sortChipLabel(),
                  selected: true,
                  onTap: _openFilterBy,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                BusFilterChipWidget(
                  icon: Icons.auto_awesome_rounded,
                  label: 'AI Filters',
                  selected: false,
                  borderColor: AppColors.accentOrange,
                  onTap: () =>
                      setState(() => _aiFiltersActive = !_aiFiltersActive),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                BusFilterChipWidget(
                  label: 'Departure',
                  selected: false,
                  onTap: () {},
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.directions_bus_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  '${_buses.length} Buses found, Starting from ${_formatPrice(_minPrice)}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: _buses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => BusResultCard(
                bus: _buses[i],
                colorScheme: colorScheme,
                textTheme: textTheme,
                formatPrice: _formatPrice,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
