import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/hotel_list_data.dart';

/// Result when user selects a location or "Use Current Location".
class HotelLocationResult {
  const HotelLocationResult({
    required this.locationName,
    this.isCurrentLocation = false,
  });

  final String locationName;
  final bool isCurrentLocation;
}

/// Page opened when tapping Location: "Where do you want to stay?" with
/// search field, Use Current Location, Recent Searches, and Popular destinations.
/// Pops with [HotelLocationResult] when user selects a location.
class HotelLocationSearchPage extends StatefulWidget {
  const HotelLocationSearchPage({
    super.key,
    this.initialLocation,
    this.initialSearchQuery,
  });

  final String? initialLocation;
  final String? initialSearchQuery;

  @override
  State<HotelLocationSearchPage> createState() => _HotelLocationSearchPageState();
}

class _HotelLocationSearchPageState extends State<HotelLocationSearchPage> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearchQuery ?? '');
    _searchQuery = widget.initialSearchQuery ?? '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectLocation(String locationName, {bool isCurrentLocation = false}) {
    Navigator.of(context).pop(
      HotelLocationResult(
        locationName: locationName,
        isCurrentLocation: isCurrentLocation,
      ),
    );
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
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Where do you want to stay?',
            hintStyle: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          onChanged: (v) => setState(() => _searchQuery = v),
        ),
        titleSpacing: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          if (_searchQuery.isNotEmpty) ...[
            Text(
              'Search:',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () => _selectLocation(_searchQuery),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Hotels in $_searchQuery',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _selectLocation(
                currentLocationLabel,
                isCurrentLocation: true,
              ),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.my_location_rounded,
                        color: AppColors.accentGreen,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Use Current Location',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            currentLocationLabel,
                            style: textTheme.bodySmall?.copyWith(
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
          ),
          const SizedBox(height: 8),
          Divider(height: 24, color: colorScheme.outline.withValues(alpha: 0.3)),
          Text(
            'RECENT SEARCHES',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ...hotelRecentSearches.map((r) => _RecentSearchTile(
                search: r,
                onTap: () => _selectLocation(r.location),
                colorScheme: colorScheme,
                textTheme: textTheme,
              )),
          const SizedBox(height: 16),
          Divider(height: 24, color: colorScheme.outline.withValues(alpha: 0.3)),
          Text(
            'POPULAR',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ...hotelPopularDestinations.map((city) => _PopularDestinationTile(
                city: city,
                onTap: () => _selectLocation(city),
                colorScheme: colorScheme,
                textTheme: textTheme,
              )),
        ],
      ),
    );
  }
}

class _RecentSearchTile extends StatelessWidget {
  const _RecentSearchTile({
    required this.search,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final HotelRecentSearch search;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final details =
        '${search.dateRange} | ${search.guests} | ${search.rooms}';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.history_rounded,
              size: 22,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    search.location,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    details,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
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

class _PopularDestinationTile extends StatelessWidget {
  const _PopularDestinationTile({
    required this.city,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final String city;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(
              Icons.trending_up_rounded,
              size: 20,
              color: AppColors.accentGreen,
            ),
            const SizedBox(width: 14),
            Text(
              city,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
