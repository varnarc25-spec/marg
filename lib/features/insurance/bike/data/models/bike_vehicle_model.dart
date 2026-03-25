/// Model for bike/vehicle details from API or minimal fallback.
class BikeVehicleModel {
  /// Normalized registration (uppercase, no spaces).
  final String registrationNumber;
  final String ownerName;
  final String model;
  /// From API when available.
  final DateTime? registrationDate;
  final DateTime? insuranceExpiry;

  const BikeVehicleModel({
    required this.registrationNumber,
    required this.ownerName,
    required this.model,
    this.registrationDate,
    this.insuranceExpiry,
  });

  /// When vehicle API returns nothing: registration only; user refines model on next step.
  factory BikeVehicleModel.registrationOnly(String normalizedRegistration) {
    return BikeVehicleModel(
      registrationNumber: normalizedRegistration,
      ownerName: '—',
      model: 'Select your bike (next step)',
      registrationDate: null,
      insuranceExpiry: null,
    );
  }
}
