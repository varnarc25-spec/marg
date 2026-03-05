import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/bus_list_data.dart';
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
      _buses.isEmpty ? 0 : _buses.map((e) => e.price).reduce((a, b) => a < b ? a : b);

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
          // Filter / Sort / AI Filters / Departure chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _FilterChip(
                  icon: Icons.tune_rounded,
                  label: 'Filters',
                  selected: false,
                  onTap: _openFilterBy,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  icon: Icons.keyboard_arrow_down_rounded,
                  label: _sortChipLabel(),
                  selected: true,
                  onTap: _openFilterBy,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  icon: Icons.auto_awesome_rounded,
                  label: 'AI Filters',
                  selected: false,
                  borderColor: AppColors.accentOrange,
                  onTap: () => setState(() => _aiFiltersActive = !_aiFiltersActive),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  icon: null,
                  label: 'Departure',
                  selected: false,
                  onTap: () {},
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),
          // Summary bar: X Buses found, Starting from ₹X
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
          // Bus list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: _buses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _BusResultCard(
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
    this.icon,
    this.borderColor,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final IconData? icon;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? colorScheme.primary.withValues(alpha: 0.15)
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
              color: borderColor ??
                  (selected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3)),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: borderColor ?? (selected ? colorScheme.primary : colorScheme.onSurface),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: borderColor ?? (selected ? colorScheme.primary : colorScheme.onSurface),
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

class _BusResultCard extends StatelessWidget {
  const _BusResultCard({
    required this.bus,
    required this.colorScheme,
    required this.textTheme,
    required this.formatPrice,
  });

  final BusResultItem bus;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final String Function(int) formatPrice;

  @override
  Widget build(BuildContext context) {
    final hasOperatorBlock = bus.busesAvailable != null;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Operator icon placeholder
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.directions_bus_rounded,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bus.operatorName,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (hasOperatorBlock) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${bus.busesAvailable} Buses Available',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'View All',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (bus.discountTag != null) ...[
                        const SizedBox(height: 6),
                        _DiscountChip(
                          label: bus.discountTag!,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                          isGreen: true,
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  formatPrice(bus.price),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            if (!hasOperatorBlock) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  if (bus.rating != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, size: 14, color: AppColors.accentGreen),
                          const SizedBox(width: 4),
                          Text(
                            bus.rating!.toStringAsFixed(1),
                            style: textTheme.labelMedium?.copyWith(
                              color: AppColors.accentGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      bus.busType,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (bus.extraDiscountTag != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        bus.extraDiscountTag!,
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${bus.departureTime} - ${bus.arrivalTime}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '(${bus.duration})',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${bus.seatsLeft} Seats Left',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Bus Details',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(20),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.add_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            if (hasOperatorBlock) ...[
              const SizedBox(height: 8),
              Text(
                formatPrice(bus.price),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DiscountChip extends StatelessWidget {
  const _DiscountChip({
    required this.label,
    required this.colorScheme,
    required this.textTheme,
    this.isGreen = false,
  });

  final String label;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool isGreen;

  @override
  Widget build(BuildContext context) {
    final color = isGreen ? AppColors.accentGreen : colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.percent_rounded, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
