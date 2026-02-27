/// Institution for fee payment. TODO: API model.
class EducationInstitution {
  final String id;
  final String name;
  final String type; // school, college, coaching
  const EducationInstitution({required this.id, required this.name, this.type = 'school'});
}
