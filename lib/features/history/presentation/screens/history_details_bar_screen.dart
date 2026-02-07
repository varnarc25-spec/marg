import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Screen 93: History Transaction - Details (Bar Chart) – dark theme, Total spent, Month dropdown, bar chart, History list
const Color _buyPurple = Color(0xFF6C63FF);
const Color _sendBlue = Color(0xFF3B82F6);
const Color _receivedGreen = Color(0xFF00C853);
const Color _darkBg = Color(0xFF121212);

class HistoryDetailsBarScreen extends StatefulWidget {
  const HistoryDetailsBarScreen({super.key});

  @override
  State<HistoryDetailsBarScreen> createState() => _HistoryDetailsBarScreenState();
}

class _HistoryDetailsBarScreenState extends State<HistoryDetailsBarScreen> {
  String _selectedMonth = 'Month';

  static const List<String> _months = ['May', 'Jun', 'Jul', 'Aug', 'Sep'];
  static const List<double> _purchase = [400, 600, 350, 800, 500];
  static const List<double> _send = [150, 200, 180, 220, 190];
  static const List<double> _received = [100, 250, 120, 300, 150];

  @override
  Widget build(BuildContext context) {
    final historyItems = [
      _HistoryRow(title: 'Sell ADA', time: '04:00 PM', amount: '-\$87.69'),
      _HistoryRow(title: 'Purchase ADA', time: '02:15 PM', amount: '+\$105.00'),
      _HistoryRow(title: 'Send (ADA)', time: '10:00 AM', amount: '-\$50.00'),
    ];

    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: _darkBg,
        colorScheme: ColorScheme.dark(
          surface: _darkBg,
          onSurface: Colors.white,
          onSurfaceVariant: Colors.white70,
          outline: Colors.white24,
        ),
      ),
      child: Scaffold(
        backgroundColor: _darkBg,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Details'),
          centerTitle: true,
          backgroundColor: _darkBg,
          foregroundColor: Colors.white,
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total spent',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$1,590.00',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                    Material(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: const Color(0xFF1E1E1E),
                            builder: (ctx) => ListView(
                              shrinkWrap: true,
                              children: _months.map((m) => ListTile(
                                title: Text(m, style: const TextStyle(color: Colors.white)),
                                onTap: () {
                                  setState(() => _selectedMonth = m);
                                  Navigator.pop(ctx);
                                },
                              )).toList(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_selectedMonth, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              const SizedBox(width: 6),
                              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 900,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            getTitlesWidget: (value, meta) {
                              final i = value.toInt();
                              if (i < 0 || i >= _months.length) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  _months[i],
                                  style: const TextStyle(color: Colors.white54, fontSize: 11),
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
                      barGroups: List.generate(5, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: _purchase[i] + _send[i] + _received[i],
                              color: _buyPurple,
                              width: 24,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ],
                          showingTooltipIndicators: [],
                        );
                      }),
                      groupsSpace: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _legendDot(_buyPurple, 'Purchase'),
                    const SizedBox(width: 16),
                    _legendDot(_sendBlue, 'Send'),
                    const SizedBox(width: 16),
                    _legendDot(_receivedGreen, 'Received'),
                  ],
                ),
                const SizedBox(height: 28),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'History',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                ...historyItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text(item.time, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                              ],
                            ),
                          ),
                          Text(
                            item.amount,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: item.amount.startsWith('+') ? _receivedGreen : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _HistoryRow {
  final String title;
  final String time;
  final String amount;

  _HistoryRow({required this.title, required this.time, required this.amount});
}
