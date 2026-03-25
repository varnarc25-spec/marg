import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../widgets/flight_addons_tab.dart';
import '../widgets/flight_meal_selection_tab.dart';
import '../widgets/flight_review_sheet.dart';
import '../widgets/flight_seat_selection_tab.dart';

/// Seat / Meal / Add-ons page shown after the booking details step.
class FlightSeatMealAddonsPage extends StatefulWidget {
  const FlightSeatMealAddonsPage({
    super.key,
    required this.passengerName,
    required this.routeLabel,
    required this.farePrice,
    required this.dateLabel,
    required this.route,
    required this.departureTime,
    required this.arrivalTime,
    required this.fareName,
    required this.airlineName,
    required this.flightNumber,
    required this.duration,
    required this.stops,
    this.cancellationLabel,
    this.cancellationFee = 0,
    this.promoDiscount = 0,
    required this.fromCode,
    required this.toCode,
    required this.departureCity,
    required this.arrivalCity,
  });

  final String passengerName;
  final String routeLabel;
  final int farePrice;
  final String dateLabel;
  final String route;
  final String departureTime;
  final String arrivalTime;
  final String fareName;
  final String airlineName;
  final String flightNumber;
  final String duration;
  final String stops;
  final String? cancellationLabel;
  final int cancellationFee;
  final int promoDiscount;
  final String fromCode;
  final String toCode;
  final String departureCity;
  final String arrivalCity;

  @override
  State<FlightSeatMealAddonsPage> createState() =>
      _FlightSeatMealAddonsPageState();
}

class _FlightSeatMealAddonsPageState extends State<FlightSeatMealAddonsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  String? _selectedSeat;
  int _seatPrice = 0;
  String? _selectedMeal;
  int _mealPrice = 0;
  int _addonPrice = 0;

  int get _totalFare => widget.farePrice + _seatPrice + _mealPrice + _addonPrice;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: TabBar(
          controller: _tabController,
          labelColor: colorScheme.onSurface,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: textTheme.labelLarge,
          indicatorColor: colorScheme.onSurface,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Seat'),
            Tab(text: 'Meal'),
            Tab(text: 'Add-ons'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Skip',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FlightSeatSelectionTab(
                  passengerName: widget.passengerName,
                  routeLabel: widget.routeLabel,
                  selectedSeat: _selectedSeat,
                  onSeatSelected: (seat, price) {
                    setState(() {
                      _selectedSeat = seat;
                      _seatPrice = price;
                    });
                  },
                ),
                FlightMealSelectionTab(
                  passengerName: widget.passengerName,
                  routeLabel: widget.routeLabel,
                  selectedMeal: _selectedMeal,
                  onMealSelected: (meal, price) {
                    setState(() {
                      _selectedMeal = meal;
                      _mealPrice = price;
                    });
                  },
                ),
                FlightAddonsTab(
                  passengerName: widget.passengerName,
                  routeLabel: widget.routeLabel,
                  onAddonPriceChanged: (price) {
                    setState(() => _addonPrice = price);
                  },
                ),
              ],
            ),
          ),

          // Bottom bar
          _BottomBar(
            totalFare: _totalFare,
            onContinue: () {
              final addOnsTotal = _seatPrice + _mealPrice + _addonPrice;
              showFlightReviewSheet(
                context,
                data: FlightReviewData(
                  airFare: widget.farePrice,
                  addOns: addOnsTotal,
                  cancellationLabel: widget.cancellationLabel,
                  cancellationFee: widget.cancellationFee,
                  promoDiscount: widget.promoDiscount,
                  dateLabel: widget.dateLabel,
                  route: widget.route,
                  departureTime: widget.departureTime,
                  arrivalTime: widget.arrivalTime,
                  fareName: widget.fareName,
                  airlineName: widget.airlineName,
                  flightNumber: widget.flightNumber,
                  cabinClass: 'Economy Class',
                  duration: widget.duration,
                  stops: widget.stops,
                  passengerName: widget.passengerName,
                  seatLabel: _selectedSeat,
                  fromCode: widget.fromCode,
                  toCode: widget.toCode,
                  departureCity: widget.departureCity,
                  arrivalCity: widget.arrivalCity,
                ),
              );
            },
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
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
    return Container(
      padding: EdgeInsets.fromLTRB(
        20, 12, 20, 12 + MediaQuery.paddingOf(context).bottom,
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
