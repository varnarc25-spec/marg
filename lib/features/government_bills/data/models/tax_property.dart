/// Property/asset for govt tax. TODO: API model.
class TaxProperty {
  final String id;
  final String name;
  final String type; // property, vehicle, etc.
  const TaxProperty({required this.id, required this.name, this.type = 'property'});
}
