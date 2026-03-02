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
      (Icons.show_chart_rounded, l10n.wealthStocks),
      (Icons.currency_bitcoin_rounded, l10n.wealthCrypto),
      (Icons.diamond_rounded, l10n.wealthGold),
      (Icons.pie_chart_rounded, l10n.wealthMutualFunds),
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
                        color: AppColors.iconTilePastelBlue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(e.$1, size: 26, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      e.$2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
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

/// Watchlist section with working tabs (Crypto / US Stocks / Gold).
class _WatchlistSection extends StatefulWidget {
  final AppLocalizations l10n;

  const _WatchlistSection({required this.l10n});

  @override
  State<_WatchlistSection> createState() => _WatchlistSectionState();
}

class _WatchlistSectionState extends State<_WatchlistSection> {
  int _selectedIndex = 1; // 0 = Crypto, 1 = US Stocks, 2 = Gold

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
                label: l10n.wealthCryptoAssets,
                selected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _WatchlistTab(
                label: l10n.wealthUSStocks,
                selected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _WatchlistTab(
                label: l10n.wealthGold,
                selected: _selectedIndex == 2,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildWatchlistContent(),
      ],
    );
  }

  Widget _buildWatchlistContent() {
    switch (_selectedIndex) {
      case 0:
        return _cryptoCards();
      case 1:
        return _usStocksCards();
      case 2:
        return _goldCards();
      default:
        return _usStocksCards();
    }
  }

  Widget _cryptoCards() {
    return Row(
      children: [
        Expanded(
          child: _WatchlistCard(
            symbol: 'ETH',
            name: 'Ethereum',
            price: '\$2,845.20',
            changePercent: 1.24,
            positive: true,
            iconBg: Colors.indigo.shade300,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _WatchlistCard(
            symbol: 'BTC',
            name: 'Bitcoin',
            price: '\$67,120.00',
            changePercent: -0.42,
            positive: false,
            iconBg: Colors.orange.shade300,
          ),
        ),
      ],
    );
  }

  Widget _usStocksCards() {
    return Row(
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
    );
  }

  Widget _goldCards() {
    return Row(
      children: [
        Expanded(
          child: _WatchlistCard(
            symbol: 'GOLD',
            name: 'Gold 24K',
            price: '\$2,089.40',
            changePercent: 0.18,
            positive: true,
            iconBg: const Color(0xFFD4AF37),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _WatchlistCard(
            symbol: 'SLV',
            name: 'Silver',
            price: '\$24.56',
            changePercent: -0.12,
            positive: false,
            iconBg: Colors.grey.shade400,
          ),
        ),
      ],
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
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              symbol.substring(0, symbol.length >= 2 ? 2 : 1),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${positive ? '▲' : '▼'} ${changePercent.abs().toStringAsFixed(2)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
    path.quadraticBezierTo(
      w * 0.6,
      h * (positive ? 0.3 : 0.6),
      w * 0.8,
      h * (positive ? 0.4 : 0.5),
    );
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
