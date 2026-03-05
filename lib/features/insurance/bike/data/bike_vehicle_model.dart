/// Model for bike/vehicle details returned by the insurance lookup.
class BikeVehicleModel {
  final String ownerName;
  final String model;
  final DateTime registrationDate;
  final DateTime insuranceExpiry;

  const BikeVehicleModel({
    required this.ownerName,
    required this.model,
    required this.registrationDate,
    required this.insuranceExpiry,
  });
}
