/// Single booking card data (for Completed list).
class TravelBookingItem {
  const TravelBookingItem({
    required this.bookingId,
    required this.route,
    required this.serviceDetails,
    required this.status,
    required this.dateTime,
  });

  final String bookingId;
  final String route;
  final String serviceDetails;
  final String status;
  final String dateTime;
}
