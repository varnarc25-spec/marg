import 'package:flutter/material.dart';

import '../../data/models/flight_city_model.dart';
import '../../data/models/flight_list_data.dart';

/// Page to select From or To city/airport. No category tabs.
/// Structure aligned with bike insurance selection (search/input + section lists).
/// Opens when user taps From or To on the flight search card.
class FlightCitySelectPage extends StatefulWidget {
  const FlightCitySelectPage({
    super.key,
    required this.selectingFrom,
    this.initialFromCode = 'MAA',
    this.initialFromCity = 'Chennai',
    this.initialToCode = 'KWI',
    this.initialToCity = 'Kuwait',
  });

  /// True if user is selecting the "From" field; false for "To".
  final bool selectingFrom;
  final String initialFromCode;
  final String initialFromCity;
  final String initialToCode;
  final String initialToCity;

  @override
  State<FlightCitySelectPage> createState() => _FlightCitySelectPageState();
}

class _FlightCitySelectPageState extends State<FlightCitySelectPage> {
  late TextEditingController _fromController;
  late TextEditingController _toController;
  bool _fromFocused = true;

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController(text: widget.initialFromCity);
    _toController = TextEditingController(text: widget.initialToCity);
    _fromFocused = widget.selectingFrom;
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _selectAndPop(FlightCityResult result) {
    Navigator.of(context).pop(result);
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
        backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Text(
            'From',
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          _CityInputField(
            controller: _fromController,
            hint: 'Enter any City or Airport Name',
            focused: _fromFocused,
            onTap: () => setState(() => _fromFocused = true),
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: 16),
          Text(
            'To',
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          _CityInputField(
            controller: _toController,
            hint: 'Enter any City or Airport Name',
            focused: !_fromFocused,
            onTap: () => setState(() => _fromFocused = false),
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: 24),
          Text(
            'Recent Searches',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          ...flightRecentSearches.map(
            (e) => _RecentSearchTile(
              route: e.routeLabel,
              subtitle: e.subtitle,
              onTap: () => _selectAndPop(e.cityResult),
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Popular Cities',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          ...flightPopularCities.map(
            (c) => _PopularCityTile(
              city: c.city,
              airport: c.airport,
              code: c.code,
              onTap: () => _selectAndPop(c.toCityResult()),
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),
        ],
      ),
    );
  }
}

class _CityInputField extends StatelessWidget {
  const _CityInputField({
    required this.controller,
    required this.hint,
    required this.focused,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final TextEditingController controller;
  final String hint;
  final bool focused;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: focused
                ? Colors.grey
                : colorScheme.outline.withValues(alpha: 0.4),
            width: focused ? 2 : 1,
          ),
        ),
        child: TextField(
          controller: controller,
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.primary, width: 0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentSearchTile extends StatelessWidget {
  const _RecentSearchTile({
    required this.route,
    required this.subtitle,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final String route;
  final String subtitle;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.history_rounded,
              size: 22,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
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

class _PopularCityTile extends StatelessWidget {
  const _PopularCityTile({
    required this.city,
    required this.airport,
    required this.code,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final String city;
  final String airport;
  final String code;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 22,
              color: colorScheme.onSurface,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    airport,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              code,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
