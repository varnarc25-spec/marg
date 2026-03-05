/// Model for car/vehicle details returned by the insurance lookup.
class CarVehicleModel {
  final String ownerName;
  final String model;
  final DateTime registrationDate;
  final DateTime insuranceExpiry;

  const CarVehicleModel({
    required this.ownerName,
    required this.model,
    required this.registrationDate,
    required this.insuranceExpiry,
  });
}
