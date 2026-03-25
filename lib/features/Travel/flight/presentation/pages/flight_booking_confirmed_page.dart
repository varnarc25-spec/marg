import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/models/flight_booking_model.dart';
import '../providers/flight_search_provider.dart';
import 'travel_flight_page.dart';

class FlightBookingConfirmedPage extends ConsumerStatefulWidget {
  const FlightBookingConfirmedPage({
    super.key,
    required this.bookingId,
    required this.passengerName,
    required this.departureCode,
    required this.departureCity,
    required this.arrivalCode,
    required this.arrivalCity,
    required this.airlineName,
    required this.flightNumber,
    required this.dateLabel,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.stops,
    this.skipLoading = false,
    this.fareName = 'Xpress Value',
    this.cabinClass = 'Economy',
    this.seatLabel,
    this.baseFare = 0,
    this.taxesAndFees = 0,
    this.convenienceFee = 0,
    this.seatCharge = 0,
    this.discount = 0,
    this.orderTotal = 0,
  });

  final String bookingId;
  final String passengerName;
  final String departureCode;
  final String departureCity;
  final String arrivalCode;
  final String arrivalCity;
  final String airlineName;
  final String flightNumber;
  final String dateLabel;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String stops;
  final bool skipLoading;
  final String fareName;
  final String cabinClass;
  final String? seatLabel;
  final int baseFare;
  final int taxesAndFees;
  final int convenienceFee;
  final int seatCharge;
  final int discount;
  final int orderTotal;

  @override
  ConsumerState<FlightBookingConfirmedPage> createState() =>
      _FlightBookingConfirmedPageState();
}

class _FlightBookingConfirmedPageState
    extends ConsumerState<FlightBookingConfirmedPage> {
  late bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = !widget.skipLoading;
    if (_loading) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _loading = false);
        _saveBooking();
      });
    }
  }

  void _saveBooking() {
    ref.read(flightBookingsProvider.notifier).add(
          FlightBooking(
            bookingId: widget.bookingId,
            passengerName: widget.passengerName,
            departureCode: widget.departureCode,
            departureCity: widget.departureCity,
            arrivalCode: widget.arrivalCode,
            arrivalCity: widget.arrivalCity,
            airlineName: widget.airlineName,
            flightNumber: widget.flightNumber,
            dateLabel: widget.dateLabel,
            departureTime: widget.departureTime,
            arrivalTime: widget.arrivalTime,
            duration: widget.duration,
            stops: widget.stops,
            bookedAt: DateTime.now(),
            fareName: widget.fareName,
            cabinClass: widget.cabinClass,
            seatLabel: widget.seatLabel,
            baseFare: widget.baseFare,
            taxesAndFees: widget.taxesAndFees,
            convenienceFee: widget.convenienceFee,
            seatCharge: widget.seatCharge,
            discount: widget.discount,
            orderTotal: widget.orderTotal,
          ),
        );
  }

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const TravelFlightPage()),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome();
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: _loading
            ? null
            : AppBar(
                title: Text('Booking ID - ${widget.bookingId}'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goHome,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _loading
              ? _LoadingView(colorScheme: colorScheme, textTheme: textTheme)
              : _ConfirmedView(
                  widget: widget,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
        ),
      ),
    );
  }
}

// ── Loading state ──

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.colorScheme, required this.textTheme});
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('loading'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Processing your payment...',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we confirm your booking',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Confirmed state ──

class _ConfirmedView extends StatelessWidget {
  const _ConfirmedView({
    required this.widget,
    required this.colorScheme,
    required this.textTheme,
  });

  final FlightBookingConfirmedPage widget;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('confirmed'),
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Checkmark
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.accentGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 16),

          Text(
            'Booking Confirmed',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Ticket emailed to you. Have a safe trip!',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.download_rounded,
                  label: 'Download\nTicket',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.cancel_outlined,
                  label: 'Cancel\nBooking',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.schedule_rounded,
                  label: 'Modify\nBooking',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Route banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue,
                  AppColors.primaryBlue.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.departureCode,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.departureCity.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.flight_rounded, size: 28, color: Colors.white),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.arrivalCode,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.arrivalCity.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Flight info card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.airlines_rounded, size: 20,
                        color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.airlineName} ${widget.flightNumber}',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Departure & Arrival
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Departure
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.dateLabel,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.departureTime,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.departureCity,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Duration
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          widget.duration,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.stops.toUpperCase(),
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),

                    // Arrival
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.dateLabel,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.arrivalTime,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.arrivalCity,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ── Action button ──

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(icon, size: 22, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
