import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/train_list_data.dart';

/// Result passed when user selects a station on the search page.
class TrainStationSearchResult {
  const TrainStationSearchResult({
    required this.stationCode,
    required this.stationName,
    required this.forFrom,
  });

  final String stationCode;
  final String stationName;
  final bool forFrom;
}

/// Page opened when tapping From/To on train search: search by station code or name,
/// recent searches, popular stations. Pops with [TrainStationSearchResult] when user selects.
class TrainStationSearchPage extends StatefulWidget {
  const TrainStationSearchPage({
    super.key,
    required this.initialFromCode,
    required this.initialFromName,
    required this.initialToCode,
    required this.initialToName,
    required this.selectingFrom,
  });

  final String initialFromCode;
  final String initialFromName;
  final String initialToCode;
  final String initialToName;
  final bool selectingFrom;

  @override
  State<TrainStationSearchPage> createState() => _TrainStationSearchPageState();
}

class _TrainStationSearchPageState extends State<TrainStationSearchPage> {
  late bool _selectingFrom;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _selectingFrom = widget.selectingFrom;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectStation(String code, String name) {
    Navigator.of(context).pop(
      TrainStationSearchResult(
        stationCode: code,
        stationName: name,
        forFrom: _selectingFrom,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = colorScheme.surface;
    final borderColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Search by station',
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
                  Icon(
                    Icons.trip_origin_rounded,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.initialFromCode.isEmpty
                          ? 'From'
                          : '${widget.initialFromCode} ${widget.initialFromName}',
                      style: textTheme.bodyLarge?.copyWith(
                        color: widget.initialFromCode.isEmpty
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
                  Icon(
                    Icons.location_on_rounded,
                    size: 20,
                    color: colorScheme.primary,
                  ),
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
                      widget.initialToCode.isEmpty
                          ? 'To'
                          : '${widget.initialToCode} ${widget.initialToName}',
                      style: textTheme.bodyLarge?.copyWith(
                        color: widget.initialToCode.isEmpty
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
          Text(
            'Recent Searches',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...trainRecentSearches.map((r) {
            return ListTile(
              leading: Icon(
                Icons.history_rounded,
                size: 22,
                color: colorScheme.onSurfaceVariant,
              ),
              title: Text(
                '${r.fromCode} - ${r.toCode}',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                r.dateLabel,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              onTap: () {
                TrainStationPopular? fromStation;
                TrainStationPopular? toStation;
                for (final s in trainPopularStations) {
                  if (s.code == r.fromCode) fromStation = s;
                  if (s.code == r.toCode) toStation = s;
                }
                if (fromStation != null && toStation != null) {
                  _selectStation(
                    _selectingFrom ? fromStation.code : toStation.code,
                    _selectingFrom ? fromStation.name : toStation.name,
                  );
                }
              },
            );
          }),
          const SizedBox(height: 24),
          // Popular Stations
          Text(
            'Popular Stations (${trainPopularStations.length})',
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
            itemCount: trainPopularStations.length,
            itemBuilder: (context, i) {
              final s = trainPopularStations[i];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectStation(s.code, s.name),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: borderColor.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            s.code,
                            style: textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.name,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                s.state,
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
