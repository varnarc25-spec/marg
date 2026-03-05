import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/train_list_data.dart';
import 'train_travel_details_page.dart';

/// Train search results page: route header, date strip (MAR + Available),
/// Filter/Sort/AI Filters/Type/Gen, Aadhaar banner, train cards with class chips,
/// Nearby Stations, and Sort By bottom sheet. Matches design from screenshots.
class TrainSearchResultsPage extends StatefulWidget {
  const TrainSearchResultsPage({
    super.key,
    required this.fromCode,
    required this.fromName,
    required this.toCode,
    required this.toName,
    required this.dateLabel,
  });

  final String fromCode;
  final String fromName;
  final String toCode;
  final String toName;
  final String dateLabel;

  @override
  State<TrainSearchResultsPage> createState() => _TrainSearchResultsPageState();
}

class _TrainSearchResultsPageState extends State<TrainSearchResultsPage> {
  TrainSortOption _sortOption = TrainSortOption.recommended;
  List<TrainResultItem> _trains = List.from(trainSearchResults);
  int _selectedDateIndex = 0;

  void _sortTrains() {
    final list = List<TrainResultItem>.from(_trains);
    switch (_sortOption) {
      case TrainSortOption.recommended:
        break;
      case TrainSortOption.availability:
        list.sort((a, b) {
          final aAvail = a.classOptions.any((c) => c.seatsAvailable);
          final bAvail = b.classOptions.any((c) => c.seatsAvailable);
          if (aAvail == bAvail) return 0;
          return aAvail ? -1 : 1;
        });
        break;
      case TrainSortOption.fastest:
        list.sort((a, b) => a.duration.compareTo(b.duration));
        break;
      case TrainSortOption.earlyDeparture:
        list.sort((a, b) => a.departureTime.compareTo(b.departureTime));
        break;
      case TrainSortOption.lateDeparture:
        list.sort((a, b) => b.departureTime.compareTo(a.departureTime));
        break;
      case TrainSortOption.earlyArrival:
        list.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
        break;
      case TrainSortOption.lateArrival:
        list.sort((a, b) => b.arrivalTime.compareTo(a.arrivalTime));
        break;
    }
    setState(() => _trains = list);
  }

  void _openSortBy() async {
    final result = await showModalBottomSheet<TrainSortOption>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _SortByBottomSheet(
        selected: _sortOption,
        onSelect: (v) => Navigator.of(context).pop(v),
        onClose: () => Navigator.of(context).pop(),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _sortOption = result;
        _sortTrains();
      });
    }
  }

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
              children: [
                Expanded(
                  child: Text(
                    '(${widget.fromCode}) ${widget.fromName} - (${widget.toCode}) ${widget.toName}',
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
                  size: 20,
                  color: colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 2),
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
          // Date strip: MAR | 03 Tue Available, 04 Wed Available, ...
          _DateStrip(
            selectedIndex: _selectedDateIndex,
            onSelect: (i) => setState(() => _selectedDateIndex = i),
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          // Filter bar: Filter, Sort, AI Filters, Type, Gen
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _FilterChip(
                  icon: Icons.tune_rounded,
                  label: 'Filter',
                  selected: false,
                  onTap: () {},
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  icon: Icons.keyboard_arrow_down_rounded,
                  label: 'Sort',
                  selected: true,
                  onTap: _openSortBy,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  icon: Icons.auto_awesome_rounded,
                  label: 'AI Filters',
                  selected: true,
                  accentColor: AppColors.accentOrange,
                  onTap: () {},
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  icon: Icons.keyboard_arrow_down_rounded,
                  label: 'Type',
                  selected: false,
                  onTap: () {},
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  icon: null,
                  label: 'Gen',
                  selected: false,
                  onTap: () {},
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),
          // Aadhaar banner
          _AadhaarBanner(
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          // Train list + Nearby Stations
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                ...List.generate(_trains.length, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _TrainResultCard(
                    train: _trains[i],
                    fromStation: widget.fromName,
                    toStation: widget.toName,
                    fromCode: widget.fromCode,
                    toCode: widget.toCode,
                    dateLabel: widget.dateLabel,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    formatPrice: _formatPrice,
                  ),
                )),
                const SizedBox(height: 8),
                _SectionTitle(
                  'Nearby Stations',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 4),
                Text(
                  'Stations closest to your destination',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(trainNearbyStations.length, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _NearbyStationCard(
                    nearby: trainNearbyStations[i],
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                )),
                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    label: Text(
                      'View 3 more',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(
    this.title, {
    required this.textTheme,
    required this.colorScheme,
  });

  final String title;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
  }
}

class _DateStrip extends StatelessWidget {
  const _DateStrip({
    required this.selectedIndex,
    required this.onSelect,
    required this.colorScheme,
    required this.textTheme,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                'MAR',
                style: textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(trainResultDateStrip.length, (i) {
                  final label = trainResultDateStrip[i];
                  final selected = i == selectedIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: InkWell(
                      onTap: () => onSelect(i),
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Available',
                            style: textTheme.labelSmall?.copyWith(
                              color: selected
                                  ? colorScheme.primary
                                  : AppColors.accentGreen,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 3,
                            width: selected ? 40 : 0,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
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
    this.accentColor,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final IconData? icon;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final useAccent = accentColor != null;
    final borderColor = useAccent
        ? accentColor!
        : (selected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3));
    final textColor = useAccent
        ? accentColor!
        : (selected ? colorScheme.primary : colorScheme.onSurface);

    return Material(
      color: useAccent
          ? accentColor!.withValues(alpha: 0.12)
          : (selected
              ? colorScheme.primary.withValues(alpha: 0.15)
              : colorScheme.surface),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: textColor,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: textColor,
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

class _AadhaarBanner extends StatelessWidget {
  const _AadhaarBanner({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.fingerprint_rounded,
                    color: AppColors.accentRed.withValues(alpha: 0.8),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Link your Aadhaar to IRCTC ID to book Tatkal tickets',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'FREE Cancel',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrainResultCard extends StatelessWidget {
  const _TrainResultCard({
    required this.train,
    required this.fromStation,
    required this.toStation,
    required this.fromCode,
    required this.toCode,
    required this.dateLabel,
    required this.colorScheme,
    required this.textTheme,
    required this.formatPrice,
  });

  final TrainResultItem train;
  final String fromStation;
  final String toStation;
  final String fromCode;
  final String toCode;
  final String dateLabel;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final String Function(int) formatPrice;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Train name & number
            Text(
              '${train.trainName} (${train.trainNumber})',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  train.runningDays,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Train Route',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Departure | duration | Arrival
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${train.departureTime}, ${train.departureDate}',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        train.departureStation,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    children: [
                      Text(
                        train.duration,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${train.arrivalDate}, ${train.arrivalTime}',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        train.arrivalStation,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Class chips: SL ₹180 Departed 2hrs ago (red) or Seats available (green) - tap to book
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: train.classOptions.map((c) {
                if (c.departed) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentRed.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.accentRed.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${c.classCode} Departed',
                              style: textTheme.labelMedium?.copyWith(
                                color: AppColors.accentRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              formatPrice(c.price),
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.textSecondary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        if (c.departedAgo != null)
                          Text(
                            c.departedAgo!,
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.accentRed,
                            ),
                          ),
                      ],
                    ),
                  );
                }
                final canBook = c.seatsAvailable;
                final chipContent = Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${c.classCode} ${formatPrice(c.price)}',
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (c.seatsAvailable)
                        Text(
                          'Seats available',
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.accentGreen,
                          ),
                        ),
                    ],
                  ),
                );
                if (canBook) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TrainTravelDetailsPage(
                            train: train,
                            selectedClass: c,
                            fromCode: fromCode,
                            fromName: fromStation,
                            toCode: toCode,
                            toName: toStation,
                            dateLabel: dateLabel,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: chipContent,
                  );
                }
                return chipContent;
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NearbyStationCard extends StatelessWidget {
  const _NearbyStationCard({
    required this.nearby,
    required this.colorScheme,
    required this.textTheme,
  });

  final TrainNearbyStation nearby;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 18,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${nearby.sourceName} (${nearby.sourceCode})',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nearby.sourceLabel,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.remove_rounded,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 18,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                '${nearby.nearbyName}... (${nearby.nearbyCode})',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          nearby.distanceLabel,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${nearby.trainsOnRoute} trains on this route',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (nearby.seatsAvailable)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Seats available',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.accentGreen,
                          fontWeight: FontWeight.w600,
                        ),
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

/// Sort By bottom sheet with radio options.
class _SortByBottomSheet extends StatelessWidget {
  const _SortByBottomSheet({
    required this.selected,
    required this.onSelect,
    required this.onClose,
  });

  final TrainSortOption selected;
  final ValueChanged<TrainSortOption> onSelect;
  final VoidCallback onClose;

  static const _labels = {
    TrainSortOption.recommended: 'Recommended',
    TrainSortOption.availability: 'Availability',
    TrainSortOption.fastest: 'Fastest',
    TrainSortOption.earlyDeparture: 'Early Departure',
    TrainSortOption.lateDeparture: 'Late Departure',
    TrainSortOption.earlyArrival: 'Early Arrival',
    TrainSortOption.lateArrival: 'Late Arrival',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Text(
                    'Sort By',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.8),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onClose,
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.close_rounded, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.2)),
            ...TrainSortOption.values.map((option) {
              final isSelected = selected == option;
              return InkWell(
                onTap: () => onSelect(option),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Radio<TrainSortOption>(
                        value: option,
                        groupValue: selected,
                        onChanged: (v) {
                          if (v != null) onSelect(v);
                        },
                        activeColor: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _labels[option] ?? option.name,
                        style: textTheme.bodyLarge?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 8),
          ],
        ),
      ),
    );
  }
}
