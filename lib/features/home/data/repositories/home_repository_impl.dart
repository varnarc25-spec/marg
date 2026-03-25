import '../../domain/entities/home_section.dart';
import '../../domain/repositories/home_repository.dart';
import '../services/home_api_service.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._apiService);

  final HomeApiService _apiService;

  @override
  Future<List<HomeSection>> fetchHomeSections({
    bool forceRefresh = false,
  }) async {
    final fresh = await _apiService.getHome();
    return fresh.toEntity().sections;
  }
}
