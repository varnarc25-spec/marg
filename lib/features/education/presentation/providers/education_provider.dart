import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/education_institution.dart';
import '../../data/repositories/education_repository.dart';

final educationRepositoryProvider = Provider<EducationRepository>((ref) => EducationRepository());
final selectedEducationInstitutionProvider = StateProvider<EducationInstitution?>((ref) => null);
