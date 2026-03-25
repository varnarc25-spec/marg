import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/api_config.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../data/models/app_banner_model.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../data/services/home_api_service.dart';
import '../../domain/entities/home_section.dart';
import '../../domain/repositories/home_repository.dart';

final homeApiServiceProvider = Provider<HomeApiService>((ref) {
  final client = ref.watch(loggingHttpClientProvider);
  return HomeApiService(client: client, baseUrl: ApiConfig.baseUrl);
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final api = ref.watch(homeApiServiceProvider);
  return HomeRepositoryImpl(api);
});

class HomeSectionsNotifier extends AsyncNotifier<List<HomeSection>> {
  @override
  Future<List<HomeSection>> build() async {
    final repository = ref.watch(homeRepositoryProvider);
    return repository.fetchHomeSections();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(homeRepositoryProvider);
      return repository.fetchHomeSections(forceRefresh: true);
    });
  }
}

final homeSectionsProvider =
    AsyncNotifierProvider<HomeSectionsNotifier, List<HomeSection>>(
      HomeSectionsNotifier.new,
    );

/// GET /api/banners?page_slug=home — promos above dynamic sections.
final homeBannersProvider =
    FutureProvider.autoDispose<List<AppBanner>>((ref) async {
  final api = ref.watch(margApiServiceProvider);
  return api.getBannersForPage(pageSlug: 'home');
});
