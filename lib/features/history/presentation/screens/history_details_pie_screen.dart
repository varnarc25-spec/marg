import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';

/// Screen 92: History Transaction - Details (Pie Chart) – donut "Total spent", Buy/Send/Received legend, History list
const Color _buyPurple = Color(0xFF6C63FF);
const Color _sendBlue = Color(0xFF3B82F6);
const Color _receivedGreen = Color(0xFF00C853);

class HistoryDetailsPieScreen extends StatelessWidget {
  const HistoryDetailsPieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const sections = [
      (value: 83.0, color: _buyPurple, label: 'Buy 83%'),
      (value: 10.0, color: _sendBlue, label: 'Send 10%'),
      (value: 5.0, color: _receivedGreen, label: 'Received 5%'),
    ];

    final historyItems = [
      _HistoryRow(title: 'Sell ADA', time: '04:00 PM', amount: '-\$87.69'),
      _HistoryRow(title: 'Purchase ADA', time: '02:15 PM', amount: '+\$105.00'),
      _HistoryRow(title: 'Send (ADA)', time: '10:00 AM', amount: '-\$50.00'),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Details'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.bar_chart_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.description_outlined), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              SizedBox(
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        centerSpaceRadius: 50,
                        centerSpaceColor: Theme.of(context).colorScheme.surface,
                        sectionsSpace: 2,
                        sections: sections
                            .map(
                              (s) => PieChartSectionData(
                                value: s.value,
                                color: s.color,
                                radius: 55,
                                showTitle: false,
                              ),
                            )
                            .toList(),
                      ),
                      duration: const Duration(milliseconds: 400),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$1,590.00',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        Text(
                          'Total spent',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < sections.length; i++) ...[
                    if (i > 0) const SizedBox(width: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: sections[i].color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          sections[i].label,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 28),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'History',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              ...historyItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _HistoryListTile(item: item),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryRow {
  final String title;
  final String time;
  final String amount;

  _HistoryRow({required this.title, required this.time, required this.amount});
}

class _HistoryListTile extends StatelessWidget {
  final _HistoryRow item;

  const _HistoryListTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Text(
            item.amount,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: item.amount.startsWith('+') ? AppColors.accentGreen : Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}
