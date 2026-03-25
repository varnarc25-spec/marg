import 'package:flutter/material.dart';
import '../../data/models/flight_list_data.dart';

class FlightDateFareStrip extends StatelessWidget {
  const FlightDateFareStrip({
    super.key,
    required this.dates,
    required this.selectedIndex,
    required this.onSelect,
    required this.colorScheme,
    required this.textTheme,
    this.monthLabel,
  });

  final List<FlightDateFare> dates;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final String? monthLabel;

  String _formatPrice(int price) {
    final s = price.toString();
    if (s.length <= 3) return '₹$s';
    final parts = <String>[];
    parts.add(s.substring(s.length - 3));
    var i = s.length - 3;
    while (i > 0) {
      final end = i;
      final start = i - 2 >= 0 ? i - 2 : 0;
      parts.insert(0, s.substring(start, end));
      i -= 2;
    }
    return '₹${parts.join(',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 10),
              child: Text(
                monthLabel ??
                    (dates.isNotEmpty
                        ? monthShortName(dates[selectedIndex].date.month)
                            .toUpperCase()
                        : ''),
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Material(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'All Fares',
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ...List.generate(dates.length, (i) {
              final d = dates[i];
              final selected = i == selectedIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Material(
                  color: selected
                      ? colorScheme.primary.withValues(alpha: 0.15)
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => onSelect(i),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: selected
                            ? Border.all(
                                color: colorScheme.primary, width: 1.5)
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                          const SizedBox(height: 2),
                          Text(
                            _formatPrice(d.price),
                            style: textTheme.labelSmall?.copyWith(
                              color: selected
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
