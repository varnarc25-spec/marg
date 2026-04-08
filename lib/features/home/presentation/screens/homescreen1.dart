import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/widgets/marg_header.dart';
import '../../../accounts/presentation/screens/my_account_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../learning/presentation/screens/learning_hub_screen.dart';
import '../../../scan/presentation/screens/scan_qr_screen.dart';
import '../../domain/entities/home_section.dart';
import '../providers/home_dynamic_provider.dart';
import '../widgets/dynamic_home_banners_widget.dart';
import '../widgets/home_skeleton_shimmer.dart';
import '../widgets/home_widgets.dart';
import '../utils/recharges_bills_hub.dart';
import '../widgets/section_widget.dart';
import 'ai_assistant_screen.dart';
import 'home_screen.dart' as classic_home;
import 'wealth_home_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(homeBannersProvider);
    await ref.read(homeSectionsProvider.notifier).refresh();
    await ref.read(appRemoteSettingsProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    final sectionsAsync = ref.watch(homeSectionsProvider);
    final remoteBrand = ref.watch(appRemoteSettingsProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            MargHeader(
              l10n: l10n,
              brandName: remoteBrand?.displayAppName,
              logoUrl: remoteBrand?.logoUrl,
              onHome1Tap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const classic_home.HomeScreen(),
                  ),
                );
              },
              onAiTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AiAssistantScreen()),
                );
              },
            ),
            // const HomeHeader(),
            // const HomeInsuranceBanner(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _refresh(ref),
                child: sectionsAsync.when(
                  data: (sections) {
                    return _HomeDynamicScrollView(sections: sections);
                  },
                  loading: () => const HomeSkeletonShimmer(),
                  error: (error, _) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 80),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                const Text(
                                  'Failed to load home data',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  error.toString(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 16),
                                FilledButton(
                                  onPressed: () {
                                    ref.invalidate(homeBannersProvider);
                                    ref.invalidate(homeSectionsProvider);
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            HomeBottomNav(
              onWealthTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WealthHomeScreen()),
                );
              },
              onScanTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const ScanQrScreen()));
              },
              onDiscoverTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LearningHubScreen()),
                );
              },
              onProfileTap: () async {
                final authService = ref.read(firebaseAuthServiceProvider);
                if (authService.isLoggedIn()) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MyAccountScreen()),
                  );
                } else {
                  final loggedIn = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                  if (loggedIn == true && context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MyAccountScreen(),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeDynamicScrollView extends ConsumerWidget {
  const _HomeDynamicScrollView({required this.sections});

  final List<HomeSection> sections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsync = ref.watch(homeBannersProvider);

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: bannersAsync.when(
            data: (banners) {
              if (banners.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: DynamicHomeBannersWidget(banners: banners),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              // child: HomeBannerShimmer(),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),
        if (sections.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('No services available')),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final section = sections[index];
                return SectionWidget(
                  section: section,
                  onViewAllTap: viewAllOnTapForDynamicHomeSection(
                    context,
                    ref,
                    section.slug,
                  ),
                );
              }, childCount: sections.length),
            ),
          ),
      ],
    );
  }
}
