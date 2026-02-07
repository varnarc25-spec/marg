import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import 'gold_auto_invest_screen.dart';
import 'gold_redeem_screen.dart';

/// Purple accent for gold details (per design)
const Color _goldPurple = Color(0xFF6C63FF);

/// Gold color for gold icon
const Color _goldColor = Color(0xFFD4AF37);

/// Gold Details – Detail view for gold: price, chart, time range, actions, buy
class GoldDetailsScreen extends StatefulWidget {
  const GoldDetailsScreen({super.key});

  @override
  State<GoldDetailsScreen> createState() => _GoldDetailsScreenState();
}

class _GoldDetailsScreenState extends State<GoldDetailsScreen> {
  static const List<String> _timeRanges = ['24H', '1W', '1M', '1Y', 'ALL'];
  int _selectedTimeRangeIndex = 4; // ALL selected

  // Sample chart: Oct 10–13, prices 86–90
  static const List<FlSpot> _chartSpots = [
    FlSpot(0, 86.2),
    FlSpot(1, 86.8),
    FlSpot(2, 87.1),
    FlSpot(3, 86.5),
    FlSpot(4, 87.0),
    FlSpot(5, 87.65),
    FlSpot(6, 87.3),
    FlSpot(7, 88.0),
    FlSpot(8, 87.5),
    FlSpot(9, 88.2),
    FlSpot(10, 87.8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Gold Details'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.description_outlined),
            onPressed: () => _showMarketOverviewPopup(context),
          ),
          IconButton(
            icon: const Icon(Icons.star_border_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGoldOverview(context),
                    const SizedBox(height: 24),
                    _buildPriceChart(context),
                    const SizedBox(height: 20),
                    _buildTimeRangeChips(context),
                    const SizedBox(height: 28),
                    _buildDoMoreSection(context),
                    const SizedBox(height: 28),
                    _buildAboutGoldSection(context),
                    const SizedBox(height: 28),
                    _buildMarketOverviewSection(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBuyButton(context),
          ],
        ),
      ),
    );
  }

  void _showMarketOverviewPopup(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MarketOverviewSheet(
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildGoldOverview(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gold',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$87.65',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
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
                    '0.35% (+1.50%) Past 5 years',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.accentGreen,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _goldColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _goldColor.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(Icons.diamond_rounded, color: Colors.white, size: 26),
        ),
      ],
    );
  }

  Widget _buildPriceChart(BuildContext context) {
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                interval: 1,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 2.5,
                getTitlesWidget: (value, meta) {
                  const labels = ['Oct 10', 'Oct 11', 'Oct 12', 'Oct 13'];
                  final i = value.toInt().clamp(0, labels.length - 1);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.black87,
              tooltipRoundedRadius: 8,
              getTooltipItems: (touchedSpots) => touchedSpots
                  .map(
                    (s) => LineTooltipItem(
                      s.y.toStringAsFixed(2),
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _chartSpots,
              isCurved: true,
              color: AppColors.accentGreen,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.accentGreen.withValues(alpha: 0.08),
              ),
            ),
          ],
          minX: 0,
          maxX: 10,
          minY: 85.5,
          maxY: 89,
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
                  ? _goldPurple
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

  Widget _buildDoMoreSection(BuildContext context) {
    const actions = [
      (icon: Icons.sync_rounded, label: 'Auto invest'),
      (icon: Icons.card_giftcard_rounded, label: 'Gifts'),
      (icon: Icons.calendar_today_rounded, label: 'Loans'),
      (icon: Icons.download_rounded, label: 'Redeem'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Do more with gold',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < actions.length; i++)
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        color: Theme.of(context).colorScheme.surface,
                        shape: const CircleBorder(),
                        elevation: 1,
                        shadowColor: Colors.black.withValues(alpha: 0.06),
                        child: InkWell(
                          onTap: () {
                              if (i == 2) {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const GoldAutoInvestScreen(),
                                  ),
                                );
                              } else if (i == 3) {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const GoldRedeemScreen(),
                                  ),
                                );
                              }
                            },
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(actions[i].icon, size: 24, color: _goldPurple),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        actions[i].label,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutGoldSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Gold',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Gold investment generally provides good protection against dollar deprecation, and inflation and thus acts as a store of value.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {},
          child: Text(
            'View more',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _goldPurple,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarketOverviewSection(BuildContext context) {
    const rows = [
      ('Close', '87.65'),
      ('High', '88.00'),
      ('Low', '87.00'),
      ('52W Range', '86.00 - 87.00'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Market Overview',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rows[i].$1,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    Text(
                      rows[i].$2,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBuyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            backgroundColor: _goldPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Buy Gold'),
        ),
      ),
    );
  }
}

/// Market Overview bottom sheet – full list of market data (popup)
class _MarketOverviewSheet extends StatelessWidget {
  final VoidCallback onClose;

  const _MarketOverviewSheet({required this.onClose});

  static const List<(String, String)> _rows = [
    ('Close', '87.65'),
    ('High', '88.00'),
    ('Low', '87.00'),
    ('52W Range', '86.00 - 87.00'),
    ('Month', 'October 22'),
    ('Contract Size', '100 Troy Ounces'),
    ('Settlement Type', 'Physical'),
    ('Settlement Day', '12/28/2022'),
    ('Last Rollover Day', '07/31/2022'),
  ];

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.65;
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // Title row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Market Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: onClose,
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 40),
                      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Data rows (scrollable)
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  children: [
                    for (var i = 0; i < _rows.length; i++) ...[
                      if (i > 0) const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              _rows[i].$1,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _rows[i].$2,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
