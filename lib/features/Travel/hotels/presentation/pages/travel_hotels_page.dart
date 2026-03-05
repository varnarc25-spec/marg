import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/hotel_list_data.dart';
import '../../../bus/presentation/pages/travel_bookings_page.dart';
import 'hotel_location_search_page.dart';
import 'hotel_details_page.dart';

/// Hotel travel home page: blue header with greeting, white search card
/// (All/Hotel/Villa, location, check-in/out, Search), Popular Hotel horizontal
/// list, bottom floating action (Offers / My Bookings).
/// Mirrors bus structure; uses app theme colors and widgets.
class TravelHotelsPage extends StatefulWidget {
  const TravelHotelsPage({super.key});

  @override
  State<TravelHotelsPage> createState() => _TravelHotelsPageState();
}

class _TravelHotelsPageState extends State<TravelHotelsPage> {
  int _propertyTypeIndex = 0; // All, Hotel, Villa
  int _floatingNavIndex = 0; // Offers, My Bookings
  String _selectedLocation = defaultHotelLocation;
  bool _isCurrentLocation = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Hotels',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox(height: 10),
          CustomScrollView(
            slivers: [
              // _buildHeader(colorScheme, textTheme),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HotelSearchCard(
                        propertyTypeIndex: _propertyTypeIndex,
                        onPropertyTypeTap: (i) =>
                            setState(() => _propertyTypeIndex = i),
                        selectedLocation: _selectedLocation,
                        isCurrentLocation: _isCurrentLocation,
                        onLocationTap: () async {
                          final result =
                              await Navigator.of(context).push<HotelLocationResult>(
                            MaterialPageRoute(
                              builder: (_) => HotelLocationSearchPage(
                                initialLocation: _selectedLocation,
                              ),
                            ),
                          );
                          if (result != null && mounted) {
                            setState(() {
                              _selectedLocation = result.locationName;
                              _isCurrentLocation = result.isCurrentLocation;
                            });
                          }
                        },
                        onUseCurrentLocation: () {
                          setState(() {
                            _selectedLocation = currentLocationLabel;
                            _isCurrentLocation = true;
                          });
                        },
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(
                        'Popular Hotel',
                        seeAllOnTap: () {},
                        textTheme: textTheme,
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: popularHotels.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _HotelCard(
                                hotel: popularHotels[i],
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => HotelDetailsPage(
                                        hotel: popularHotels[i],
                                      ),
                                    ),
                                  );
                                },
                                colorScheme: colorScheme,
                                textTheme: textTheme,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 16 + MediaQuery.paddingOf(context).bottom,
            child: Center(
              child: _HotelFloatingAction(
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

  // Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
  //   return SliverAppBar(
  //     expandedHeight: 140,
  //     pinned: true,
  //     stretch: true,
  //     backgroundColor: colorScheme.primary,
  //     leading: IconButton(
  //       icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
  //       onPressed: () => Navigator.of(context).pop(),
  //     ),
  //     flexibleSpace: FlexibleSpaceBar(
  //       stretchModes: const [
  //         StretchMode.zoomBackground,
  //         StretchMode.blurBackground,
  //       ],
  //       background: SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.fromLTRB(20, 12, 16, 24),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       'Hello, Sarah!',
  //                       style: textTheme.bodyMedium?.copyWith(
  //                         color: Colors.white.withValues(alpha: 0.9),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 4),
  //                     Row(
  //                       children: [
  //                         Text(
  //                           "Let's Start Exploring",
  //                           style: textTheme.titleLarge?.copyWith(
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                         const SizedBox(width: 4),
  //                         Text('👋', style: textTheme.titleLarge),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               CircleAvatar(
  //                 radius: 24,
  //                 backgroundColor: Colors.white.withValues(alpha: 0.3),
  //                 child: Icon(
  //                   Icons.person_rounded,
  //                   color: Colors.white,
  //                   size: 28,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class _HotelSearchCard extends StatelessWidget {
  const _HotelSearchCard({
    required this.propertyTypeIndex,
    required this.onPropertyTypeTap,
    required this.selectedLocation,
    required this.isCurrentLocation,
    required this.onLocationTap,
    required this.onUseCurrentLocation,
    required this.colorScheme,
    required this.textTheme,
  });

  final int propertyTypeIndex;
  final ValueChanged<int> onPropertyTypeTap;
  final String selectedLocation;
  final bool isCurrentLocation;
  final VoidCallback onLocationTap;
  final VoidCallback onUseCurrentLocation;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  static const _propertyTypes = ['All', 'Hotel', 'Villa'];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(_propertyTypes.length, (i) {
                final selected = i == propertyTypeIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: selected
                        ? AppColors.accentGreen
                        : colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.5,
                          ),
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () => onPropertyTypeTap(i),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          _propertyTypes[i],
                          style: textTheme.labelLarge?.copyWith(
                            color: selected
                                ? Colors.white
                                : colorScheme.onSurfaceVariant,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              'Location',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Material(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: onLocationTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCurrentLocation
                            ? Icons.my_location_rounded
                            : Icons.location_on_rounded,
                        size: 20,
                        color: isCurrentLocation
                            ? AppColors.accentGreen
                            : colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedLocation,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onUseCurrentLocation,
                        icon: Icon(
                          Icons.my_location_rounded,
                          size: 22,
                          color: AppColors.accentGreen,
                        ),
                        tooltip: 'Use current location',
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.accentGreen.withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Check-in',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            defaultCheckInLabel,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Check-out',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            defaultCheckOutLabel,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accentGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Search'),
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
    required this.seeAllOnTap,
    required this.textTheme,
    required this.colorScheme,
  });

  final String title;
  final VoidCallback seeAllOnTap;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        TextButton(
          onPressed: seeAllOnTap,
          child: Text(
            'See All',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _HotelCard extends StatelessWidget {
  const _HotelCard({
    required this.hotel,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final HotelListItem hotel;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.6),
                            colorScheme.primary.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.hotel_rounded,
                        size: 40,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Colors.black87,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            hotel.rating.toString(),
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.name,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            hotel.location,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '\$${hotel.price}',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${hotel.roomsLeft} Rooms left',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom floating bar: Offers and My Bookings (two items only).
class _HotelFloatingAction extends StatelessWidget {
  const _HotelFloatingAction({
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
