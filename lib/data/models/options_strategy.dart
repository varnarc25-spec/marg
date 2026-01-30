/// Options Strategy Model
class OptionsStrategy {
  final String strategy;
  final String symbol;
  final double maxProfit;
  final double maxLoss;
  final List<String> breakeven;
  final double marginRequired;
  final String riskLevel; // 'low', 'medium', 'high'

  OptionsStrategy({
    required this.strategy,
    required this.symbol,
    required this.maxProfit,
    required this.maxLoss,
    required this.breakeven,
    required this.marginRequired,
    required this.riskLevel,
  });

  factory OptionsStrategy.fromJson(Map<String, dynamic> json) {
    return OptionsStrategy(
      strategy: json['strategy'] as String,
      symbol: json['symbol'] as String,
      maxProfit: (json['max_profit'] as num).toDouble(),
      maxLoss: (json['max_loss'] as num).toDouble(),
      breakeven: (json['breakeven'] as List).map((e) => e.toString()).toList(),
      marginRequired: (json['margin_required'] as num).toDouble(),
      riskLevel: json['risk_level'] as String,
    );
  }
}
