import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/widgets/portfolio_card.dart';
import '../../../../shared/widgets/market_overview_card.dart';
import '../../../../shared/widgets/risk_meter_widget.dart';
import '../../../trade/presentation/screens/trade_guidance_screen.dart';
import '../../../learning/presentation/screens/learning_hub_screen.dart';
import '../../../journal/presentation/screens/trade_journal_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../kyc/presentation/screens/pan_verification_screen.dart';

/// Home Dashboard Screen
/// Main screen after onboarding
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final portfolioAsync = ref.watch(portfolioProvider);
    final marketDataAsync = ref.watch(marketDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: userProfileAsync.when(
          data: (profile) => Text('${AppStrings.homeGreeting}, ${profile.name}'),
          loading: () => const Text(AppStrings.homeGreeting),
          error: (_, __) => const Text(AppStrings.homeGreeting),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(portfolioProvider);
          ref.invalidate(marketDataProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Trading Mode Banner
              _buildTradingModeBanner(context, ref),
              const SizedBox(height: 16),
              // Portfolio Snapshot
              portfolioAsync.when(
                data: (portfolio) => PortfolioCard(portfolio: portfolio),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Error loading portfolio: $error'),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Risk Meter
              portfolioAsync.when(
                data: (portfolio) => RiskMeterWidget(riskLevel: portfolio.riskMeter),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),

              // Market Overview
              Text(
                AppStrings.homeMarketOverview,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              marketDataAsync.when(
                data: (marketData) => MarketOverviewCard(marketData: marketData),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Error loading market data: $error'),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      title: AppStrings.homeTradeWithGuidance,
                      icon: Icons.auto_awesome,
                      color: AppColors.primaryBlue,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TradeGuidanceScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ActionCard(
                      title: AppStrings.homePracticeStrategies,
                      icon: Icons.school,
                      color: AppColors.accentGreen,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LearningHubScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bottom Navigation Placeholder
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _BottomNavItem(
                        icon: Icons.home,
                        label: 'Home',
                        isSelected: true,
                        onTap: () {},
                      ),
                      _BottomNavItem(
                        icon: Icons.trending_up,
                        label: 'Trade',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TradeGuidanceScreen(),
                            ),
                          );
                        },
                      ),
                      _BottomNavItem(
                        icon: Icons.book,
                        label: 'Journal',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TradeJournalScreen(),
                            ),
                          );
                        },
                      ),
                      _BottomNavItem(
                        icon: Icons.school,
                        label: 'Learn',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LearningHubScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildTradingModeBanner(BuildContext context, WidgetRef ref) {
    final userSession = ref.watch(userSessionProvider);

    if (userSession == null) {
      return const SizedBox.shrink();
    }

    // Paper Trading Banner
    if (userSession.paperTradingEnabled && !userSession.realTradingEnabled) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.accentOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accentOrange.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.school_outlined,
                  color: AppColors.accentOrange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You are in Paper Trading Mode',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentOrange,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Practice with virtual money (₹10,00,000)',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Enable Real Trading Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PanVerificationScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.lock_outline),
                label: const Text('Enable Real Trading'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accentOrange,
                  side: const BorderSide(color: AppColors.accentOrange),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Real Trading Enabled
    if (userSession.realTradingEnabled) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.accentGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accentGreen.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.verified,
              color: AppColors.accentGreen,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Real Trading Enabled',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You can now trade with real money',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? AppColors.primaryBlue
                : AppColors.textSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}

