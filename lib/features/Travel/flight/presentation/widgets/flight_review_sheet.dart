import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../pages/flight_booking_confirmed_page.dart';

/// Data passed to the review sheet for displaying the fare breakdown.
class FlightReviewData {
  const FlightReviewData({
    required this.airFare,
    this.convenienceFee = 400,
    this.addOns = 0,
    this.cancellationLabel,
    this.cancellationFee = 0,
    this.promoDiscount = 0,
    required this.dateLabel,
    required this.route,
    required this.departureTime,
    required this.arrivalTime,
    required this.fareName,
    required this.airlineName,
    required this.flightNumber,
    required this.cabinClass,
    required this.duration,
    required this.stops,
    required this.passengerName,
    this.seatLabel,
    required this.fromCode,
    required this.toCode,
    required this.departureCity,
    required this.arrivalCity,
  });

  final int airFare;
  final int convenienceFee;
  final int addOns;
  final String? cancellationLabel;
  final int cancellationFee;
  final int promoDiscount;
  final String dateLabel;
  final String route;
  final String departureTime;
  final String arrivalTime;
  final String fareName;
  final String airlineName;
  final String flightNumber;
  final String cabinClass;
  final String duration;
  final String stops;
  final String passengerName;
  final String? seatLabel;
  final String fromCode;
  final String toCode;
  final String departureCity;
  final String arrivalCity;

  int get grandTotal =>
      airFare + convenienceFee + addOns + cancellationFee - promoDiscount;
}

/// Shows the "Review Your Trip Details" bottom sheet with a 10-minute countdown.
Future<void> showFlightReviewSheet(
  BuildContext context, {
  required FlightReviewData data,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FlightReviewSheet(data: data),
  );
}

class _FlightReviewSheet extends StatefulWidget {
  const _FlightReviewSheet({required this.data});
  final FlightReviewData data;

  @override
  State<_FlightReviewSheet> createState() => _FlightReviewSheetState();
}

class _FlightReviewSheetState extends State<_FlightReviewSheet> {
  late Timer _timer;
  int _secondsLeft = 10 * 60; // 10 minutes

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timerText {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '${m}m:${s}s left';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final data = widget.data;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Review Your Trip Details',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded, size: 20,
                        color: colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),

          // Timer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.access_time_rounded, size: 18,
                    color: AppColors.accentOrange),
                const SizedBox(width: 6),
                Text(
                  _timerText,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.accentRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  ' to make a payment & Confirm booking',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Fare breakdown ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      children: [
                        _FareRow(
                          label: 'Air Fare',
                          amount: data.airFare,
                          textTheme: textTheme,
                          colorScheme: colorScheme,
                        ),
                        _FareRow(
                          label: 'Convenience Fee',
                          amount: data.convenienceFee,
                          textTheme: textTheme,
                          colorScheme: colorScheme,
                        ),
                        if (data.addOns > 0)
                          _FareRow(
                            label: 'Add-Ons',
                            amount: data.addOns,
                            textTheme: textTheme,
                            colorScheme: colorScheme,
                          ),
                        if (data.cancellationLabel != null &&
                            data.cancellationFee > 0)
                          _FareRow(
                            label:
                                'Free Cancellation - ${data.cancellationLabel}',
                            amount: data.cancellationFee,
                            textTheme: textTheme,
                            colorScheme: colorScheme,
                          ),
                        if (data.promoDiscount > 0)
                          _FareRow(
                            label: 'Promo Discount',
                            amount: -data.promoDiscount,
                            isDiscount: true,
                            textTheme: textTheme,
                            colorScheme: colorScheme,
                          ),
                        const SizedBox(height: 8),
                        Divider(
                          color: colorScheme.outline.withValues(alpha: 0.15),
                          height: 1,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grand Total',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              _formatPrice(data.grandTotal),
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Flight details card ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date
                        Row(
                          children: [
                            Icon(Icons.flight_rounded, size: 18,
                                color: colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              data.dateLabel.toUpperCase(),
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Route
                        Text(
                          data.route,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Times + fare badge
                        Row(
                          children: [
                            Text(
                              data.departureTime,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '  —  ',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              data.arrivalTime,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.accentOrange,
                                ),
                              ),
                              child: Text(
                                data.fareName,
                                style: textTheme.labelSmall?.copyWith(
                                  color: AppColors.accentOrange,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Info rows
                        _InfoRow(
                          icon: Icons.airlines_rounded,
                          text: '${data.airlineName} ${data.flightNumber}',
                          textTheme: textTheme,
                          colorScheme: colorScheme,
                        ),
                        _InfoRow(
                          icon: Icons.event_seat_rounded,
                          text:
                              '${data.cabinClass}  •  ${data.fareName}',
                          textTheme: textTheme,
                          colorScheme: colorScheme,
                        ),
                        _InfoRow(
                          icon: Icons.access_time_rounded,
                          text: '${data.duration}  •  ${data.stops}',
                          textTheme: textTheme,
                          colorScheme: colorScheme,
                        ),
                        _InfoRow(
                          icon: Icons.luggage_rounded,
                          text: 'Cabin baggage 7 kg (1 piece)',
                          textTheme: textTheme,
                          colorScheme: colorScheme,
                        ),
                        _InfoRow(
                          icon: Icons.luggage_rounded,
                          text: 'Check-in baggage 15 kg (1 piece)',
                          textTheme: textTheme,
                          colorScheme: colorScheme,
                        ),

                        // Passenger + seat
                        const SizedBox(height: 10),
                        Divider(
                          color: colorScheme.outline.withValues(alpha: 0.12),
                          height: 1,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data.passengerName,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (data.seatLabel != null)
                          Text(
                            'Seat: ${data.seatLabel}',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Proceed to Pay button ──
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              8 + MediaQuery.paddingOf(context).bottom,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      final bookingId =
                          (7000000000 + Random().nextInt(999999999)).toString();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FlightBookingConfirmedPage(
                            bookingId: bookingId,
                            passengerName: data.passengerName,
                            departureCode: data.fromCode,
                            departureCity: data.departureCity,
                            arrivalCode: data.toCode,
                            arrivalCity: data.arrivalCity,
                            airlineName: data.airlineName,
                            flightNumber: data.flightNumber,
                            dateLabel: data.dateLabel,
                            departureTime: data.departureTime,
                            arrivalTime: data.arrivalTime,
                            duration: data.duration,
                            stops: data.stops,
                            fareName: data.fareName,
                            cabinClass: data.cabinClass,
                            seatLabel: data.seatLabel,
                            baseFare: data.airFare,
                            taxesAndFees: data.addOns + data.cancellationFee,
                            convenienceFee: data.convenienceFee,
                            seatCharge: 0,
                            discount: data.promoDiscount,
                            orderTotal: data.grandTotal,
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Proceed to Pay ${_formatPrice(data.grandTotal)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (data.promoDiscount > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Yay! You got a discount of ${_formatPrice(data.promoDiscount)} 🥳',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.accentGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fare row ──

class _FareRow extends StatelessWidget {
  const _FareRow({
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            isDiscount
                ? '- ${_formatPrice(amount.abs())}'
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

// ── Info row ──

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.textTheme,
    required this.colorScheme,
  });

  final IconData icon;
  final String text;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
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
