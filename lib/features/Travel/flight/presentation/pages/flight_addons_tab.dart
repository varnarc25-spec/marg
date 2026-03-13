import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

/// Add-ons tab: Xpress Ahead priority + excess baggage options.
class FlightAddonsTab extends StatefulWidget {
  const FlightAddonsTab({
    super.key,
    required this.passengerName,
    required this.routeLabel,
    required this.onAddonPriceChanged,
  });

  final String passengerName;
  final String routeLabel;
  final ValueChanged<int> onAddonPriceChanged;

  @override
  State<FlightAddonsTab> createState() => _FlightAddonsTabState();
}

class _FlightAddonsTabState extends State<FlightAddonsTab> {
  bool _priorityAdded = false;
  int? _selectedBaggageIndex;

  static const _priorityPrice = 550;

  static const _baggageOptions = [
    _BaggageOption('Excess Baggage', 3, 1800),
    _BaggageOption('Cabin Baggage', 3, 2100),
    _BaggageOption('Excess Baggage', 5, 3000),
    _BaggageOption('Cabin Baggage', 5, 3500),
    _BaggageOption('Excess Baggage', 10, 6000),
    _BaggageOption('Excess Baggage', 15, 9000),
    _BaggageOption('Excess Baggage', 25, 15000),
  ];

  void _recalcTotal() {
    int total = 0;
    if (_priorityAdded) total += _priorityPrice;
    if (_selectedBaggageIndex != null) {
      total += _baggageOptions[_selectedBaggageIndex!].price;
    }
    widget.onAddonPriceChanged(total);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        // Route
        Row(
          children: [
            Icon(Icons.flight_rounded, size: 18, color: colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              widget.routeLabel,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ── Xpress Ahead ──
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.workspace_premium_rounded,
                        size: 22, color: AppColors.accentOrange),
                    const SizedBox(width: 8),
                    Text(
                      'Xpress Ahead',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'T&C',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Get your bag(s) before anyone else! Skip the queue with priority check-in at dedicated counters',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Price + Add
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.routeLabel}',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '₹$_priorityPrice for 1 Passenger',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '₹$_priorityPrice per Passenger',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _priorityAdded
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.accentGreen),
                            ),
                            child: Text(
                              'Added',
                              style: textTheme.labelMedium?.copyWith(
                                color: AppColors.accentGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() => _priorityAdded = true);
                              _recalcTotal();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primaryBlue.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add, size: 14,
                                      color: AppColors.primaryBlue),
                                  Text(
                                    'Add',
                                    style: textTheme.labelMedium?.copyWith(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 14),

                // Priority features
                _PriorityFeature(
                  icon: Icons.chevron_right_rounded,
                  title: 'Priority Check-In',
                  subtitle: 'Avoid queues for baggage, boarding passes',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _PriorityFeature(
                  icon: Icons.front_hand_rounded,
                  title: 'Priority Boarding',
                  subtitle: 'Board our flights before everyone else',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _PriorityFeature(
                  icon: Icons.luggage_rounded,
                  title: 'Priority Baggage',
                  subtitle: 'Eliminate wait time after touch down',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ── Excess Baggage ──
        Text(
          'Excess Baggage',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your baggage allowance for the flight includes 15 kg of checked baggage and 7 kg of cabin baggage.',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),

        // Passenger chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryBlue.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.passengerName,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                _selectedBaggageIndex != null
                    ? '${_baggageOptions[_selectedBaggageIndex!].label} ${_baggageOptions[_selectedBaggageIndex!].kg} Kg added'
                    : 'Add Baggage',
                style: textTheme.bodySmall?.copyWith(
                  color: _selectedBaggageIndex != null
                      ? AppColors.accentGreen
                      : AppColors.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Baggage options
        ...List.generate(_baggageOptions.length, (i) {
          final opt = _baggageOptions[i];
          final selected = _selectedBaggageIndex == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${opt.label}  ${opt.kg} Kg  at  ₹${_formatPrice(opt.price)}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                selected
                    ? GestureDetector(
                        onTap: () {
                          setState(() => _selectedBaggageIndex = null);
                          _recalcTotal();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.accentGreen),
                          ),
                          child: Text(
                            'Added',
                            style: textTheme.labelMedium?.copyWith(
                              color: AppColors.accentGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() => _selectedBaggageIndex = i);
                          _recalcTotal();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primaryBlue.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 14,
                                  color: AppColors.primaryBlue),
                              Text(
                                'Add',
                                style: textTheme.labelMedium?.copyWith(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ── Priority feature row ──

class _PriorityFeature extends StatelessWidget {
  const _PriorityFeature({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorScheme,
    required this.textTheme,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
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
    );
  }
}

// ── Data ──

class _BaggageOption {
  const _BaggageOption(this.label, this.kg, this.price);
  final String label;
  final int kg;
  final int price;
}

String _formatPrice(int price) {
  final s = price.toString();
  if (s.length <= 3) return s;
  final parts = <String>[];
  parts.add(s.substring(s.length - 3));
  var i = s.length - 3;
  while (i > 0) {
    final end = i;
    final start = i - 2 >= 0 ? i - 2 : 0;
    parts.insert(0, s.substring(start, end));
    i -= 2;
  }
  return parts.join(',');
}
