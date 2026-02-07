import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';

/// Purple accent for portfolio (per design)
const Color _portfolioPurple = Color(0xFF6C63FF);

/// Dark purple/black for Crypto card and donut segment
const Color _cryptoDark = Color(0xFF1E1B2E);

/// Yellow for 0% segment in allocation
const Color _allocationYellow = Color(0xFFFBBF24);

/// Blue for NFTs segment in allocation
const Color _allocationBlue = Color(0xFF3B82F6);

/// My Portfolio screen – total asset value, performance chart, overview cards, asset allocation donut, bottom nav
class MyPortfolioScreen extends StatefulWidget {
  const MyPortfolioScreen({super.key});

  @override
  State<MyPortfolioScreen> createState() => _MyPortfolioScreenState();
}

class _MyPortfolioScreenState extends State<MyPortfolioScreen> {
  bool _amountVisible = true;
  int _selectedTimeRangeIndex = 4; // ALL

  static const List<String> _timeRanges = ['24H', '1W', '1M', '1Y', 'ALL'];

  // Bar heights for Sun–Sat (Thu = index 4 highlighted)
  static const List<double> _barValues = [3.2, 4.0, 3.8, 4.5, 5.8, 4.2, 4.0];

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
          'Portfolio',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.description_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildTotalAssetSection(context),
            const SizedBox(height: 24),
            _buildPerformanceChart(context),
            const SizedBox(height: 16),
            _buildTimeRangeChips(context),
            const SizedBox(height: 28),
            _buildOverviewSection(context),
            const SizedBox(height: 28),
            _buildAssetAllocationSection(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildTotalAssetSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total asset value',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _amountVisible ? '\$27,456.00' : '••••••••',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                _amountVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                size: 22,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () => setState(() => _amountVisible = !_amountVisible),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.trending_up_rounded,
              size: 16,
              color: AppColors.accentGreen,
            ),
            const SizedBox(width: 4),
            Text(
              '0.54% (+1.20%) All time',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.accentGreen,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPerformanceChart(BuildContext context) {
    const dayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const maxY = 6.5;

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= dayLabels.length) return const SizedBox.shrink();
                  final isThu = i == 4;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      dayLabels[i],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isThu ? FontWeight.w700 : FontWeight.w500,
                        color: isThu ? _portfolioPurple : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (i) {
            final isThu = i == 4;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: _barValues[i],
                  color: isThu ? _portfolioPurple : Theme.of(context).colorScheme.surfaceContainerHighest,
                  width: 20,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
              showingTooltipIndicators: isThu ? [0] : [],
            );
          }),
        ),
        duration: const Duration(milliseconds: 250),
      ),
    );
  }

  Widget _buildTimeRangeChips(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          _timeRanges.length,
          (i) => Padding(
            padding: EdgeInsets.only(right: i < _timeRanges.length - 1 ? 10 : 0),
            child: Material(
              color: _selectedTimeRangeIndex == i
                  ? _portfolioPurple
                  : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => setState(() => _selectedTimeRangeIndex = i),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Text(
                    _timeRanges[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _selectedTimeRangeIndex == i
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 16),
        _buildAssetCard(
          context,
          backgroundColor: _cryptoDark,
          icon: Icons.account_balance_wallet_rounded,
          label: 'Crypto',
          assetCount: '10 Assets',
          value: '\$20,321.00',
          changePercent: '0.24%',
          profitsLabel: 'Profits',
          profitsValue: '\$16,988.00',
        ),
        const SizedBox(height: 14),
        _buildAssetCard(
          context,
          backgroundColor: _portfolioPurple,
          icon: Icons.show_chart_rounded,
          label: 'Stocks',
          assetCount: '5 Assets',
          value: '\$5,687.99',
          changePercent: '1.35%',
          profitsLabel: 'Profits',
          profitsValue: '\$2,567.00',
        ),
      ],
    );
  }

  Widget _buildAssetAllocationSection(BuildContext context) {
    // 75% Crypto, 25% Stocks, 0%, 0% NFTs – use tiny values for 0% so segments show
    const sections = [
      (value: 75.0, color: _cryptoDark, label: '75% Cryptocurrency'),
      (value: 25.0, color: _portfolioPurple, label: '25% Stocks'),
      (value: 0.01, color: _allocationYellow, label: '0%'),
      (value: 0.01, color: _allocationBlue, label: '0% NFTs'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Asset Allocation',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 220,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 36,
                    centerSpaceColor: Theme.of(context).colorScheme.surface,
                    sectionsSpace: 2,
                    sections: sections
                        .map(
                          (s) => PieChartSectionData(
                            value: s.value,
                            color: s.color,
                            radius: 48,
                            showTitle: false,
                          ),
                        )
                        .toList(),
                  ),
                  duration: const Duration(milliseconds: 400),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < sections.length; i++) ...[
                      if (i > 0) const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: sections[i].color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              sections[i].label,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssetCard(
    BuildContext context, {
    required Color backgroundColor,
    required IconData icon,
    required String label,
    required String assetCount,
    required String value,
    required String changePercent,
    required String profitsLabel,
    required String profitsValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    assetCount,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        size: 14,
                        color: AppColors.accentGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        changePercent,
                        style: const TextStyle(
                          color: Color(0xFF4ADE80),
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profitsLabel,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    profitsValue,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _portfolioPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Buy'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    const labels = ['Home', 'Market', 'Portfolio', 'Profile'];
    const icons = [
      Icons.home_rounded,
      Icons.show_chart_rounded,
      Icons.pie_chart_rounded,
      Icons.person_rounded,
    ];
    const selectedIndex = 2; // Portfolio active

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
        children: List.generate(4, (i) {
          final isSelected = i == selectedIndex;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _portfolioPurple.withValues(alpha: 0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icons[i],
                      size: 24,
                      color: isSelected ? _portfolioPurple : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? _portfolioPurple : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
