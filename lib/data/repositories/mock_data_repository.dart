import '../models/user_profile.dart';
import '../models/market_data.dart';
import '../models/portfolio.dart';
import '../models/options_strategy.dart';
import '../models/trade_history.dart';

/// Mock Data Repository
/// Provides mock JSON data as specified in requirements
class MockDataRepository {
  // User Profile Mock Data
  static const Map<String, dynamic> _userProfileJson = {
    "user_id": "USR001",
    "name": "Sai",
    "language": "te",
    "experience_level": "beginner",
    "risk_profile": "medium",
    "account_mode": "paper"
  };

  // Market Data Mock
  static const Map<String, dynamic> _marketDataJson = {
    "indices": [
      {"symbol": "NIFTY 50", "price": 21845.30, "change": 0.65},
      {"symbol": "BANKNIFTY", "price": 46210.75, "change": -0.32}
    ]
  };

  // Portfolio Snapshot Mock
  static const Map<String, dynamic> _portfolioJson = {
    "total_value": 250000,
    "today_pnl": -1240,
    "overall_pnl": 18340,
    "risk_meter": "medium"
  };

  // Options Strategy Mock
  static const Map<String, dynamic> _optionsStrategyJson = {
    "strategy": "Iron Condor",
    "symbol": "NIFTY",
    "max_profit": 4200,
    "max_loss": 7800,
    "breakeven": ["21750", "22150"],
    "margin_required": 125000,
    "risk_level": "medium"
  };

  // Trade History Mock
  static const List<Map<String, dynamic>> _tradeHistoryJson = [
    {
      "trade_id": "TRD001",
      "symbol": "NIFTY",
      "type": "OPTION",
      "strategy": "Straddle",
      "pnl": -1200,
      "emotion": "anxious",
      "note": "Entered without checking IV"
    }
  ];

  Future<UserProfile> getUserProfile() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return UserProfile.fromJson(_userProfileJson);
  }

  Future<MarketData> getMarketData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MarketData.fromJson(_marketDataJson);
  }

  Future<PortfolioSnapshot> getPortfolioSnapshot() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return PortfolioSnapshot.fromJson(_portfolioJson);
  }

  Future<OptionsStrategy> getOptionsStrategy() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return OptionsStrategy.fromJson(_optionsStrategyJson);
  }

  Future<List<TradeHistory>> getTradeHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tradeHistoryJson
        .map((json) => TradeHistory.fromJson(json))
        .toList();
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, this would save to backend/local storage
  }
}
