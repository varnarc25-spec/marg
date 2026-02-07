import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Market accent – purple used on this screen per design
const Color _marketPurple = Color(0xFF6C63FF);

/// Stocks Home Page – Market screen (Screen 35)
/// Matches design: header "Market", search, asset filters, Stock Futures, Sectors, All Stocks, bottom nav
class StocksHomePage extends StatefulWidget {
  const StocksHomePage({super.key});

  @override
  State<StocksHomePage> createState() => _StocksHomePageState();
}

class _StocksHomePageState extends State<StocksHomePage> {
  int _selectedNavIndex = 1; // Market selected
  int _selectedAssetFilter = 1; // US Stock
  int _futuresPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Market',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            // Search bar
            _SearchBar(),
            const SizedBox(height: 20),

            // Asset type filters
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _AssetChip(
                    label: 'Crypto Asset',
                    icon: Icons.currency_bitcoin_rounded,
                    selected: _selectedAssetFilter == 0,
                    onTap: () => setState(() => _selectedAssetFilter = 0),
                  ),
                  const SizedBox(width: 10),
                  _AssetChip(
                    label: 'US Stock',
                    icon: Icons.bar_chart_rounded,
                    selected: _selectedAssetFilter == 1,
                    onTap: () => setState(() => _selectedAssetFilter = 1),
                  ),
                  const SizedBox(width: 10),
                  _AssetChip(
                    label: 'NFTs',
                    icon: Icons.auto_awesome_rounded,
                    selected: _selectedAssetFilter == 2,
                    onTap: () => setState(() => _selectedAssetFilter = 2),
                  ),
                  const SizedBox(width: 10),
                  _AssetChip(
                    label: 'More',
                    icon: Icons.all_inclusive_rounded,
                    selected: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stock Futures
            Text(
              'Stock Futures',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: PageView(
                onPageChanged: (i) => setState(() => _futuresPage = i),
                children: [
                  _FuturesCard(
                    symbol: 'NASDAQ100',
                    subtitle: 'NASDAQ 100 Index',
                    price: '\$111,73',
                    change: 2.56,
                    isPositive: true,
                    accentColor: _marketPurple,
                    isPurpleCard: true,
                    icon: 'N',
                  ),
                  _FuturesCard(
                    symbol: 'SNP500',
                    subtitle: 'S&P 500 Inc',
                    price: '\$37,31',
                    change: 1.55,
                    isPositive: true,
                    accentColor: AppColors.accentGreen,
                    isPurpleCard: false,
                    icon: 'S&P',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _futuresPage == i
                        ? _marketPurple
                        : Theme.of(context).colorScheme.outlineVariant,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Sectors
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sectors',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See all', style: TextStyle(color: _marketPurple, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 88,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _SectorChip(icon: Icons.account_balance_rounded, label: 'Finance'),
                  SizedBox(width: 16),
                  _SectorChip(icon: Icons.memory_rounded, label: 'Technology'),
                  SizedBox(width: 16),
                  _SectorChip(icon: Icons.engineering_rounded, label: 'Industry'),
                  SizedBox(width: 16),
                  _SectorChip(icon: Icons.inventory_2_rounded, label: 'Utilities'),
                  SizedBox(width: 16),
                  _SectorChip(icon: Icons.health_and_safety_rounded, label: 'Health'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // All Stocks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Stocks',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.swap_vert_rounded, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  label: const Text('Sort', style: TextStyle(color: Colors.grey, fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _AllStockTile(
              symbol: 'AMZN',
              name: 'Amazon, Inc.',
              price: '\$112,85.00',
              change: -0.12,
              logoColor: const Color(0xFFFF9900),
              logoLetter: 'a',
            ),
            _AllStockTile(
              symbol: 'AAPL',
              name: 'Apple Inc.',
              price: '\$189.50',
              change: 0.85,
              logoColor: Colors.grey.shade700,
              logoLetter: 'A',
            ),
            _AllStockTile(
              symbol: 'GOOGL',
              name: 'Alphabet Inc.',
              price: '\$142.30',
              change: -0.22,
              logoColor: const Color(0xFF4285F4),
              logoLetter: 'G',
            ),
            _AllStockTile(
              symbol: 'MSFT',
              name: 'Microsoft Corp.',
              price: '\$378.90',
              change: 1.12,
              logoColor: const Color(0xFF00A4EF),
              logoLetter: 'M',
            ),
            _AllStockTile(
              symbol: 'TSLA',
              name: 'Tesla, Inc.',
              price: '\$248.60',
              change: -0.56,
              logoColor: const Color(0xFFCC0000),
              logoLetter: 'T',
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _selectedNavIndex,
        onTap: (i) => setState(() => _selectedNavIndex = i),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 22,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _AssetChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _AssetChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? _marketPurple : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? _marketPurple : Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FuturesCard extends StatelessWidget {
  final String symbol;
  final String subtitle;
  final String price;
  final double change;
  final bool isPositive;
  final Color accentColor;
  final bool isPurpleCard;
  final String icon;

  const _FuturesCard({
    required this.symbol,
    required this.subtitle,
    required this.price,
    required this.change,
    required this.isPositive,
    required this.accentColor,
    required this.isPurpleCard,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isPurpleCard ? _marketPurple : Theme.of(context).colorScheme.surface;
    final fg = isPurpleCard ? Colors.white : Theme.of(context).colorScheme.onSurface;
    final sub = isPurpleCard ? Colors.white70 : Theme.of(context).colorScheme.onSurfaceVariant;
    final changeColor = isPositive ? AppColors.accentGreen : AppColors.accentRed;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isPurpleCard
                        ? Colors.white.withValues(alpha: 0.25)
                        : Colors.red.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    icon,
                    style: TextStyle(
                      color: isPurpleCard ? Colors.white : Colors.red.shade800,
                      fontWeight: FontWeight.w700,
                      fontSize: icon.length > 2 ? 9 : 14,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  symbol,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: sub, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                      color: isPurpleCard ? Colors.white : changeColor,
                      size: 18,
                    ),
                    Text(
                      '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: isPurpleCard ? Colors.white : changeColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 72,
            height: 44,
            child: CustomPaint(
              painter: _MiniChartPainter(up: isPositive),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  final bool up;

  _MiniChartPainter({required this.up});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = up ? AppColors.accentGreen : AppColors.accentRed
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(0, h * 0.7);
    path.quadraticBezierTo(w * 0.25, h * 0.5, w * 0.5, h * 0.55);
    path.quadraticBezierTo(w * 0.75, h * 0.6, w, h * 0.35);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SectorChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectorChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Theme.of(context).colorScheme.surface,
          shape: const CircleBorder(),
          elevation: 1,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          child: InkWell(
            onTap: () {},
            customBorder: const CircleBorder(),
            child: Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              child: Icon(icon, size: 26, color: _marketPurple),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _AllStockTile extends StatelessWidget {
  final String symbol;
  final String name;
  final String price;
  final double change;
  final Color logoColor;
  final String logoLetter;

  const _AllStockTile({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.logoColor,
    required this.logoLetter,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;
    final changeColor = isPositive ? AppColors.accentGreen : AppColors.accentRed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: logoColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    logoLetter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        symbol,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                          color: changeColor,
                          size: 18,
                        ),
                        Text(
                          '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: changeColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_outlined, label: 'Home', selected: currentIndex == 0, onTap: () => onTap(0)),
              _NavItem(icon: Icons.show_chart_rounded, label: 'Market', selected: currentIndex == 1, onTap: () => onTap(1)),
              _CenterWalletButton(onTap: () => onTap(2)),
              _NavItem(icon: Icons.pie_chart_outline_rounded, label: 'Portfolio', selected: currentIndex == 3, onTap: () => onTap(3)),
              _NavItem(icon: Icons.person_outline_rounded, label: 'Profile', selected: currentIndex == 4, onTap: () => onTap(4)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterWalletButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CenterWalletButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: _marketPurple,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _marketPurple.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 26),
      ),
    );
  }
}
