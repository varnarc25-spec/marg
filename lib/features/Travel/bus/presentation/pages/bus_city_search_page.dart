import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/bus_list_data.dart';

/// Result passed when user selects a city on the search page.
/// [cityName] is the selected city; [forFrom] is true when selecting origin.
class BusCitySearchResult {
  const BusCitySearchResult({
    required this.cityName,
    required this.forFrom,
  });

  final String cityName;
  final bool forFrom;
}

/// Page opened when tapping From/To on bus search: "Search by city or bus stops"
/// with From/To fields, recent searches, cities closest to you, and popular cities.
/// Pops with [BusCitySearchResult] when user selects a city.
class BusCitySearchPage extends StatefulWidget {
  const BusCitySearchPage({
    super.key,
    required this.initialFrom,
    required this.initialTo,
    required this.selectingFrom,
  });

  final String initialFrom;
  final String initialTo;
  /// True when user is selecting the From city; false for To.
  final bool selectingFrom;

  @override
  State<BusCitySearchPage> createState() => _BusCitySearchPageState();
}

class _BusCitySearchPageState extends State<BusCitySearchPage> {
  late bool _selectingFrom;
  late TextEditingController _fromController;
  late TextEditingController _toController;
  List<BusRecentRoute> _recentSearches = List.from(busRecentSearches);

  @override
  void initState() {
    super.initState();
    _selectingFrom = widget.selectingFrom;
    _fromController = TextEditingController(text: widget.initialFrom);
    _toController = TextEditingController(text: widget.initialTo);
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _selectCity(String cityName) {
    Navigator.of(context).pop(
      BusCitySearchResult(
        cityName: cityName,
        forFrom: _selectingFrom,
      ),
    );
  }

  void _removeRecent(int index) {
    setState(() {
      _recentSearches = List.from(_recentSearches)..removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = colorScheme.surface;
    final borderColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Search by city or bus stops',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: surfaceColor,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.close_rounded, color: colorScheme.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // From field
          InkWell(
            onTap: () => setState(() => _selectingFrom = true),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.trip_origin_rounded, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _fromController.text.isEmpty ? 'From' : _fromController.text,
                      style: textTheme.bodyLarge?.copyWith(
                        color: _fromController.text.isEmpty
                            ? AppColors.textSecondary
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // To field
          InkWell(
            onTap: () => setState(() => _selectingFrom = false),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on_rounded, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    'To',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _toController.text.isEmpty ? 'To' : _toController.text,
                      style: textTheme.bodyLarge?.copyWith(
                        color: _toController.text.isEmpty
                            ? AppColors.textSecondary
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            Text(
              'Recent Searches',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(_recentSearches.length, (i) {
              final r = _recentSearches[i];
              return Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.history_rounded,
                      size: 22,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      '${r.from} → ${r.to}',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.close_rounded, size: 20, color: colorScheme.onSurfaceVariant),
                      onPressed: () => _removeRecent(i),
                    ),
                    onTap: () => _selectCity(_selectingFrom ? r.from : r.to),
                  ),
                  if (i < _recentSearches.length - 1)
                    Divider(height: 1, color: borderColor.withValues(alpha: 0.3)),
                ],
              );
            }),
            const SizedBox(height: 24),
          ],
          // Cities closest to you
          Text(
            'Cities closest to you (${busCitiesClosest.length})',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(busCitiesClosest.length, (i) {
            final c = busCitiesClosest[i];
            return Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.location_city_rounded,
                    size: 22,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  title: Text(
                    '${c.name} (${c.state})',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  trailing: Text(
                    '${c.distanceKm} km',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  onTap: () => _selectCity(c.name),
                ),
                if (i < busCitiesClosest.length - 1)
                  Divider(height: 1, color: borderColor.withValues(alpha: 0.3)),
              ],
            );
          }),
          const SizedBox(height: 24),
          // Popular Cities
          Text(
            'Popular Cities (${busPopularCities.length})',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: busPopularCities.length,
            itemBuilder: (context, i) {
              final c = busPopularCities[i];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectCity(c.name),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor.withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_city_rounded,
                          size: 22,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.name,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                c.state,
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
