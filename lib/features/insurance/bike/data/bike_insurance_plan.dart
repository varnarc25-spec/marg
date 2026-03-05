/// A single insurance plan offer (insurer, IDV, price).
class BikeInsurancePlan {
  final String id;
  final String insurerName;
  final int idv;
  final int price;
  final String? tag;

  const BikeInsurancePlan({
    required this.id,
    required this.insurerName,
    required this.idv,
    required this.price,
    this.tag,
  });
}
