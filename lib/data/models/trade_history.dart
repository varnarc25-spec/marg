/// Trade History Model
class TradeHistory {
  final String tradeId;
  final String symbol;
  final String type; // 'EQUITY', 'OPTION'
  final String strategy;
  final double pnl;
  final String emotion; // 'happy', 'neutral', 'anxious', etc.
  final String note;

  TradeHistory({
    required this.tradeId,
    required this.symbol,
    required this.type,
    required this.strategy,
    required this.pnl,
    required this.emotion,
    required this.note,
  });

  factory TradeHistory.fromJson(Map<String, dynamic> json) {
    return TradeHistory(
      tradeId: json['trade_id'] as String,
      symbol: json['symbol'] as String,
      type: json['type'] as String,
      strategy: json['strategy'] as String,
      pnl: (json['pnl'] as num).toDouble(),
      emotion: json['emotion'] as String,
      note: json['note'] as String,
    );
  }

  bool get isProfit => pnl >= 0;
}
