import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/bus_city_model.dart';
import '../../data/bus_list_data.dart';
import '../providers/bus_search_provider.dart';
import 'bus_city_search_page.dart';
import 'bus_search_results_page.dart';
import 'travel_bookings_page.dart';

/// Bus travel home page: app bar, previous journey, promo, search card,
/// partner offers, explore feature, exclusive features, calendar, travel blogs,
/// bottom floating action (Offers / My Bookings).
/// Same structure as flight folder; uses app theme and providers.
class TravelBusPage extends ConsumerStatefulWidget {
  const TravelBusPage({super.key});

  @override
  ConsumerState<TravelBusPage> createState() => _TravelBusPageState();
}

class _TravelBusPageState extends ConsumerState<TravelBusPage> {
  int _selectedDateIndex = 1; // 4 Wed
  int _busTypeIndex = -1; // Seater, Sleeper, AC (none selected)
  int _floatingNavIndex = 0; // Offers / My Bookings

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
              _PreviousJourneyCard(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 12),
                _PromoBanner(colorScheme: colorScheme, textTheme: textTheme),
                const SizedBox(height: 16),
                _BusSearchCard(
                  fromCity: from.cityName,
                  toCity: to.cityName,
                  onFromTap: () async {
                    final result = await Navigator.of(context).push<BusCitySearchResult>(
                      MaterialPageRoute(
                        builder: (context) => BusCitySearchPage(
                          initialFrom: from.cityName,
                          initialTo: to.cityName,
                          selectingFrom: true,
                        ),
                      ),
                    );
                    if (result != null && mounted) {
                      ref.read(busFromProvider.notifier).state =
                          BusCityResult(cityName: result.cityName);
                    }
                  },
                  onToTap: () async {
                    final result = await Navigator.of(context).push<BusCitySearchResult>(
                      MaterialPageRoute(
                        builder: (context) => BusCitySearchPage(
                          initialFrom: from.cityName,
                          initialTo: to.cityName,
                          selectingFrom: false,
                        ),
                      ),
                    );
                    if (result != null && mounted) {
                      ref.read(busToProvider.notifier).state =
                          BusCityResult(cityName: result.cityName);
                    }
                  },
                  selectedDateIndex: _selectedDateIndex,
                  onDateTap: (i) => setState(() => _selectedDateIndex = i),
                  busTypeIndex: _busTypeIndex,
                  onBusTypeTap: (i) => setState(() => _busTypeIndex = i),
                  onSearchPressed: () {
                    final date = busDepartureDates[_selectedDateIndex];
                    final dateLabel =
                        '${date.weekday}, ${date.day} Mar';
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
                _SectionTitle(
                  'Partner Offers',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                _PartnerOffersRow(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  'Explore Our New Feature',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                _ExploreFeatureBanner(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  'Exclusive features on Paytm',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: _ExclusiveFeaturesRow(
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
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
                _TravelBlogsRow(colorScheme: colorScheme, textTheme: textTheme),
                const SizedBox(height: 24),
              ],
            ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 16 + MediaQuery.paddingOf(context).bottom,
            child: Center(
              child: _BusFloatingAction(
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
}

class _PreviousJourneyCard extends StatelessWidget {
  const _PreviousJourneyCard({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final j = busPreviousJourney;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    j.operatorName,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        j.fromCity,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        ' ${j.fromTime}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        j.toCity,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        ' ${j.toTime}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    j.travelDate,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Book again',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 140,
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rangon se bhari savings',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Flat 10% off on bus tickets',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Book Now'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                  Text(
                    'Promo: BUSLOYAL',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.accentOrange,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.directions_bus_rounded,
              size: 64,
              color: colorScheme.primary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusSearchCard extends StatelessWidget {
  const _BusSearchCard({
    required this.fromCity,
    required this.toCity,
    required this.onFromTap,
    required this.onToTap,
    required this.selectedDateIndex,
    required this.onDateTap,
    required this.busTypeIndex,
    required this.onBusTypeTap,
    required this.onSearchPressed,
    required this.colorScheme,
    required this.textTheme,
  });

  final String fromCity;
  final String toCity;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final int selectedDateIndex;
  final ValueChanged<int> onDateTap;
  final int busTypeIndex;
  final ValueChanged<int> onBusTypeTap;
  final VoidCallback onSearchPressed;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
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
                          Text(
                            fromCity,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.swap_vert_rounded,
                    color: colorScheme.primary,
                  ),
                  onPressed: () {},
                ),
                Expanded(
                  child: InkWell(
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
                          Text(
                            toCity,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Departure Date',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.calendar_month_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  label: Text(
                    'Show More Dates',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: busDepartureDates.length,
                itemBuilder: (context, i) {
                  final d = busDepartureDates[i];
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
                                    color: colorScheme.outline.withValues(
                                      alpha: 0.3,
                                    ),
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
              'Bus Type',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ['Seater', 'Sleeper', 'AC'].asMap().entries.map((e) {
                final selected = busTypeIndex == e.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(e.value),
                    selected: selected,
                    onSelected: (_) => onBusTypeTap(selected ? -1 : e.key),
                    selectedColor: colorScheme.primary.withValues(alpha: 0.15),
                    checkmarkColor: colorScheme.primary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: onSearchPressed,
                child: const Text('Search Buses'),
              ),
            ),
          ],
        ),
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

class _PartnerOffersRow extends StatelessWidget {
  const _PartnerOffersRow({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: busPartnerOffers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final o = busPartnerOffers[i];
          return SizedBox(
            width: 200,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: o.gradientColors,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            o.bankName,
                            style: textTheme.labelMedium?.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            o.offerTitle,
                            style: textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            o.disclaimer,
                            style: textTheme.labelSmall?.copyWith(
                              color: Colors.white70,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      o.promoCode,
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
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

class _ExploreFeatureBanner extends StatelessWidget {
  const _ExploreFeatureBanner({
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Travel worry-free using',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Paytm Assured',
                          style: textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accentOrange,
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text('Know More'),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.directions_bus_rounded,
              size: 48,
              color: colorScheme.primary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExclusiveFeaturesRow extends StatelessWidget {
  const _ExclusiveFeaturesRow({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: busExclusiveFeatures.map((f) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 80,
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(f.icon, size: 28, color: colorScheme.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    f.label,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
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
              Icon(Icons.calendar_month_rounded, size: 32, color: Colors.white),
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
  const _TravelBlogsRow({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: busTravelBlogs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final b = busTravelBlogs[i];
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
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
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

class _BusFloatingAction extends StatelessWidget {
  const _BusFloatingAction({
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
    (icon: Icons.percent_rounded, label: 'Offers'),
    (icon: Icons.work_rounded, label: 'My Bookings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_items.length, (i) {
            final item = _items[i];
            final selected = i == selectedIndex;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTap(i),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 22,
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.label,
                        style: textTheme.labelLarge?.copyWith(
                          color: selected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
