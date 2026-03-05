import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/flight_city_model.dart';
import '../providers/flight_search_provider.dart';
import 'flight_city_select_page.dart';
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
                _PromoBanner(colorScheme: colorScheme, textTheme: textTheme),
                const SizedBox(height: 16),
                _FlightSearchCard(
                  fromCode: from.code,
                  fromCity: from.cityName,
                  toCode: to.code,
                  toCity: to.cityName,
                  onFromTap: () => _openCitySelect(selectingFrom: true),
                  onToTap: () => _openCitySelect(selectingFrom: false),
                  onSearchPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FlightSearchResultsPage(
                          fromCode: from.code,
                          fromCity: from.cityName,
                          toCode: to.code,
                          toCity: to.cityName,
                          dateLabel: 'Tue, 10 Mar',
                          travellersLabel: '1 Traveller',
                          cabinLabel: 'Economy',
                        ),
                      ),
                    );
                  },
                  oneWay: _oneWay,
                  onOneWayChanged: (v) => setState(() => _oneWay = v),
                  specialFareIndex: _specialFareIndex,
                  onSpecialFareTap: (i) => setState(() => _specialFareIndex = i),
                  nonStopOnly: _nonStopOnly,
                  onNonStopChanged: (v) => setState(() => _nonStopOnly = v),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                _SectionTitle(title: 'Destination of the Week: Malaysia', textTheme: textTheme, colorScheme: colorScheme),
                const SizedBox(height: 10),
                _DestinationWeekRow(colorScheme: colorScheme, textTheme: textTheme),
                const SizedBox(height: 24),
                _SectionTitle(title: 'Long Weekend Getaways', textTheme: textTheme, colorScheme: colorScheme),
                const SizedBox(height: 10),
                _LongWeekendRow(colorScheme: colorScheme, textTheme: textTheme),
                const SizedBox(height: 24),
                _SectionTitle(title: 'Bank Offers', textTheme: textTheme, colorScheme: colorScheme),
                const SizedBox(height: 10),
                _BankOffersRow(colorScheme: colorScheme, textTheme: textTheme),
                const SizedBox(height: 24),
                _CricketFeverBanner(colorScheme: colorScheme, textTheme: textTheme),
                const SizedBox(height: 24),
                _SectionTitle(title: 'Exotic places now Visa-free', textTheme: textTheme, colorScheme: colorScheme),
                const SizedBox(height: 10),
                _VisaFreeRow(colorScheme: colorScheme, textTheme: textTheme),
                const SizedBox(height: 24),
                _SectionTitle(title: 'Recent Searches', textTheme: textTheme, colorScheme: colorScheme),
                const SizedBox(height: 10),
                _RecentSearchesRow(colorScheme: colorScheme, textTheme: textTheme),
                const SizedBox(height: 24),
              ],
            ),
          ),
          _TravelBottomNav(
            selectedIndex: _bottomNavIndex,
            onTap: (i) => setState(() => _bottomNavIndex = i),
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.card_giftcard_rounded, size: 22, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Use promocode "FLYNEW" to get flat 15% off on your 1st domestic booking.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlightSearchCard extends StatelessWidget {
  const _FlightSearchCard({
    required this.fromCode,
    required this.fromCity,
    required this.toCode,
    required this.toCity,
    required this.onFromTap,
    required this.onToTap,
    required this.onSearchPressed,
    required this.oneWay,
    required this.onOneWayChanged,
    required this.specialFareIndex,
    required this.onSpecialFareTap,
    required this.nonStopOnly,
    required this.onNonStopChanged,
    required this.colorScheme,
    required this.textTheme,
  });

  final String fromCode;
  final String fromCity;
  final String toCode;
  final String toCity;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final VoidCallback onSearchPressed;
  final bool oneWay;
  final ValueChanged<bool> onOneWayChanged;
  final int specialFareIndex;
  final ValueChanged<int> onSpecialFareTap;
  final bool nonStopOnly;
  final ValueChanged<bool> onNonStopChanged;
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
                  child: _SegmentChip(
                    label: 'One Way',
                    selected: oneWay,
                    onTap: () => onOneWayChanged(true),
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SegmentChip(
                    label: 'Round Trip',
                    selected: !oneWay,
                    onTap: () => onOneWayChanged(false),
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onFromTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('From', style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                          Text(fromCode, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                          Text(fromCity, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.swap_horiz_rounded, color: colorScheme.primary),
                ),
                Expanded(
                  child: InkWell(
                    onTap: onToTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('To', style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                          Text(toCode, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                          Text(toCity, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Departure Date', style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                    Text('Tue, 10 Mar 26', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Save more on Roundtrip', style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: Text('+ Add Return', style: textTheme.bodySmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            _LabelValue(label: 'Travellers & Cabin Class', value: '1 Adult • Economy', colorScheme: colorScheme, textTheme: textTheme),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Special Fares (optional)', style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                Row(
                  children: [
                    Icon(Icons.savings_rounded, size: 16, color: AppColors.accentGreen),
                    const SizedBox(width: 4),
                    Text('Extra Savings', style: textTheme.labelSmall?.copyWith(color: AppColors.accentGreen, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SpecialFareChip(label: 'Student Extra Baggage', selected: specialFareIndex == 0, onTap: () => onSpecialFareTap(0), colorScheme: colorScheme, textTheme: textTheme),
                _SpecialFareChip(label: 'Armed Forces Up to ₹600 off', selected: specialFareIndex == 1, onTap: () => onSpecialFareTap(1), colorScheme: colorScheme, textTheme: textTheme),
                _SpecialFareChip(label: 'Senior Citizen Up to ₹600 off', selected: specialFareIndex == 2, onTap: () => onSpecialFareTap(2), colorScheme: colorScheme, textTheme: textTheme),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: nonStopOnly,
                    onChanged: (v) => onNonStopChanged(v ?? false),
                    fillColor: WidgetStateProperty.resolveWith((_) => colorScheme.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Show Non-stop flights only', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: onSearchPressed,
                child: const Text('Search Flights'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _LabelValue({required String label, required String value, required ColorScheme colorScheme, required TextTheme textTheme}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
      Text(value, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
    ],
  );
}

class _SegmentChip extends StatelessWidget {
  const _SegmentChip({required this.label, required this.selected, required this.onTap, required this.colorScheme, required this.textTheme});

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? colorScheme.surfaceContainerHighest : colorScheme.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: selected ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpecialFareChip extends StatelessWidget {
  const _SpecialFareChip({required this.label, required this.selected, required this.onTap, required this.colorScheme, required this.textTheme});

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.transparent : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: selected ? Border.all(color: colorScheme.onSurface) : null,
          ),
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: selected ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.textTheme, required this.colorScheme});

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

class _DestinationWeekRow extends StatelessWidget {
  const _DestinationWeekRow({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Malaysia Itinerary', 'Explore Now', AppColors.iconTilePastelBlue),
      ('Visa Requirements', 'Check Now', AppColors.accentGreen.withValues(alpha: 0.3)),
      ('Top Things to Do', 'Explore Now', AppColors.iconTilePastelPurple),
    ];
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final (title, sub, bg) = items[i];
          return _DiscoveryCard(title: title, subtitle: sub, backgroundColor: bg, colorScheme: colorScheme, textTheme: textTheme);
        },
      ),
    );
  }
}

class _LongWeekendRow extends StatelessWidget {
  const _LongWeekendRow({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Abu Dhabi', 'Enchanting Desert'),
      ('Seychelles', 'Stunning Beaches'),
      ('Vietnam', 'Explore Rich History'),
    ];
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final (title, sub) = items[i];
          return _GetawayCard(title: title, subtitle: sub, colorScheme: colorScheme, textTheme: textTheme);
        },
      ),
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard({
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.colorScheme,
    required this.textTheme,
  });

  final String title;
  final String subtitle;
  final Color backgroundColor;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
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
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                child: Icon(Icons.image_rounded, size: 48, color: colorScheme.onSurfaceVariant),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
                  Text(subtitle, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GetawayCard extends StatelessWidget {
  const _GetawayCard({required this.title, required this.subtitle, required this.colorScheme, required this.textTheme});

  final String title;
  final String subtitle;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
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
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                child: Icon(Icons.landscape_rounded, size: 48, color: colorScheme.onSurfaceVariant),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
                  Text(subtitle, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BankOffersRow extends StatelessWidget {
  const _BankOffersRow({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('RBLBANK', 'Flat 10% Off', 'on International Flights →', 'INTRBLEMI', colorScheme.primary),
      ('AXIS BANK', 'Flat 10% Off', 'on International Flights →', 'INTAXISEMI', const Color(0xFFAB47BC)),
      ('HDFC BANK', 'Up to ₹5000 Off', 'on International Flights →', 'INTHDFC3M', colorScheme.primary),
    ];
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final (bank, offer, sub, promo, topColor) = items[i];
          return _BankOfferCard(
            bankName: bank,
            offerTitle: offer,
            offerSubtitle: sub,
            promoCode: promo,
            topColor: topColor,
            colorScheme: colorScheme,
            textTheme: textTheme,
          );
        },
      ),
    );
  }
}

class _BankOfferCard extends StatelessWidget {
  const _BankOfferCard({
    required this.bankName,
    required this.offerTitle,
    required this.offerSubtitle,
    required this.promoCode,
    required this.topColor,
    required this.colorScheme,
    required this.textTheme,
  });

  final String bankName;
  final String offerTitle;
  final String offerSubtitle;
  final String promoCode;
  final Color topColor;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              color: topColor.withValues(alpha: 0.3),
              child: Text(bankName, style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: topColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(offerTitle, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(offerSubtitle, style: textTheme.bodySmall?.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                color: colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Valid on Credit Card EMI • T&C Apply',
                      style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text('Promo: $promoCode', style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CricketFeverBanner extends StatelessWidget {
  const _CricketFeverBanner({required this.colorScheme, required this.textTheme});

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
            colors: [colorScheme.primary.withValues(alpha: 0.3), colorScheme.primary.withValues(alpha: 0.15)],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Fly for the T20 Fever!', style: textTheme.titleSmall?.copyWith(color: AppColors.accentOrange, fontWeight: FontWeight.bold)),
                  Text('Flat 10% Off on international Flight', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16), backgroundColor: AppColors.accentOrange),
                    child: const Text('Book Now'),
                  ),
                ],
              ),
            ),
            Icon(Icons.flight_takeoff_rounded, size: 56, color: colorScheme.primary.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _VisaFreeRow extends StatelessWidget {
  const _VisaFreeRow({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Philippines', 'Experience Pristine Beaches', true),
      ('Thailand', 'Island hopping in Thailand', false),
      ('Sri Lanka', 'Explore the Ancient Ruins', false),
    ];
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final (title, sub, visaFree) = items[i];
          return _GetawayCard(
            title: title,
            subtitle: sub,
            colorScheme: colorScheme,
            textTheme: textTheme,
          );
        },
      ),
    );
  }
}

class _RecentSearchesRow extends StatelessWidget {
  const _RecentSearchesRow({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final items = [('MAA - CMB', '08 Mar 26'), ('BBI - TIR', '04 Mar 26'), ('BBI - CDP', '04 Mar 26')];
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final (route, date) = items[i];
          return Card(
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(route, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
                    Text(date, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
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

class _TravelBottomNav extends StatelessWidget {
  const _TravelBottomNav({
    required this.selectedIndex,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.work_rounded, label: 'My Bookings'),
    _NavItem(icon: Icons.percent_rounded, label: 'Offers'),
    _NavItem(icon: Icons.confirmation_number_rounded, label: 'Travel Pass'),
    _NavItem(icon: Icons.flight_rounded, label: 'Flight Tracker'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.paddingOf(context).bottom),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, -2))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (i) {
            final item = _items[i];
            final selected = i == selectedIndex;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTap(i),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selected ? colorScheme.primary.withValues(alpha: 0.15) : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.icon,
                          size: 24,
                          color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: textTheme.labelSmall?.copyWith(
                          color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
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

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
