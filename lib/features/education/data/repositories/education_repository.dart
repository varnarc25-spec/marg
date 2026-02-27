import '../models/education_institution.dart';

/// Education fees. TODO: BBPS/education biller API.
class EducationRepository {
  Future<List<EducationInstitution>> searchInstitutions(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      const EducationInstitution(id: '1', name: 'ABC School', type: 'school'),
      const EducationInstitution(id: '2', name: 'XYZ College', type: 'college'),
    ];
  }

  Future<List<Map<String, dynamic>>> getFeeSchedule(String institutionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {'dueDate': '2025-04-01', 'amount': 25000, 'term': 'Q1 Fee'},
      {'dueDate': '2025-07-01', 'amount': 25000, 'term': 'Q2 Fee'},
    ];
  }
}
