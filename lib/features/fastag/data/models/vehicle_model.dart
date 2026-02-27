/// Vehicle linked for FASTag. TODO: API model.
class VehicleModel {
  final String id;
  final String number;
  final String tagId;
  final double balance;
  const VehicleModel({required this.id, required this.number, required this.tagId, this.balance = 0});
}
