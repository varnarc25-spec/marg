import 'dart:math';

/// Represents a completed flight booking stored in local state.
class FlightBooking {
  FlightBooking({
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
    required this.bookedAt,
    this.status = 'Confirmed',
    this.fareName = 'Xpress Value',
    this.cabinClass = 'Economy',
    this.seatLabel,
    this.baseFare = 0,
    this.taxesAndFees = 0,
    this.convenienceFee = 0,
    this.seatCharge = 0,
    this.discount = 0,
    this.orderTotal = 0,
    String? pnr,
  }) : pnr = pnr ?? _generatePnr();

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
  final DateTime bookedAt;
  final String status;
  final String fareName;
  final String cabinClass;
  final String? seatLabel;
  final int baseFare;
  final int taxesAndFees;
  final int convenienceFee;
  final int seatCharge;
  final int discount;
  final int orderTotal;
  final String pnr;

  static String _generatePnr() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rng = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(rng.nextInt(chars.length))),
    );
  }
}
