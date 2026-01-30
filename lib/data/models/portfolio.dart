/// Portfolio Snapshot Model
class PortfolioSnapshot {
  final double totalValue;
  final double todayPnl;
  final double overallPnl;
  final String riskMeter; // 'low', 'medium', 'high'

  PortfolioSnapshot({
    required this.totalValue,
    required this.todayPnl,
    required this.overallPnl,
    required this.riskMeter,
  });

  factory PortfolioSnapshot.fromJson(Map<String, dynamic> json) {
    return PortfolioSnapshot(
      totalValue: (json['total_value'] as num).toDouble(),
      todayPnl: (json['today_pnl'] as num).toDouble(),
      overallPnl: (json['overall_pnl'] as num).toDouble(),
      riskMeter: json['risk_meter'] as String,
    );
  }

  bool get isTodayPnlPositive => todayPnl >= 0;
  bool get isOverallPnlPositive => overallPnl >= 0;
}
