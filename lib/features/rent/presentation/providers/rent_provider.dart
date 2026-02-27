import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/rent_property.dart';
import '../../data/repositories/rent_repository.dart';

final rentRepositoryProvider = Provider<RentRepository>((ref) => RentRepository());
final rentPropertiesProvider = FutureProvider<List<RentProperty>>((ref) => ref.read(rentRepositoryProvider).getProperties());
final selectedRentPropertyProvider = StateProvider<RentProperty?>((ref) => null);
