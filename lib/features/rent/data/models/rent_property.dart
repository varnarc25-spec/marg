/// Property for rent payment. TODO: API model.
class RentProperty {
  final String id;
  final String address;
  final String ownerName;
  final String ownerPhone;
  final double monthlyRent;
  final bool autopayEnabled;
  const RentProperty({
    required this.id,
    required this.address,
    required this.ownerName,
    this.ownerPhone = '',
    this.monthlyRent = 0,
    this.autopayEnabled = false,
  });
}
