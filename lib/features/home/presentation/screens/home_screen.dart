import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../shared/providers/app_providers.dart';
import '../widgets/home_widgets.dart';
import 'wealth_home_screen.dart';
import '../../../accounts/presentation/screens/my_account_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../learning/presentation/screens/learning_hub_screen.dart';
import '../../../messages_notifications/presentation/screens/notification_list_screen.dart';
import '../../../payments/presentation/screens/add_promo_screen.dart';

/// Home Dashboard Screen
/// Search, quick actions, Financial Hub, Convenient Hub, Service Hub, Rewards Hub, bottom nav
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  HomeSectionTitle(title: l10n.homeHubFinancial),
                  const SizedBox(height: 12),
                  const HomeFinancialHub(),
                  const SizedBox(height: 24),
                  HomeSectionTitle(title: l10n.homeHubConvenient),
                  const SizedBox(height: 12),
                  const HomeConvenientHub(),
                  const SizedBox(height: 24),
                  HomeSectionTitle(title: l10n.homeHubService),
                  const SizedBox(height: 12),
                  HomeServiceHub(
                    onFirstMessageTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NotificationListScreen()),
                      );
                    },
                    onSecondMessageTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AddPromoScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  HomeSectionTitle(title: l10n.homeHubRewards),
                  const SizedBox(height: 12),
                  const HomeRewardsHub(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            HomeBottomNav(
              onWealthTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WealthHomeScreen()),
                );
              },
              onDiscoverTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LearningHubScreen()),
                );
              },
              onProfileTap: () {
                final authService = ref.read(firebaseAuthServiceProvider);
                if (authService.isLoggedIn()) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MyAccountScreen()),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
