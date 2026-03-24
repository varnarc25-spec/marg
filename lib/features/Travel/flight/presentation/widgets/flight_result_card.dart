import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/models/flight_result_model.dart';

class FlightResultCard extends StatelessWidget {
  const FlightResultCard({
    super.key,
    required this.flight,
    required this.colorScheme,
    required this.textTheme,
    this.onTap,
  });

  final FlightResultItem flight;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback? onTap;

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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      '${flight.airlineName} • ${flight.flightNumbers}',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          flight.departureTime,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          flight.departureCity,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          flight.duration,
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 1,
                              width: 40,
                              decoration: BoxDecoration(
                                color: colorScheme.outline.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Icon(
                                Icons.flight_rounded,
                                size: 16,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Container(
                              height: 1,
                              width: 40,
                              decoration: BoxDecoration(
                                color: colorScheme.outline.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          flight.stops,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          flight.arrivalNextDay
                              ? '+1d ${flight.arrivalTime}'
                              : flight.arrivalTime,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          flight.arrivalCity,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (flight.layoverText != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.circle, size: 6, color: AppColors.accentOrange),
                    const SizedBox(width: 6),
                    Text(
                      flight.layoverText!,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
              if (flight.offerText != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    flight.offerText!,
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.accentGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _formatPrice(flight.price),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
