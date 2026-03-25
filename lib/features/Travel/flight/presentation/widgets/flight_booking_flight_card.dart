import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/models/flight_result_model.dart';

/// Flight summary card + baggage chips + cancellation protection.
class FlightBookingFlightCard extends StatelessWidget {
  const FlightBookingFlightCard({
    super.key,
    required this.flight,
    required this.fareName,
    required this.dateLabel,
    required this.route,
    required this.cancellationOption,
    required this.onCancellationChanged,
  });

  final FlightResultItem flight;
  final String fareName;
  final String dateLabel;
  final String route;
  final int cancellationOption;
  final ValueChanged<int> onCancellationChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Flight summary card ──
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route header
                Row(
                  children: [
                    Icon(
                      Icons.flight_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        route,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Date, stops, duration, class, fare
                Text(
                  '$dateLabel  •  ${flight.stops}  •  ${flight.duration}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Economy  •  $fareName',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),

                // Baggage chips
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _BaggageChip(
                      label: 'Check-in: 15 Kg/Adult',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    _BaggageChip(
                      label: 'Cabin: 7 Kg/Adult',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Expandable policies
        Card(
          child: Theme(
            data: theme.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Baggage, cancellation & reschedule policies',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    'Cancellation and date change charges apply as per airline policy.',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ── Cancellation protection ──
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with illustration placeholder
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'FREE ',
                                  style: textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.accentGreen,
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 14,
                                  color: AppColors.accentGreen,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Cancellation',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Learn more',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.flight_takeoff_rounded,
                      size: 56,
                      color: AppColors.primaryBlue.withValues(alpha: 0.2),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // None vs Classic cards
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _CancellationCard(
                        selected: cancellationOption == 0,
                        title: 'None',
                        pricePerPax: '₹0/pax',
                        cancelFee: '₹4,300',
                        cancelFeeHighlight: false,
                        refund: '₹1,525',
                        refundHighlight: false,
                        onTap: () => onCancellationChanged(0),
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CancellationCard(
                        selected: cancellationOption == 1,
                        title: 'Classic',
                        pricePerPax: '₹565/pax',
                        cancelFee: 'FREE',
                        cancelFeeHighlight: true,
                        refund: '₹6,124',
                        refundHighlight: true,
                        onTap: () => onCancellationChanged(1),
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Social proof
                Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      size: 16,
                      color: AppColors.accentOrange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '7177 people already added this in last 7 days',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Baggage chip ──

class _BaggageChip extends StatelessWidget {
  const _BaggageChip({
    required this.label,
    required this.colorScheme,
    required this.textTheme,
  });

  final String label;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── Cancellation card ──

class _CancellationCard extends StatelessWidget {
  const _CancellationCard({
    required this.selected,
    required this.title,
    required this.pricePerPax,
    required this.cancelFee,
    required this.cancelFeeHighlight,
    required this.refund,
    required this.refundHighlight,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final bool selected;
  final String title;
  final String pricePerPax;
  final String cancelFee;
  final bool cancelFeeHighlight;
  final String refund;
  final bool refundHighlight;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? AppColors.primaryBlue
        : colorScheme.outline.withValues(alpha: 0.25);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  size: 20,
                  color: selected
                      ? AppColors.primaryBlue
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: Text(
                pricePerPax,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Cancellation fee',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              cancelFee,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cancelFeeHighlight
                    ? AppColors.accentGreen
                    : colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Approx Refund',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              refund,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: refundHighlight
                    ? AppColors.accentGreen
                    : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
