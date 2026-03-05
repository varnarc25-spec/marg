import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/train_list_data.dart';
import '../../data/train_station_model.dart';
import '../providers/train_search_provider.dart';
import 'train_station_search_page.dart';
import 'train_search_results_page.dart';
import '../../../bus/presentation/pages/travel_bookings_page.dart';

/// Train travel home page: app bar, search card (From/To stations, date, class, refund),
/// recent searches, popular services, Tatkal banner, explore feature, calendar, travel blogs,
/// PNR banner, bottom nav. Same structure as bus/flight; uses app theme and providers.
class TravelTrainPage extends ConsumerStatefulWidget {
  const TravelTrainPage({super.key});

  @override
  ConsumerState<TravelTrainPage> createState() => _TravelTrainPageState();
}

class _TravelTrainPageState extends ConsumerState<TravelTrainPage> {
  int _selectedDateIndex = 0; // Today
  int _classIndex = 0; // AC & non-AC
  bool _refund100 = false;
  int _bottomNavIndex = 0; // My Bookings

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final from = ref.watch(trainFromProvider);
    final to = ref.watch(trainToProvider);

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
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                90 + MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                const SizedBox(height: 12),
                _TrainSearchCard(
                  fromCode: from.stationCode,
                  fromName: from.stationName,
                  toCode: to.stationCode,
                  toName: to.stationName,
                  onFromTap: () async {
                    final result =
                        await Navigator.of(context).push<TrainStationSearchResult>(
                      MaterialPageRoute(
                        builder: (context) => TrainStationSearchPage(
                          initialFromCode: from.stationCode,
                          initialFromName: from.stationName,
                          initialToCode: to.stationCode,
                          initialToName: to.stationName,
                          selectingFrom: true,
                        ),
                      ),
                    );
                    if (result != null && mounted) {
                      ref.read(trainFromProvider.notifier).state =
                          TrainStationResult(
                        stationCode: result.stationCode,
                        stationName: result.stationName,
                      );
                    }
                  },
                  onToTap: () async {
                    final result =
                        await Navigator.of(context).push<TrainStationSearchResult>(
                      MaterialPageRoute(
                        builder: (context) => TrainStationSearchPage(
                          initialFromCode: from.stationCode,
                          initialFromName: from.stationName,
                          initialToCode: to.stationCode,
                          initialToName: to.stationName,
                          selectingFrom: false,
                        ),
                      ),
                    );
                    if (result != null && mounted) {
                      ref.read(trainToProvider.notifier).state =
                          TrainStationResult(
                        stationCode: result.stationCode,
                        stationName: result.stationName,
                      );
                    }
                  },
                  onSwap: () {
                    final f = ref.read(trainFromProvider);
                    final t = ref.read(trainToProvider);
                    ref.read(trainFromProvider.notifier).state = t;
                    ref.read(trainToProvider.notifier).state = f;
                  },
                  selectedDateIndex: _selectedDateIndex,
                  onDateTap: (i) => setState(() => _selectedDateIndex = i),
                  classIndex: _classIndex,
                  onClassTap: (i) => setState(() => _classIndex = i),
                  refund100: _refund100,
                  onRefundChanged: (v) => setState(() => _refund100 = v),
                  onSearchPressed: () {
                    final date = trainDepartureDates[_selectedDateIndex];
                    final dateLabel = '${date.weekday}, ${date.day} Mar';
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TrainSearchResultsPage(
                          fromCode: from.stationCode,
                          fromName: from.stationName,
                          toCode: to.stationCode,
                          toName: to.stationName,
                          dateLabel: dateLabel,
                        ),
                      ),
                    );
                  },
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  'Recent Searches',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                _RecentSearchesRow(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  'Popular Services',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 12),
                _PopularServicesGrid(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                _TatkalBanner(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  'Explore features to get Seat Assurance',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                _SeatAssuranceBanner(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                _LongWeekendBanner(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  'Travel Blogs',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                _TravelBlogsRow(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                _PnrBanner(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          _TrainBottomNav(
            selectedIndex: _bottomNavIndex,
            onTap: (i) {
              if (i == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TravelBookingsPage(),
                  ),
                );
              } else {
                setState(() => _bottomNavIndex = i);
              }
            },
            colorScheme: colorScheme,
            textTheme: textTheme,
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

class _TrainSearchCard extends StatelessWidget {
  const _TrainSearchCard({
    required this.fromCode,
    required this.fromName,
    required this.toCode,
    required this.toName,
    required this.onFromTap,
    required this.onToTap,
    required this.onSwap,
    required this.selectedDateIndex,
    required this.onDateTap,
    required this.classIndex,
    required this.onClassTap,
    required this.refund100,
    required this.onRefundChanged,
    required this.onSearchPressed,
    required this.colorScheme,
    required this.textTheme,
  });

  final String fromCode;
  final String fromName;
  final String toCode;
  final String toName;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final VoidCallback onSwap;
  final int selectedDateIndex;
  final ValueChanged<int> onDateTap;
  final int classIndex;
  final ValueChanged<int> onClassTap;
  final bool refund100;
  final ValueChanged<bool> onRefundChanged;
  final VoidCallback onSearchPressed;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  static const List<String> _classLabels = [
    'AC & non-AC',
    'AC only',
    'Non-AC only',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // From
            InkWell(
              onTap: onFromTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.trip_origin_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        fromCode,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      fromName,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 28),
                IconButton(
                  onPressed: onSwap,
                  icon: Icon(
                    Icons.swap_vert_rounded,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
            // To
            InkWell(
              onTap: onToTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        toCode,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      toName,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select Departure date',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 56,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: trainDepartureDates.length + 1,
                itemBuilder: (context, i) {
                  if (i == trainDepartureDates.length) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Material(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.outline.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 20,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Calendar',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  final d = trainDepartureDates[i];
                  final selected = i == selectedDateIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Material(
                      color: selected
                          ? colorScheme.primary.withValues(alpha: 0.15)
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => onDateTap(i),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: selected
                                ? Border.all(color: colorScheme.primary)
                                : Border.all(
                                    color: colorScheme.outline
                                        .withValues(alpha: 0.3),
                                  ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (d.tag != null)
                                Text(
                                  d.tag!,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: AppColors.accentGreen,
                                  ),
                                ),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Class',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(_classLabels.length, (i) {
                final selected = classIndex == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_classLabels[i]),
                    selected: selected,
                    onSelected: (_) => onClassTap(i),
                    selectedColor: colorScheme.primary.withValues(alpha: 0.15),
                    checkmarkColor: colorScheme.primary,
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  height: 24,
                  child: Checkbox(
                    value: refund100,
                    onChanged: (v) => onRefundChanged(v ?? false),
                    activeColor: colorScheme.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                Expanded(
                  child: Text(
                    'I want 100% refund on my ticket',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'T&C',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'FREE Cancellation',
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: onSearchPressed,
                child: const Text('Search Trains'),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'IRCTC Authorised Partner',
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentSearchesRow extends StatelessWidget {
  const _RecentSearchesRow({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: trainRecentSearches.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final r = trainRecentSearches[i];
          return SizedBox(
            width: 120,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (r.available)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Available',
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.accentGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (r.available) const SizedBox(height: 6),
                    Text(
                      '${r.fromCode} - ${r.toCode}',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      r.dateLabel,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PopularServicesGrid extends StatelessWidget {
  const _PopularServicesGrid({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: trainPopularServices.length,
      itemBuilder: (context, i) {
        final s = trainPopularServices[i];
        return Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(s.icon, size: 28, color: colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Text(
              s.label,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}

class _TatkalBanner extends StatelessWidget {
  const _TatkalBanner({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withValues(alpha: 0.25),
              colorScheme.primary.withValues(alpha: 0.12),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tatkal tickets in just 3 steps →',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _TatkalStep(
                  step: 1,
                  label: 'Enter journey details',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                _TatkalStep(
                  step: 2,
                  label: 'Enter traveller details',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                _TatkalStep(
                  step: 3,
                  label: 'Make payment',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TatkalStep extends StatelessWidget {
  const _TatkalStep({
    required this.step,
    required this.label,
    required this.colorScheme,
    required this.textTheme,
  });

  final int step;
  final String label;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.accentOrange.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: colorScheme.onSurface,
              child: Text(
                '$step',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.surface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SeatAssuranceBanner extends StatelessWidget {
  const _SeatAssuranceBanner({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withValues(alpha: 0.2),
              colorScheme.primary.withValues(alpha: 0.08),
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Ticket ASSURE',
                    style: textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.train_rounded,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Nearby Train Station',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Get Nearby Train Station Suggestions',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentOrange,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Book Now'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LongWeekendBanner extends StatelessWidget {
  const _LongWeekendBanner({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorScheme.primary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 32,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Long Weekend Calendar',
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Know More',
                  style: textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TravelBlogsRow extends StatelessWidget {
  const _TravelBlogsRow({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: trainTravelBlogs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final b = trainTravelBlogs[i];
          return SizedBox(
            width: 160,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      child: Icon(
                        Icons.article_rounded,
                        size: 40,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.title,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {},
                          child: Text(
                            b.buttonLabel,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PnrBanner extends StatelessWidget {
  const _PnrBanner({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              colorScheme.primary.withValues(alpha: 0.5),
              AppColors.iconTilePastelPurple,
            ],
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.confirmation_number_rounded,
              size: 48,
              color: colorScheme.onSurface.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need journey status? Check PNR anytime.',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.onSurface,
                      side: BorderSide(color: colorScheme.onSurface),
                    ),
                    child: const Text('Know More'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainBottomNav extends StatelessWidget {
  const _TrainBottomNav({
    required this.selectedIndex,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  static const _items = [
    (icon: Icons.luggage_rounded, label: 'My Bookings'),
    (icon: Icons.confirmation_number_rounded, label: 'PNR Status'),
    (icon: Icons.train_rounded, label: 'Train Status'),
    (icon: Icons.restaurant_rounded, label: 'Order Food'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final selected = i == selectedIndex;
          return InkWell(
            onTap: () => onTap(i),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: 24,
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: textTheme.labelSmall?.copyWith(
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
