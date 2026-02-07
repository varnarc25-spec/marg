import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../accounts/presentation/screens/my_account_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../myportfolio/presentation/screens/my_portfolio_screen.dart';
import 'home_screen.dart';
import '../../../mywallet/presentation/screens/my_wallet_screen.dart';

/// Wealth / Home screen: total assets, watchlist, top gainers, promo, news, bottom nav.
/// Purple-accent design for wealth dashboard.
class WealthHomeScreen extends ConsumerWidget {
  const WealthHomeScreen({super.key});

  static const Color _wealthPurple = Color(0xFF6C63FF);
  static const Color _cardDark = Color(0xFF1E1B2E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    final authService = ref.watch(firebaseAuthServiceProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, l10n),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _buildTotalAssetCard(context, l10n),
                  const SizedBox(height: 20),
                  _buildAssetCategories(context, l10n),
                  const SizedBox(height: 24),
                  _buildWatchlistSection(context, l10n),
                  const SizedBox(height: 24),
                  _buildTopGainersSection(context, l10n),
                  const SizedBox(height: 24),
                  _buildPromoBanner(context, l10n),
                  const SizedBox(height: 24),
                  _buildLatestNewsSection(context, l10n),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            _buildBottomNav(context, l10n, authService),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 22),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          const SizedBox(width: 4),
          Icon(Icons.eco_rounded, size: 28, color: _wealthPurple),
          const SizedBox(width: 8),
          Text(
            l10n.appName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _wealthPurple,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.search_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.home_rounded, color: AppColors.textPrimary),
            onPressed: () => _goToMainHome(context),
            tooltip: l10n.wealthNavHome,
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _goToMainHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  Widget _buildTotalAssetCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _wealthPurple.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.wealthTotalAssetValue,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$56,890.00',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.visibility_outlined, size: 20, color: Colors.white.withValues(alpha: 0.7)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.wealthProfits,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text(
                '\$16,988.00',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_drop_up_rounded, color: AppColors.accentGreen, size: 20),
                    Text(
                      '+ 23.00%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCategories(BuildContext context, AppLocalizations l10n) {
    final items = [
      (Icons.show_chart_rounded, l10n.wealthStocks),
      (Icons.currency_bitcoin_rounded, l10n.wealthCrypto),
      (Icons.image_rounded, l10n.wealthNFTs),
      (Icons.diamond_rounded, l10n.wealthGold),
    ];
    return Row(
      children: items.map((e) => Expanded(
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _wealthPurple.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(e.$1, size: 26, color: _wealthPurple),
            ),
            const SizedBox(height: 8),
            Text(
              e.$2,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildWatchlistSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.wealthWatchlist,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                l10n.wealthEditWatchlist,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _wealthPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              _WatchlistTab(label: l10n.wealthCryptoAssets, selected: false),
              _WatchlistTab(label: l10n.wealthUSStocks, selected: true),
              _WatchlistTab(label: l10n.wealthGold, selected: false),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _WatchlistCard(
                symbol: 'ABNB',
                name: 'Airbnb, Inc.',
                price: '\$112.72',
                changePercent: 0.33,
                positive: true,
                iconBg: Colors.pink.shade200,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _WatchlistCard(
                symbol: 'SPOT',
                name: 'Spotify Tech',
                price: '\$82.70',
                changePercent: -0.06,
                positive: false,
                iconBg: AppColors.accentGreen.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopGainersSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  l10n.wealthTopGainers,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down_rounded, color: AppColors.textSecondary, size: 24),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                l10n.wealthSeeAll,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _wealthPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _TopGainerCard(
                name: 'Polygon',
                symbol: 'MATIC',
                price: '\$0.8016',
                changePercent: 5.87,
                iconBg: _wealthPurple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TopGainerCard(
                name: 'Bnb',
                symbol: 'BNB',
                price: '\$271.01',
                changePercent: 1.68,
                iconBg: const Color(0xFFF3BA2F),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPromoBanner(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _wealthPurple,
            _wealthPurple.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _wealthPurple.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.wealthEarnApr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.wealthEarnRewardsDesc,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Icon(Icons.savings_rounded, size: 56, color: Colors.white.withValues(alpha: 0.9)),
        ],
      ),
    );
  }

  Widget _buildLatestNewsSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.wealthLatestNews,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                l10n.wealthSeeAll,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _wealthPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _NewsTile(
          title: 'Coinbase CEO Armstrong plans to sell part of his stake to fu...',
          source: 'The Block',
          time: '2h ago',
          iconBg: AppColors.primaryBlue,
          iconLabel: 'CB',
        ),
        const SizedBox(height: 10),
        _NewsTile(
          title: 'Market Trying to Relax Even though Economic Threats lurk',
          source: 'FinanceNews',
          time: '3h ago',
          iconBg: _wealthPurple,
          iconLabel: 'M',
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, AppLocalizations l10n, FirebaseAuthService authService) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 8 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _WealthNavItem(icon: Icons.home_rounded, label: l10n.wealthNavHome, isSelected: true, onTap: () {}),
          _WealthNavItem(icon: Icons.show_chart_rounded, label: l10n.wealthNavMarket, onTap: () {}),
          _WealthNavItem(
            icon: Icons.pie_chart_rounded,
            label: l10n.wealthNavPortfolio,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MyPortfolioScreen()),
              );
            },
          ),
          _WealthNavItem(
            icon: Icons.account_balance_wallet_rounded,
            label: l10n.wealthNavWallet,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MyWalletScreen()),
              );
            },
          ),
          _WealthNavItem(
            icon: Icons.person_rounded,
            label: l10n.wealthNavProfile,
            onTap: () {
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
    );
  }
}

class _WatchlistTab extends StatelessWidget {
  final String label;
  final bool selected;

  const _WatchlistTab({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? WealthHomeScreen._wealthPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _WatchlistCard extends StatelessWidget {
  final String symbol;
  final String name;
  final String price;
  final double changePercent;
  final bool positive;
  final Color iconBg;

  const _WatchlistCard({
    required this.symbol,
    required this.name,
    required this.price,
    required this.changePercent,
    required this.positive,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              symbol.substring(0, symbol.length >= 2 ? 2 : 1),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${positive ? '▲' : '▼'} ${changePercent.abs().toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: positive ? AppColors.accentGreen : AppColors.accentRed,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 24,
            child: CustomPaint(
              size: const Size(double.infinity, 24),
              painter: _MiniChartPainter(positive: positive),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  final bool positive;

  _MiniChartPainter({required this.positive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = positive ? AppColors.accentGreen : AppColors.accentRed
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(0, h * 0.7);
    path.quadraticBezierTo(w * 0.25, h * 0.6, w * 0.4, h * 0.5);
    path.quadraticBezierTo(w * 0.6, h * (positive ? 0.3 : 0.6), w * 0.8, h * (positive ? 0.4 : 0.5));
    path.lineTo(w, positive ? h * 0.2 : h * 0.7);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TopGainerCard extends StatelessWidget {
  final String name;
  final String symbol;
  final String price;
  final double changePercent;
  final Color iconBg;

  const _TopGainerCard({
    required this.name,
    required this.symbol,
    required this.price,
    required this.changePercent,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              symbol.length >= 2 ? symbol.substring(0, 2) : symbol,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            symbol,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            price,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '▲ ${changePercent.toStringAsFixed(2)}%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.accentGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsTile extends StatelessWidget {
  final String title;
  final String source;
  final String time;
  final Color iconBg;
  final String iconLabel;

  const _NewsTile({
    required this.title,
    required this.source,
    required this.time,
    required this.iconBg,
    required this.iconLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              iconLabel,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '$source • $time',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WealthNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _WealthNavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? WealthHomeScreen._wealthPurple : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? WealthHomeScreen._wealthPurple : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
