/// Market Data Models
class IndexData {
  final String symbol;
  final double price;
  final double change; // Percentage change

  IndexData({
    required this.symbol,
    required this.price,
    required this.change,
  });

  factory IndexData.fromJson(Map<String, dynamic> json) {
    return IndexData(
      symbol: json['symbol'] as String,
      price: (json['price'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
    );
  }

  bool get isPositive => change >= 0;
}

class MarketData {
  final List<IndexData> indices;

  MarketData({required this.indices});

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      indices: (json['indices'] as List)
          .map((e) => IndexData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
