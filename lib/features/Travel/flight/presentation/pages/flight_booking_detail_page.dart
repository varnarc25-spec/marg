import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/flight_booking_model.dart';

class FlightBookingDetailPage extends StatelessWidget {
  const FlightBookingDetailPage({super.key, required this.booking});
  final FlightBooking booking;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Flight Booking'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header card ──
            _HeaderCard(
              booking: booking,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),

            const SizedBox(height: 4),

            // ── Booking Confirmed status ──
            _StatusBanner(
              colorScheme: colorScheme,
              textTheme: textTheme,
              booking: booking,
            ),

            const SizedBox(height: 4),

            // ── Route + Duration ──
            _RouteHeader(
              booking: booking,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),

            // ── Airline + Class + PNR ──
            _AirlineInfo(
              booking: booking,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),

            // ── Time block ──
            _TimeBlock(
              booking: booking,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),

            const SizedBox(height: 4),

            // ── Passenger table ──
            _PassengerTable(
              booking: booking,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),

            const SizedBox(height: 4),

            // ── Payment Details ──
            _PaymentDetails(
              booking: booking,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),

            const SizedBox(height: 12),

            // ── View baggage & cancellation link ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'View baggage & cancellation policy',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Header with booking ID ──

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.booking,
    required this.colorScheme,
    required this.textTheme,
  });
  final FlightBooking booking;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      color: colorScheme.surfaceContainerLow,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.flight_rounded, size: 22,
                color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flight Booking',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Booking ID: ${booking.bookingId}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy_rounded, size: 18,
                color: colorScheme.onSurfaceVariant),
            onPressed: () {},
            tooltip: 'Copy Booking ID',
          ),
        ],
      ),
    );
  }
}

// ── Status banner ──

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.colorScheme,
    required this.textTheme,
    required this.booking,
  });
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final FlightBooking booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: AppColors.accentGreen.withValues(alpha: 0.08),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, size: 20,
              color: AppColors.accentGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Confirmed',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentGreen,
                  ),
                ),
                Text(
                  '${booking.passengerName}',
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

// ── Route header ──

class _RouteHeader extends StatelessWidget {
  const _RouteHeader({
    required this.booking,
    required this.colorScheme,
    required this.textTheme,
  });
  final FlightBooking booking;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${booking.departureCity}  ➜  ${booking.arrivalCity}',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Icon(Icons.access_time_rounded, size: 15,
              color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            booking.duration,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Airline info ──

class _AirlineInfo extends StatelessWidget {
  const _AirlineInfo({
    required this.booking,
    required this.colorScheme,
    required this.textTheme,
  });
  final FlightBooking booking;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Airline row
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.airlines_rounded, size: 16,
                    color: AppColors.primaryBlue),
              ),
              const SizedBox(width: 10),
              Text(
                '${booking.airlineName} ${booking.flightNumber}',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                booking.cabinClass,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
                ),
                child: Text(
                  booking.fareName,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // PNR
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'PNR: ',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                booking.pnr,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Time block ──

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({
    required this.booking,
    required this.colorScheme,
    required this.textTheme,
  });
  final FlightBooking booking;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Departure column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      booking.departureCode,
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      booking.departureTime,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  booking.dateLabel,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.departureCity,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Duration center
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    '${booking.duration}\nduration',
                    textAlign: TextAlign.center,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Arrival column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      booking.arrivalTime,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      booking.arrivalCode,
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  booking.dateLabel,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.arrivalCity,
                  textAlign: TextAlign.end,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
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

// ── Passenger table ──

class _PassengerTable extends StatelessWidget {
  const _PassengerTable({
    required this.booking,
    required this.colorScheme,
    required this.textTheme,
  });
  final FlightBooking booking;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Name',
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Seat',
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Status',
                    textAlign: TextAlign.end,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Passenger row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    booking.passengerName,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    booking.seatLabel != null
                        ? 'Seat ${booking.seatLabel}'
                        : '—',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      booking.status,
                      textAlign: TextAlign.center,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

// ── Payment Details ──

class _PaymentDetails extends StatelessWidget {
  const _PaymentDetails({
    required this.booking,
    required this.colorScheme,
    required this.textTheme,
  });
  final FlightBooking booking;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Details',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          _PayRow(
            label: 'Base fare',
            amount: booking.baseFare,
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
          _PayRow(
            label: 'Taxes & fees',
            amount: booking.taxesAndFees,
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
          _PayRow(
            label: 'Convenience fee',
            amount: booking.convenienceFee,
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
          _PayRow(
            label: 'Seat charge',
            amount: booking.seatCharge,
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
          if (booking.discount > 0)
            _PayRow(
              label: 'Discount applied',
              amount: -booking.discount,
              isDiscount: true,
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
          const SizedBox(height: 6),
          Divider(color: colorScheme.outline.withValues(alpha: 0.12), height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Total',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                _formatPrice(booking.orderTotal),
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PayRow extends StatelessWidget {
  const _PayRow({
    required this.label,
    required this.amount,
    this.isDiscount = false,
    required this.textTheme,
    required this.colorScheme,
  });

  final String label;
  final int amount;
  final bool isDiscount;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: isDiscount
                  ? AppColors.accentGreen
                  : colorScheme.onSurface,
            ),
          ),
          Text(
            isDiscount
                ? '-${_formatPrice(amount.abs())}'
                : _formatPrice(amount),
            style: textTheme.bodyMedium?.copyWith(
              color: isDiscount
                  ? AppColors.accentGreen
                  : colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

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
