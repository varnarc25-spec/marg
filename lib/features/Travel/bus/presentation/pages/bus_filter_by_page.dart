import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/bus_list_data.dart';

/// Filter category for the left column.
class _FilterCategory {
  const _FilterCategory(this.label, this.icon, {this.isAi = false});

  final String label;
  final IconData icon;
  final bool isAi;
}

const List<_FilterCategory> _filterCategories = [
  _FilterCategory('Sort By', Icons.format_list_bulleted_rounded),
  _FilterCategory('AI Filters', Icons.auto_awesome_rounded, isAi: true),
  _FilterCategory('Departure Time', Icons.schedule_rounded),
  _FilterCategory('Bus Type', Icons.directions_bus_rounded),
  _FilterCategory('Single Seat/Sleeper', Icons.event_seat_rounded),
  _FilterCategory('Price Range', Icons.currency_rupee_rounded),
  _FilterCategory('Bus Operators', Icons.business_rounded),
  _FilterCategory('Arrival Time', Icons.access_time_rounded),
  _FilterCategory('Pickup Points', Icons.location_on_rounded),
  _FilterCategory('Drop Off Points', Icons.place_rounded),
  _FilterCategory('Operator Rating', Icons.star_rounded),
  _FilterCategory('Amenities', Icons.checkroom_rounded),
  _FilterCategory('Offers', Icons.local_offer_rounded),
];

/// Full-screen "Filter By" page: left column = categories, right = options.
/// Sort By shows radio options (Recommended, Most Popular, etc.).
class BusFilterByPage extends StatefulWidget {
  const BusFilterByPage({
    super.key,
    required this.initialSortOption,
  });

  final BusSortOption initialSortOption;
  /// Pops with [BusSortOption] when Apply is pressed (Sort By selected).

  @override
  State<BusFilterByPage> createState() => _BusFilterByPageState();
}

class _BusFilterByPageState extends State<BusFilterByPage> {
  int _selectedCategoryIndex = 0; // Sort By selected; right shows radio options
  late BusSortOption _sortOption;

  @override
  void initState() {
    super.initState();
    _sortOption = widget.initialSortOption;
  }

  static String _sortLabel(BusSortOption o) {
    return switch (o) {
      BusSortOption.recommended => 'Recommended',
      BusSortOption.mostPopular => 'Most Popular',
      BusSortOption.cheapest => 'Cheapest',
      BusSortOption.bestRated => 'Best Rated',
      BusSortOption.earlyDeparture => 'Early Departure',
      BusSortOption.lateDeparture => 'Late Departure',
    };
  }

  static String? _sortDescription(BusSortOption o) {
    return switch (o) {
      BusSortOption.recommended =>
          'Highly rated, Well-priced & Clean buses.',
      BusSortOption.mostPopular => null,
      BusSortOption.cheapest => null,
      BusSortOption.bestRated => null,
      BusSortOption.earlyDeparture => null,
      BusSortOption.lateDeparture => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final surfaceColor = colorScheme.surface;
    final highlightBg = colorScheme.primary.withValues(alpha: 0.12);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Filter By',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: surfaceColor,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left column: categories
          Container(
            width: 140,
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border(
                right: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _filterCategories.length,
              itemBuilder: (context, i) {
                final cat = _filterCategories[i];
                final selected = _selectedCategoryIndex == i;
                return Material(
                  color: selected ? highlightBg : Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => _selectedCategoryIndex = i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            cat.icon,
                            size: 20,
                            color: selected
                                ? colorScheme.primary
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              cat.label,
                              style: textTheme.bodyMedium?.copyWith(
                                color: selected
                                    ? colorScheme.onSurface
                                    : AppColors.textSecondary,
                                fontWeight:
                                    selected ? FontWeight.w600 : FontWeight.normal,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Right column: options for selected category
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: _selectedCategoryIndex == 0
                  ? _SortByContent(
                      sortOption: _sortOption,
                      onChanged: (v) => setState(() => _sortOption = v),
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      sortLabel: _sortLabel,
                      sortDescription: _sortDescription,
                    )
                  : _PlaceholderContent(
                      category: _filterCategories[_selectedCategoryIndex].label,
                      textTheme: textTheme,
                      colorScheme: colorScheme,
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: FilledButton(
            onPressed: () {
              if (_selectedCategoryIndex == 0) {
                Navigator.of(context).pop(_sortOption);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Apply'),
          ),
        ),
      ),
    );
  }
}

class _SortByContent extends StatelessWidget {
  const _SortByContent({
    required this.sortOption,
    required this.onChanged,
    required this.colorScheme,
    required this.textTheme,
    required this.sortLabel,
    required this.sortDescription,
  });

  final BusSortOption sortOption;
  final ValueChanged<BusSortOption> onChanged;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final String Function(BusSortOption) sortLabel;
  final String? Function(BusSortOption)? sortDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: BusSortOption.values.map((option) {
        final selected = sortOption == option;
        final desc = sortDescription?.call(option);
        return RadioListTile<BusSortOption>(
          value: option,
          groupValue: sortOption,
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          activeColor: colorScheme.primary,
          title: Text(
            sortLabel(option),
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          subtitle: desc != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    desc,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : null,
        );
      }).toList(),
    );
  }
}

class _PlaceholderContent extends StatelessWidget {
  const _PlaceholderContent({
    required this.category,
    required this.textTheme,
    required this.colorScheme,
  });

  final String category;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Options for $category',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
