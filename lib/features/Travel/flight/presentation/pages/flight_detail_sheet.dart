import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/flight_result_model.dart';
import 'flight_booking_page.dart';

/// Shows flight details + fare selection as a bottom sheet.
///
/// Call [showFlightDetailSheet] to present it.
Future<void> showFlightDetailSheet(
  BuildContext context, {
  required FlightResultItem flight,
  required String dateLabel,
  required String route,
  required String fromCode,
  required String toCode,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FlightDetailSheet(
      flight: flight,
      dateLabel: dateLabel,
      route: route,
      fromCode: fromCode,
      toCode: toCode,
    ),
  );
}

class _FlightDetailSheet extends StatefulWidget {
  const _FlightDetailSheet({
    required this.flight,
    required this.dateLabel,
    required this.route,
    required this.fromCode,
    required this.toCode,
  });

  final FlightResultItem flight;
  final String dateLabel;
  final String route;
  final String fromCode;
  final String toCode;

  @override
  State<_FlightDetailSheet> createState() => _FlightDetailSheetState();
}

class _FlightDetailSheetState extends State<_FlightDetailSheet> {
  int _selectedFare = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.9;
    final flight = widget.flight;

    final basePrice = flight.price;
    final fares = [
      _FareOption(
        name: 'XPRESS\nVALUE',
        price: basePrice,
        recommended: false,
        seat: 'Chargeable',
        meal: 'Chargeable',
        changeFee: '₹3000 onwards',
        cancelFee: '₹4300 onwards',
        checkinBag: '15 kg / 1 piece(s)',
        handBag: '7 kg / 1 piece(s)',
      ),
      _FareOption(
        name: 'CLASSIC',
        price: basePrice + 500,
        recommended: true,
        seat: 'Included',
        meal: 'Included',
        changeFee: '₹300 onwards',
        cancelFee: '₹2000 onwards',
        checkinBag: '15 kg / 1 piece(s)',
        handBag: '7 kg / 1 piece(s)',
      ),
      _FareOption(
        name: 'XPRESS FLEX',
        price: basePrice + 1000,
        recommended: false,
        seat: 'Included',
        meal: 'Included',
        changeFee: 'Free',
        cancelFee: '₹1500 onwards',
        checkinBag: '20 kg / 1 piece(s)',
        handBag: '7 kg / 1 piece(s)',
      ),
    ];

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
                    'Flight Details',
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
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Flight info card ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.dateLabel,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          widget.route,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          color: colorScheme.outline.withValues(alpha: 0.15),
                          height: 1,
                        ),
                        const SizedBox(height: 12),

                        // Airline row
                        Row(
                          children: [
                            Icon(
                              Icons.flight_rounded,
                              size: 18,
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
                        const SizedBox(height: 16),

                        // Timeline
                        _TimelineRow(
                          time: flight.departureTime,
                          city: flight.departureCity,
                          icon: Icons.circle,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            children: [
                              Container(
                                width: 2,
                                height: 32,
                                color: colorScheme.outline.withValues(
                                  alpha: 0.25,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                'Duration ${flight.duration}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _TimelineRow(
                          time:
                              flight.arrivalNextDay
                                  ? '+1d ${flight.arrivalTime}'
                                  : flight.arrivalTime,
                          city: flight.arrivalCity,
                          icon: Icons.location_on_rounded,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Fare options header ──
                  Text(
                    'Fare options available for your trip',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Fare for 1 Traveller',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Fare cards ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(fares.length, (i) {
                      final fare = fares[i];
                      final selected = _selectedFare == i;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedFare = i),
                          child: _FareCard(
                            fare: fare,
                            selected: selected,
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  // Disclaimer
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Airline info is indicative\nPlease check the airline website for accurate policy. '
                          'Paytm is not responsible for any change in the airline policies.',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Proceed button ──
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              12 + MediaQuery.paddingOf(context).bottom,
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
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () {
                  final selectedFare = fares[_selectedFare];
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FlightBookingPage(
                        flight: flight,
                        fareName: selectedFare.name.replaceAll('\n', ' '),
                        farePrice: selectedFare.price,
                        dateLabel: widget.dateLabel,
                        route: widget.route,
                        fromCode: widget.fromCode,
                        toCode: widget.toCode,
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
                child: const Text(
                  'Proceed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ──

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.time,
    required this.city,
    required this.icon,
    required this.colorScheme,
    required this.textTheme,
  });

  final String time;
  final String city;
  final IconData icon;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Text(
          time,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            city,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _FareOption {
  const _FareOption({
    required this.name,
    required this.price,
    required this.recommended,
    required this.seat,
    required this.meal,
    required this.changeFee,
    required this.cancelFee,
    required this.checkinBag,
    required this.handBag,
  });

  final String name;
  final int price;
  final bool recommended;
  final String seat;
  final String meal;
  final String changeFee;
  final String cancelFee;
  final String checkinBag;
  final String handBag;
}

class _FareCard extends StatelessWidget {
  const _FareCard({
    required this.fare,
    required this.selected,
    required this.colorScheme,
    required this.textTheme,
  });

  final _FareOption fare;
  final bool selected;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? AppColors.primaryBlue : colorScheme.outline.withValues(alpha: 0.25);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: selected ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Recommended badge
          if (fare.recommended)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accentOrange,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Text(
                'Recommended Fare',
                textAlign: TextAlign.center,
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 9,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Radio + name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Radio<bool>(
                        value: true,
                        groupValue: selected,
                        onChanged: null,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        fare.name,
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                Text(
                  _formatPrice(fare.price),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 10),
                _FareDetailRow(
                  label: 'Seat',
                  value: fare.seat,
                  highlight: fare.seat == 'Included',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _FareDetailRow(
                  label: 'Meal',
                  value: fare.meal,
                  highlight: fare.meal == 'Included',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _FareDetailRow(
                  label: 'Change Fee',
                  value: fare.changeFee,
                  highlight: fare.changeFee == 'Free',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _FareDetailRow(
                  label: 'Cancellation Fee',
                  value: fare.cancelFee,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _FareDetailRow(
                  label: 'Check-in baggage',
                  value: fare.checkinBag,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _FareDetailRow(
                  label: 'Hand baggage',
                  value: fare.handBag,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FareDetailRow extends StatelessWidget {
  const _FareDetailRow({
    required this.label,
    required this.value,
    this.highlight = false,
    required this.colorScheme,
    required this.textTheme,
  });

  final String label;
  final String value;
  final bool highlight;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: highlight
                  ? AppColors.primaryBlue
                  : colorScheme.onSurfaceVariant,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: textTheme.bodySmall?.copyWith(
              color: highlight
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
              fontSize: 11,
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
