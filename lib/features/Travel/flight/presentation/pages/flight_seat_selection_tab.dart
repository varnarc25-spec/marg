import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

/// Seat selection tab with airplane seat grid.
class FlightSeatSelectionTab extends StatelessWidget {
  const FlightSeatSelectionTab({
    super.key,
    required this.passengerName,
    required this.routeLabel,
    required this.selectedSeat,
    required this.onSeatSelected,
  });

  final String passengerName;
  final String routeLabel;
  final String? selectedSeat;
  final void Function(String seatId, int price) onSeatSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final rows = _buildSeatMap();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select your preferred seat',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.flight_rounded, size: 18, color: colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    routeLabel,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _PassengerChip(
                name: passengerName,
                seatLabel: selectedSeat != null ? '$selectedSeat Aisle' : null,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Column headers A B C | | D E F
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (final col in ['A', 'B', 'C'])
                _ColHeader(label: col, textTheme: textTheme, colorScheme: colorScheme),
              const SizedBox(width: 32),
              for (final col in ['D', 'E', 'F'])
                _ColHeader(label: col, textTheme: textTheme, colorScheme: colorScheme),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Seat grid
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: rows.length,
            itemBuilder: (context, i) {
              final row = rows[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    // Left side: A, B, C
                    for (int c = 0; c < 3; c++)
                      _SeatCell(
                        seat: row.seats[c],
                        seatId: '${row.rowNumber}${String.fromCharCode(65 + c)}',
                        selected: selectedSeat == '${row.rowNumber}${String.fromCharCode(65 + c)}',
                        onTap: row.seats[c].type == _SeatType.available
                            ? () => onSeatSelected(
                                  '${row.rowNumber}${String.fromCharCode(65 + c)}',
                                  row.seats[c].price,
                                )
                            : null,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                    // Row number
                    SizedBox(
                      width: 32,
                      child: Center(
                        child: Text(
                          '${row.rowNumber}',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    // Right side: D, E, F
                    for (int c = 3; c < 6; c++)
                      _SeatCell(
                        seat: row.seats[c],
                        seatId: '${row.rowNumber}${String.fromCharCode(65 + c - 3 + 3)}',
                        selected: selectedSeat == '${row.rowNumber}${String.fromCharCode(65 + c - 3 + 3)}',
                        onTap: row.seats[c].type == _SeatType.available
                            ? () => onSeatSelected(
                                  '${row.rowNumber}${String.fromCharCode(65 + c - 3 + 3)}',
                                  row.seats[c].price,
                                )
                            : null,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                  ],
                ),
              );
            },
          ),
        ),

        // Offer banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: AppColors.accentGreen.withValues(alpha: 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.accentOrange),
              const SizedBox(width: 6),
              Text(
                'Upto 30% off ',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.accentRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'applied on all seats. Book now!',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.accentGreen,
                ),
              ),
            ],
          ),
        ),

        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _LegendItem(
                label: 'Extra Legroom',
                prefix: 'XL',
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(width: 16),
              _LegendItem(
                icon: Icons.airline_seat_recline_normal_rounded,
                label: 'Non-reclining',
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(width: 16),
              _LegendItem(
                icon: Icons.warning_amber_rounded,
                label: 'Emergency Exit',
                iconColor: AppColors.accentRed,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Passenger chip ──

class _PassengerChip extends StatelessWidget {
  const _PassengerChip({
    required this.name,
    this.seatLabel,
    required this.colorScheme,
    required this.textTheme,
  });

  final String name;
  final String? seatLabel;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
          if (seatLabel != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded, size: 14, color: AppColors.accentGreen),
                const SizedBox(width: 4),
                Text(
                  seatLabel!,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.accentGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ── Column header ──

class _ColHeader extends StatelessWidget {
  const _ColHeader({
    required this.label,
    required this.textTheme,
    required this.colorScheme,
  });

  final String label;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Single seat cell ──

class _SeatCell extends StatelessWidget {
  const _SeatCell({
    required this.seat,
    required this.seatId,
    required this.selected,
    this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final _Seat seat;
  final String seatId;
  final bool selected;
  final VoidCallback? onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    if (seat.type == _SeatType.empty) {
      return const Expanded(child: SizedBox(height: 44));
    }
    if (seat.type == _SeatType.blocked) {
      return Expanded(
        child: SizedBox(
          height: 44,
          child: Center(
            child: Icon(
              Icons.close_rounded,
              size: 16,
              color: colorScheme.outline.withValues(alpha: 0.35),
            ),
          ),
        ),
      );
    }

    final isXL = seat.isXL;
    final priceLabel = seat.price >= 1000
        ? '₹${(seat.price / 1000).toStringAsFixed(1)}k'
        : '₹${seat.price}';

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryBlue.withValues(alpha: 0.12)
                : AppColors.primaryBlueLight.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected
                  ? AppColors.primaryBlue
                  : AppColors.primaryBlueLight.withValues(alpha: 0.4),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isXL)
                Text(
                  'XL',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    fontSize: 9,
                    height: 1,
                  ),
                ),
              Text(
                priceLabel,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Legend item ──

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    this.prefix,
    this.icon,
    required this.label,
    this.iconColor,
    required this.colorScheme,
    required this.textTheme,
  });

  final String? prefix;
  final IconData? icon;
  final String label;
  final Color? iconColor;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefix != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              prefix!,
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 9,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        if (icon != null)
          Icon(icon, size: 16, color: iconColor ?? colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ── Seat data model ──

enum _SeatType { available, blocked, empty }

class _Seat {
  const _Seat.available(this.price, {this.isXL = false}) : type = _SeatType.available;
  const _Seat.blocked() : type = _SeatType.blocked, price = 0, isXL = false;
  const _Seat.empty() : type = _SeatType.empty, price = 0, isXL = false;

  final _SeatType type;
  final int price;
  final bool isXL;
}

class _SeatRow {
  const _SeatRow(this.rowNumber, this.seats);
  final int rowNumber;
  final List<_Seat> seats; // always 6: A B C D E F
}

const _b = _Seat.blocked();
const _e = _Seat.empty();
_Seat _s(int p) => _Seat.available(p);
_Seat _xl(int p) => _Seat.available(p, isXL: true);

List<_SeatRow> _buildSeatMap() {
  return [
    _SeatRow(1, [_b, _xl(1400), _xl(1400), _xl(1400), _xl(1400), _xl(1400)]),
    _SeatRow(2, [_b, _s(455), _s(455), _s(455), _s(455), _s(455)]),
    _SeatRow(3, [_e, _e, _s(385), _s(385), _s(385), _e]),
    _SeatRow(4, [_s(385), _s(385), _b, _b, _s(385), _s(385)]),
    _SeatRow(5, [_s(385), _s(385), _s(385), _s(385), _s(385), _s(385)]),
    _SeatRow(6, [_s(315), _s(315), _b, _s(315), _e, _s(315)]),
    _SeatRow(7, [_s(315), _s(315), _s(315), _s(315), _s(315), _s(315)]),
    _SeatRow(8, [_s(315), _s(315), _s(315), _s(315), _s(315), _s(315)]),
    _SeatRow(9, [_b, _s(280), _s(280), _s(280), _s(280), _s(280)]),
    _SeatRow(10, [_s(280), _s(280), _s(280), _s(280), _s(280), _s(280)]),
    _SeatRow(11, [_s(280), _b, _b, _b, _b, _s(280)]),
    _SeatRow(12, [_xl(560), _xl(560), _xl(560), _xl(560), _xl(560), _xl(560)]),
    _SeatRow(14, [_xl(750), _xl(750), _xl(750), _xl(750), _xl(750), _b]),
    _SeatRow(15, [_s(280), _s(280), _s(280), _s(280), _s(280), _s(280)]),
    _SeatRow(16, [_b, _b, _s(280), _s(280), _s(280), _s(280)]),
    _SeatRow(17, [_s(280), _s(280), _s(280), _s(280), _s(280), _s(280)]),
    _SeatRow(18, [_s(280), _s(280), _s(280), _s(280), _s(280), _s(280)]),
    _SeatRow(19, [_s(280), _s(280), _s(280), _s(280), _s(280), _s(280)]),
    _SeatRow(20, [_s(280), _s(280), _s(280), _s(280), _s(280), _s(280)]),
    _SeatRow(21, [_s(280), _s(210), _s(280), _s(280), _s(210), _s(280)]),
    _SeatRow(22, [_s(210), _s(210), _b, _b, _b, _b]),
    _SeatRow(23, [_b, _b, _b, _b, _b, _b]),
    _SeatRow(24, [_s(210), _s(210), _b, _s(210), _s(210), _s(210)]),
    _SeatRow(25, [_s(210), _s(210), _s(210), _s(210), _s(210), _s(210)]),
    _SeatRow(26, [_s(210), _b, _s(210), _s(210), _b, _s(210)]),
    _SeatRow(27, [_s(210), _b, _s(210), _s(210), _b, _s(210)]),
    _SeatRow(28, [_s(210), _b, _s(210), _s(210), _b, _s(210)]),
    _SeatRow(29, [_s(210), _b, _s(210), _s(210), _b, _s(210)]),
    _SeatRow(30, [_s(210), _b, _s(210), _s(210), _b, _s(210)]),
    _SeatRow(31, [_b, _b, _s(210), _s(210), _b, _b]),
    _SeatRow(32, [_b, _b, _b, _b, _b, _b]),
  ];
}
