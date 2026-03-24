import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class FlightSearchCard extends StatelessWidget {
  const FlightSearchCard({
    super.key,
    required this.fromCode,
    required this.fromCity,
    required this.toCode,
    required this.toCity,
    required this.departureDate,
    required this.onFromTap,
    required this.onToTap,
    required this.onSwapTap,
    required this.onDepartureDateTap,
    required this.adults,
    required this.cabinClass,
    required this.onTravellersTap,
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
  final VoidCallback onSwapTap;
  final DateTime departureDate;
  final VoidCallback onDepartureDateTap;
  final int adults;
  final String cabinClass;
  final VoidCallback onTravellersTap;
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
                          Text(
                            'From',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            fromCode,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            fromCity,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onSwapTap,
                  icon: Icon(
                    Icons.swap_horiz_rounded,
                    color: colorScheme.primary,
                  ),
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
                          Text(
                            'To',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            toCode,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            toCity,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
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
                InkWell(
                  onTap: onDepartureDateTap,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Departure Date',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${departureDate.day.toString().padLeft(2, '0')} '
                          '${_monthShort(departureDate.month)} '
                          '${departureDate.year.toString().substring(2)}',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Save more on Roundtrip',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        '+ Add Return',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: onTravellersTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: _LabelValue(
                  label: 'Travellers & Cabin Class',
                  value: '$adults Adult${adults > 1 ? "s" : ""} • $cabinClass',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Special Fares (optional)',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.savings_rounded,
                      size: 16,
                      color: AppColors.accentGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Extra Savings',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SpecialFareChip(
                  label: 'Student Extra Baggage',
                  selected: specialFareIndex == 0,
                  onTap: () => onSpecialFareTap(0),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _SpecialFareChip(
                  label: 'Armed Forces Up to ₹600 off',
                  selected: specialFareIndex == 1,
                  onTap: () => onSpecialFareTap(1),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _SpecialFareChip(
                  label: 'Senior Citizen Up to ₹600 off',
                  selected: specialFareIndex == 2,
                  onTap: () => onSpecialFareTap(2),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
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
                    fillColor: WidgetStateProperty.resolveWith(
                      (_) => colorScheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Show Non-stop flights only',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
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

Widget _LabelValue({
  required String label,
  required String value,
  required ColorScheme colorScheme,
  required TextTheme textTheme,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      Text(
        value,
        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
      ),
    ],
  );
}

class _SegmentChip extends StatelessWidget {
  const _SegmentChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? colorScheme.surfaceContainerHighest
          : colorScheme.primary.withValues(alpha: 0.1),
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
                color: selected
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpecialFareChip extends StatelessWidget {
  const _SpecialFareChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Colors.transparent
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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
              color: selected
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

String _monthShort(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  if (month < 1 || month > 12) return '';
  return months[month - 1];
}
