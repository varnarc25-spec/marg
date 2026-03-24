import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/models/bus_list_data.dart';

class BusSearchCard extends StatelessWidget {
  const BusSearchCard({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.onFromTap,
    required this.onToTap,
    required this.onSwapTap,
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
  final VoidCallback onSwapTap;
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
                  onPressed: onSwapTap,
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
