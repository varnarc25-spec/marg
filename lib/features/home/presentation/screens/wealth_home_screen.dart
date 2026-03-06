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
                  _buildLiveIndicesCard(context, l10n),
                  const SizedBox(height: 20),
                  if (authService.isLoggedIn()) ...[
                    _ExpandablePnLCard(l10n: l10n),
                    const SizedBox(height: 20),
                  ],
                  _buildAssetCategories(context, l10n),
                  if (authService.isLoggedIn()) ...[
                    const SizedBox(height: 24),
                    _buildWatchlistSection(context, l10n),
                  ],
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 22,
            ),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          const SizedBox(width: 4),
          Icon(Icons.eco_rounded, size: 28, color: _wealthPurple),
          const SizedBox(width: 8),
          Text(
            l10n.appName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
            icon: Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
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

  /// Live indices: NIFTY 50, NIFTY BANK, Gold, Silver — all 4 in one row.
  Widget _buildLiveIndicesCard(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _LiveIndexCell(
            label: l10n.wealthNifty50,
            value: '25,693.70',
            changeText: '+50.90 (+0.19%)',
            positive: true,
          ),
        ),
        Expanded(
          child: _LiveIndexCell(
            label: l10n.wealthNiftyBank,
            value: '60,120.55',
            changeText: '+56.90 (+0.09%)',
            positive: true,
          ),
        ),
        Expanded(
          child: _LiveIndexCell(
            label: l10n.wealthDigitalGold,
            value: '₹6,245.00',
            changeText: '▲ 0.24%',
            positive: true,
          ),
        ),
        Expanded(
          child: _LiveIndexCell(
            label: l10n.wealthSilver,
            value: '₹82.45',
            changeText: '▼ 0.12%',
            positive: false,
          ),
        ),
      ],
    );
  }

  Widget _buildAssetCategories(BuildContext context, AppLocalizations l10n) {
    final items = [
      (Icons.show_chart_rounded, l10n.wealthStocks, AppColors.iconBGStocks),
      (
        Icons.currency_bitcoin_rounded,
        l10n.wealthCrypto,
        AppColors.iconBGCrypto,
      ),
      (Icons.diamond_rounded, l10n.wealthGold, AppColors.iconBGGold),
      (Icons.pie_chart_rounded, l10n.wealthMutualFunds, AppColors.iconBGMF),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: items
            .map(
              (e) => Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: e.$3,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        e.$1,
                        size: 26,
                        color: AppColors.backgroundLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      e.$2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildWatchlistSection(BuildContext context, AppLocalizations l10n) {
    return _WatchlistSection(l10n: l10n);
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                l10n.wealthSeeAll,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          colors: [_wealthPurple, _wealthPurple.withValues(alpha: 0.85)],
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
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.wealthEarnRewardsDesc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.savings_rounded,
            size: 56,
            color: Colors.white.withValues(alpha: 0.9),
          ),
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                l10n.wealthSeeAll,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: _wealthPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _NewsTile(
          title:
              'Coinbase CEO Armstrong plans to sell part of his stake to fu...',
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

  Widget _buildBottomNav(
    BuildContext context,
    AppLocalizations l10n,
    FirebaseAuthService authService,
  ) {
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
          _WealthNavItem(
            icon: Icons.home_rounded,
            label: l10n.wealthNavHome,
            isSelected: true,
            onTap: () {},
          ),
          _WealthNavItem(
            icon: Icons.show_chart_rounded,
            label: l10n.wealthNavMarket,
            onTap: () {},
          ),
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
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const MyWalletScreen()));
            },
          ),
          _WealthNavItem(
            icon: Icons.person_rounded,
            label: l10n.wealthNavProfile,
            onTap: () async {
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
                    MaterialPageRoute(builder: (_) => const MyAccountScreen()),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Expandable white card: closed = Invested / Current / P&L summary; open = summary + full investments list.
class _ExpandablePnLCard extends StatefulWidget {
  final AppLocalizations l10n;

  const _ExpandablePnLCard({required this.l10n});

  @override
  State<_ExpandablePnLCard> createState() => _ExpandablePnLCardState();
}

class _ExpandablePnLCardState extends State<_ExpandablePnLCard> {
  bool _isExpanded = false;

  static String _formatAmount(double n) {
    final sign = n < 0 ? '-' : '';
    final s = n.abs().toStringAsFixed(2);
    final parts = s.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$sign₹$intPart.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final theme = Theme.of(context).textTheme;
    const invested = 149663.20;
    const current = 139496.00;
    final pnl = current - invested;
    final pnlPercent = (pnl / invested) * 100;
    final isPositive = pnl >= 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.wealthInvested,
                            style: theme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatAmount(invested),
                            style: theme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            l10n.wealthCurrent,
                            style: theme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatAmount(current),
                            style: theme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.wealthPnL,
                          style: theme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatAmount(pnl),
                              style: theme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isPositive
                                    ? AppColors.accentGreen
                                    : AppColors.accentRed,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (isPositive
                                            ? AppColors.accentGreen
                                            : AppColors.accentRed)
                                        .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${pnlPercent >= 0 ? '+' : ''}${pnlPercent.toStringAsFixed(2)}%',
                                style: theme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isPositive
                                      ? AppColors.accentGreen
                                      : AppColors.accentRed,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: AppColors.textSecondary,
                              size: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            Divider(height: 1, color: Colors.grey.shade200),
            _InvestmentsList(),
          ],
        ],
      ),
    );
  }
}

/// Placeholder investments list shown when P&L card is expanded.
class _InvestmentsList extends StatelessWidget {
  static final List<({String name, String value, String pnl, bool positive})>
  _items = [
    (
      name: 'Equity – Nifty 50 ETF',
      value: '₹45,200.00',
      pnl: '-₹2,100.00 (-4.44%)',
      positive: false,
    ),
    (
      name: 'Gold – Digital Gold',
      value: '₹32,150.00',
      pnl: '₹1,850.00 (+6.11%)',
      positive: true,
    ),
    (
      name: 'Silver – 999',
      value: '₹18,420.00',
      pnl: '₹320.00 (+1.77%)',
      positive: true,
    ),
    (
      name: 'Debt Fund – Liquid',
      value: '₹28,900.00',
      pnl: '₹890.00 (+3.18%)',
      positive: true,
    ),
    (
      name: 'Equity – Mid Cap',
      value: '₹24,826.00',
      pnl: '-₹5,159.00 (-17.21%)',
      positive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _items[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                item.pnl,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: item.positive
                      ? AppColors.accentGreen
                      : AppColors.accentRed,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Compact cell for live index: theme-based font sizes (same as rest of app).
class _LiveIndexCell extends StatelessWidget {
  final String label;
  final String value;
  final String changeText;
  final bool positive;

  const _LiveIndexCell({
    required this.label,
    required this.value,
    required this.changeText,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          changeText,
          style: theme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: positive ? AppColors.accentGreen : AppColors.accentRed,
          ),
        ),
      ],
    );
  }
}

/// Watchlist section with working tabs (Stocks / Crypto / US Stocks / Mutual Funds).
class _WatchlistSection extends StatefulWidget {
  final AppLocalizations l10n;

  const _WatchlistSection({required this.l10n});

  @override
  State<_WatchlistSection> createState() => _WatchlistSectionState();
}

class _WatchlistSectionState extends State<_WatchlistSection> {
  int _selectedIndex =
      0; // 0 = Stocks, 1 = Crypto, 2 = US Stocks, 3 = Mutual Funds

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.wealthWatchlist,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                l10n.wealthEditWatchlist,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: WealthHomeScreen._wealthPurple,
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
              _WatchlistTab(
                label: l10n.wealthStocks,
                selected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _WatchlistTab(
                label: l10n.wealthCryptoAssets,
                selected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _WatchlistTab(
                label: l10n.wealthUSStocks,
                selected: _selectedIndex == 2,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              _WatchlistTab(
                label: l10n.wealthMutualFunds,
                selected: _selectedIndex == 3,
                onTap: () => setState(() => _selectedIndex = 3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _WatchlistTabContent(
          l10n: l10n,
          tabIndex: _selectedIndex,
        ),
      ],
    );
  }
}

/// Full watchlist content per tab: search bar, groups, watchlist numbers (1-7) + add.
class _WatchlistTabContent extends StatefulWidget {
  final AppLocalizations l10n;
  final int tabIndex;

  const _WatchlistTabContent({
    required this.l10n,
    required this.tabIndex,
  });

  @override
  State<_WatchlistTabContent> createState() => _WatchlistTabContentState();
}

class _WatchlistTabContentState extends State<_WatchlistTabContent> {
  int _selectedWatchlistIndex = 0; // 0 = watchlist 1, ... 6 = watchlist 7

  static List<_WatchlistGroupData> _groupsForTab(int tabIndex) {
    switch (tabIndex) {
      case 0: // Stocks
        return [
          _WatchlistGroupData(
            name: 'Default',
            count: 15,
            showBuySell: false,
            items: [
              _WatchlistItemData(
                name: 'GOLDBEES',
                exchange: null,
                value: '1060',
                absChange: '6.72',
                percentChange: '5.11',
                currentPrice: '138.32',
                positive: true,
              ),
              _WatchlistItemData(
                name: 'GOLDBEES',
                exchange: 'BSE',
                value: '1060',
                absChange: '6.70',
                percentChange: '5.09',
                currentPrice: '138.34',
                positive: true,
              ),
              _WatchlistItemData(
                name: 'GOLDIETF',
                exchange: null,
                value: null,
                absChange: '7.26',
                percentChange: '5.33',
                currentPrice: '143.55',
                positive: true,
              ),
            ],
          ),
          _WatchlistGroupData(
            name: 'IDEA',
            exchange: 'BSE',
            showBuySell: true,
            items: [
              _WatchlistItemData(
                name: 'IDEA',
                exchange: null,
                absChange: '-0.30',
                percentChange: '-2.83',
                currentPrice: '10.29',
                positive: false,
              ),
              _WatchlistItemData(
                name: 'YESBANK',
                exchange: null,
                absChange: '-0.54',
                percentChange: '-2.61',
                currentPrice: '20.18',
                positive: false,
              ),
              _WatchlistItemData(
                name: 'ITC',
                exchange: 'BSE',
                absChange: '1.20',
                percentChange: '0.38',
                currentPrice: '314.80',
                positive: true,
              ),
            ],
          ),
          _WatchlistGroupData(
            name: 'penny',
            count: 2,
            showBuySell: false,
            items: [
              _WatchlistItemData(
                name: 'NIFTYBEES',
                exchange: null,
                absChange: '-3.36',
                percentChange: '-1.18',
                currentPrice: '281.93',
                positive: false,
              ),
              _WatchlistItemData(
                name: 'BANKBEES',
                exchange: null,
                absChange: '-6.25',
                percentChange: '-1.00',
                currentPrice: '617.72',
                positive: false,
              ),
            ],
          ),
        ];
      case 1: // Crypto
        return [
          _WatchlistGroupData(
            name: 'Default',
            count: 4,
            showBuySell: false,
            items: [
              _WatchlistItemData(
                name: 'ETH',
                exchange: null,
                value: null,
                absChange: '42.50',
                percentChange: '1.52',
                currentPrice: '2,845.20',
                positive: true,
              ),
              _WatchlistItemData(
                name: 'BTC',
                exchange: null,
                value: null,
                absChange: '-285.00',
                percentChange: '-0.42',
                currentPrice: '67,120.00',
                positive: false,
              ),
            ],
          ),
        ];
      case 2: // US Stocks
        return [
          _WatchlistGroupData(
            name: 'Tech',
            count: 3,
            showBuySell: false,
            items: [
              _WatchlistItemData(
                name: 'ABNB',
                exchange: null,
                absChange: '0.37',
                percentChange: '0.33',
                currentPrice: '112.72',
                positive: true,
              ),
              _WatchlistItemData(
                name: 'SPOT',
                exchange: null,
                absChange: '-0.05',
                percentChange: '-0.06',
                currentPrice: '82.70',
                positive: false,
              ),
            ],
          ),
        ];
      case 3: // Mutual Funds
        return [
          _WatchlistGroupData(
            name: 'Default',
            count: 2,
            showBuySell: false,
            items: [
              _WatchlistItemData(
                name: 'Axis Long Term',
                exchange: null,
                absChange: '0.25',
                percentChange: '0.56',
                currentPrice: '45.20',
                positive: true,
              ),
              _WatchlistItemData(
                name: 'HDFC Top 100',
                exchange: null,
                absChange: '-1.61',
                percentChange: '-0.18',
                currentPrice: '892.10',
                positive: false,
              ),
            ],
          ),
        ];
      default:
        return _groupsForTab(0);
    }
  }

  void _onAddWatchlistTap(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add_rounded, color: AppColors.primaryBlue),
                title: Text(widget.l10n.wealthWatchlistNewList),
                onTap: () {
                  Navigator.pop(ctx);
                  _showCreateNewListDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateNewListDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.l10n.wealthWatchlistCreateNewList),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: widget.l10n.wealthWatchlistListName,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(widget.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: create watchlist with nameController.text
              Navigator.pop(ctx);
            },
            child: Text(widget.l10n.wealthWatchlistCreate),
          ),
        ],
      ),
    ).then((_) => nameController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groupsForTab(widget.tabIndex);
    const totalItems = 17;
    const totalCount = 250;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Watchlist numbers (1–7) + add new watchlist — at top, same for all tabs
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(7, (i) {
                  final watchlistNum = i + 1;
                  final isSelected = i == _selectedWatchlistIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedWatchlistIndex = i),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$watchlistNum',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? WealthHomeScreen._wealthPurple
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 20,
                            height: 2,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? WealthHomeScreen._wealthPurple
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 12),
                Icon(
                  Icons.layers_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => _onAddWatchlistTap(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: WealthHomeScreen._wealthPurple.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: 20,
                      color: WealthHomeScreen._wealthPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.l10n.wealthWatchlistSearchHint,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Ctrl + K',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.bar_chart_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          // Item count + New group
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '${_selectedWatchlistIndex + 1} ($totalItems/$totalCount)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(widget.l10n.wealthWatchlistNewGroup),
                  style: TextButton.styleFrom(
                    foregroundColor: WealthHomeScreen._wealthPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Groups
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            itemCount: groups.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _WatchlistGroupWidget(
                group: groups[index],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WatchlistGroupData {
  final String name;
  final int? count;
  final String? exchange;
  final bool showBuySell;
  final List<_WatchlistItemData> items;

  _WatchlistGroupData({
    required this.name,
    this.count,
    this.exchange,
    this.showBuySell = false,
    required this.items,
  });
}

class _WatchlistItemData {
  final String name;
  final String? exchange;
  final String? value;
  final String absChange;
  final String percentChange;
  final String currentPrice;
  final bool positive;

  _WatchlistItemData({
    required this.name,
    this.exchange,
    this.value,
    required this.absChange,
    required this.percentChange,
    required this.currentPrice,
    required this.positive,
  });
}

class _WatchlistGroupWidget extends StatelessWidget {
  final _WatchlistGroupData group;

  const _WatchlistGroupWidget({required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final accentColor = group.items.isNotEmpty && group.items.first.positive
        ? AppColors.accentGreen
        : AppColors.accentRed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group header
        Row(
          children: [
            Text(
              group.count != null
                  ? '${group.name} (${group.count})'
                  : group.name,
              style: theme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: group.exchange != null ? accentColor : AppColors.textPrimary,
              ),
            ),
            if (group.exchange != null) ...[
              const SizedBox(width: 4),
              Text(
                group.exchange!,
                style: theme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const Spacer(),
            if (group.showBuySell) ...[
              _HeaderChip(label: 'B', color: AppColors.primaryBlue),
              const SizedBox(width: 6),
              _HeaderChip(label: 'S', color: AppColors.accentOrange),
              const SizedBox(width: 8),
            ],
            if (!group.showBuySell) ...[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_up_rounded, size: 20, color: AppColors.textSecondary),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              IconButton(
                icon: Icon(Icons.open_in_full_rounded, size: 18, color: AppColors.textSecondary),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              IconButton(
                icon: Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
            IconButton(
              icon: Icon(
                group.showBuySell ? Icons.filter_list_rounded : Icons.bar_chart_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            if (group.showBuySell) ...[
              IconButton(
                icon: Icon(Icons.show_chart_rounded, size: 20, color: AppColors.textSecondary),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.textSecondary),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
            IconButton(
              icon: Icon(Icons.more_vert_rounded, size: 20, color: AppColors.textSecondary),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Instrument rows
        ...group.items.map(
          (item) => _WatchlistInstrumentRow(item: item),
        ),
      ],
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final String label;
  final Color color;

  const _HeaderChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _WatchlistInstrumentRow extends StatelessWidget {
  final _WatchlistItemData item;

  const _WatchlistInstrumentRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final color = item.positive ? AppColors.accentGreen : AppColors.accentRed;
    final arrow = item.positive ? ' ^' : ' v';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                if (item.exchange != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.exchange!,
                    style: theme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (item.value != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.value!,
                  style: theme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.candlestick_chart_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          if (item.value != null) const SizedBox(width: 12),
          Text(
            item.absChange,
            style: theme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 56,
            child: Text(
              '${item.percentChange}%$arrow',
              style: theme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.currentPrice,
            style: theme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _WatchlistTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _WatchlistTab({
    required this.label,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? WealthHomeScreen._wealthPurple
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
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
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              symbol.length >= 2 ? symbol.substring(0, 2) : symbol,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            symbol,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            price,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            '▲ ${changePercent.toStringAsFixed(2)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
              color: isSelected
                  ? WealthHomeScreen._wealthPurple
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? WealthHomeScreen._wealthPurple
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
