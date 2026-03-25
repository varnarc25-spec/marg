import '../entities/home_section.dart';

abstract class HomeRepository {
  Future<List<HomeSection>> fetchHomeSections({bool forceRefresh = false});
}
