import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/models/flight_result_model.dart';
import '../widgets/flight_booking_flight_card.dart';
import '../widgets/flight_booking_offers_section.dart';
import '../widgets/flight_booking_traveller_section.dart';
import 'flight_seat_meal_addons_page.dart';

/// Full-page booking flow after fare selection.
///
/// Stepper: Flight Details → Add Passenger → Make Payment.
/// Sticky bottom bar with fare breakup + Continue.
class FlightBookingPage extends StatefulWidget {
  const FlightBookingPage({
    super.key,
    required this.flight,
    required this.fareName,
    required this.farePrice,
    required this.dateLabel,
    required this.route,
    required this.fromCode,
    required this.toCode,
  });

  final FlightResultItem flight;
  final String fareName;
  final int farePrice;
  final String dateLabel;
  final String route;
  final String fromCode;
  final String toCode;

  @override
  State<FlightBookingPage> createState() => _FlightBookingPageState();
}

class _FlightBookingPageState extends State<FlightBookingPage> {
  bool _flightDetailsComplete = true;
  bool _passengerSaved = false;
  bool _contactSaved = false;
  String _passengerName = '';
  int _cancellationOption = 0; // 0 = None, 1 = Classic
  int? _selectedOffer;

  int get _totalFare {
    var total = widget.farePrice;
    if (_cancellationOption == 1) total += 565;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Flight Details',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: colorScheme.surface,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: _BookingStepper(
                  flightDetailsComplete: _flightDetailsComplete,
                  passengerComplete: _passengerSaved,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    16, 8, 16, 100 + MediaQuery.paddingOf(context).bottom,
                  ),
                  children: [
                    FlightBookingFlightCard(
                      flight: widget.flight,
                      fareName: widget.fareName,
                      dateLabel: widget.dateLabel,
                      route: widget.route,
                      cancellationOption: _cancellationOption,
                      onCancellationChanged: (v) =>
                          setState(() => _cancellationOption = v),
                    ),
                    const SizedBox(height: 16),
                    FlightBookingOffersSection(
                      selectedOffer: _selectedOffer,
                      onOfferChanged: (v) =>
                          setState(() => _selectedOffer = v),
                    ),
                    const SizedBox(height: 16),
                    FlightBookingTravellerSection(
                      passengerSaved: _passengerSaved,
                      contactSaved: _contactSaved,
                      onPassengerSaved: (name) =>
                          setState(() {
                            _passengerSaved = true;
                            _passengerName = name;
                          }),
                      onContactSaved: () =>
                          setState(() => _contactSaved = true),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16 + MediaQuery.paddingOf(context).bottom,
            child: _BottomFareBar(
              totalFare: _totalFare,
              onContinue: () {
                if (!_passengerSaved || !_contactSaved) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please save traveller details and add contact info first.',
                      ),
                    ),
                  );
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FlightSeatMealAddonsPage(
                      passengerName: _passengerName,
                      routeLabel:
                          '${widget.flight.departureCity} - ${widget.flight.arrivalCity}',
                      farePrice: _totalFare,
                      dateLabel: widget.dateLabel,
                      route:
                          '${widget.flight.departureCity}  ➜  ${widget.flight.arrivalCity}',
                      departureTime: widget.flight.departureTime,
                      arrivalTime: widget.flight.arrivalTime,
                      fareName: widget.fareName,
                      airlineName: widget.flight.airlineName,
                      flightNumber: widget.flight.flightNumbers,
                      duration: widget.flight.duration,
                      stops: widget.flight.stops,
                      cancellationLabel:
                          _cancellationOption == 1 ? 'Classic' : null,
                      cancellationFee: _cancellationOption == 1 ? 565 : 0,
                      promoDiscount: _selectedOffer == 0 ? 500 : (_selectedOffer == 1 ? 1026 : 0),
                      fromCode: widget.fromCode,
                      toCode: widget.toCode,
                      departureCity: widget.flight.departureCity,
                      arrivalCity: widget.flight.arrivalCity,
                    ),
                  ),
                );
              },
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stepper ──

class _BookingStepper extends StatelessWidget {
  const _BookingStepper({
    required this.flightDetailsComplete,
    required this.passengerComplete,
    required this.colorScheme,
    required this.textTheme,
  });

  final bool flightDetailsComplete;
  final bool passengerComplete;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepDot(
          label: 'Flight Details',
          active: true,
          complete: flightDetailsComplete,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        Expanded(
          child: Container(
            height: 2,
            color: passengerComplete
                ? AppColors.accentGreen
                : colorScheme.outline.withValues(alpha: 0.25),
          ),
        ),
        _StepDot(
          label: 'Add Passenger',
          active: passengerComplete,
          complete: passengerComplete,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        Expanded(
          child: Container(
            height: 2,
            color: colorScheme.outline.withValues(alpha: 0.25),
          ),
        ),
        _StepDot(
          label: 'Make Payment',
          active: false,
          complete: false,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.active,
    required this.complete,
    required this.colorScheme,
    required this.textTheme,
  });

  final String label;
  final bool active;
  final bool complete;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: complete
                ? AppColors.accentGreen
                : Colors.transparent,
            border: Border.all(
              color: active
                  ? AppColors.accentGreen
                  : colorScheme.outline.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: active
                ? AppColors.accentGreen
                : colorScheme.onSurfaceVariant,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Bottom fare bar ──

class _BottomFareBar extends StatelessWidget {
  const _BottomFareBar({
    required this.totalFare,
    required this.onContinue,
    required this.colorScheme,
    required this.textTheme,
  });

  final int totalFare;
  final VoidCallback onContinue;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(20),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fare Breakup',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _formatPrice(totalFare),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: onContinue,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
        ),
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
