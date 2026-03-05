import 'package:flutter/material.dart';

/// Market index (NIFTY / SENSEX) display.
class MarketIndex {
  const MarketIndex({
    required this.name,
    required this.value,
    required this.change,
    required this.changePercent,
    required this.isPositive,
  });

  final String name;
  final String value;
  final String change;
  final String changePercent;
  final bool isPositive;
}

/// Investment idea card (e.g. Persistent Systems, Bharat Electronics).
class InvestmentIdeaItem {
  const InvestmentIdeaItem({
    required this.title,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.isPositive,
    required this.buyPrice,
    required this.targetPrice,
    required this.poweredBy,
    this.logoColor,
  });

  final String title;
  final String price;
  final String change;
  final String changePercent;
  final bool isPositive;
  final String buyPrice;
  final String targetPrice;
  final String poweredBy;
  final Color? logoColor;
}

/// Market mover stock (Top Gainers / Losers list).
class MarketMoverItem {
  const MarketMoverItem({
    required this.name,
    required this.exchange,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.isPositive,
  });

  final String name;
  final String exchange;
  final String price;
  final String change;
  final String changePercent;
  final bool isPositive;
}

/// News card for "News in, action on!" section.
class InvestNewsItem {
  const InvestNewsItem({
    required this.companyName,
    required this.headline,
    required this.price,
    required this.changePercent,
    required this.isPositive,
    required this.timestamp,
  });

  final String companyName;
  final String headline;
  final String price;
  final String changePercent;
  final bool isPositive;
  final String timestamp;
}

/// Expert recommendation card.
class ExpertRecommendationItem {
  const ExpertRecommendationItem({
    required this.companyName,
    required this.price,
    required this.changePercent,
    required this.isPositive,
    required this.recommendationText,
  });

  final String companyName;
  final String price;
  final String changePercent;
  final bool isPositive;
  final String recommendationText;
}

/// Investor tool (Margin Pledge, Stocks SIP, etc.).
class InvestorToolItem {
  const InvestorToolItem({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

// ——————— Mock data ———————

const List<MarketIndex> investMarketIndices = [
  MarketIndex(
    name: 'NIFTY',
    value: '24,377.90',
    change: '-487.80',
    changePercent: '1.96%',
    isPositive: false,
  ),
  MarketIndex(
    name: 'SENSEX',
    value: '78,717.25',
    change: '-1,521.',
    changePercent: '1.90%',
    isPositive: false,
  ),
];

const List<String> investMarketMoverTabs = [
  'Top Gainers',
  'Top Losers',
  'Market High',
  'Market Cap',
];

const List<InvestmentIdeaItem> investIdeas = [
  InvestmentIdeaItem(
    title: 'Persistent Systems',
    price: '4,675.00',
    change: '+1.60',
    changePercent: '0.03%',
    isPositive: true,
    buyPrice: 'Buy 4685',
    targetPrice: 'Target 4991',
    poweredBy: 'Powered by Lotus Funds',
    logoColor: Color(0xFFFF6F00),
  ),
  InvestmentIdeaItem(
    title: 'Bharat Electronics',
    price: '454.15',
    change: '+0.20',
    changePercent: '0.04%',
    isPositive: true,
    buyPrice: 'Buy 447.5',
    targetPrice: 'Target 495',
    poweredBy: 'Powered by Clovek Wealth',
    logoColor: Color(0xFF1E88E5),
  ),
  InvestmentIdeaItem(
    title: 'HDFC Bank',
    price: '1,650.20',
    change: '-5.40',
    changePercent: '0.33%',
    isPositive: false,
    buyPrice: 'Buy 1640',
    targetPrice: 'Target 1720',
    poweredBy: 'Powered by Refinitiv',
    logoColor: Color(0xFF00C853),
  ),
];

const List<MarketMoverItem> investTopGainers = [
  MarketMoverItem(
    name: 'Coal India',
    exchange: 'NSE',
    price: '435.15',
    change: '+8.90',
    changePercent: '2.09%',
    isPositive: true,
  ),
  MarketMoverItem(
    name: 'Infosys',
    exchange: 'NSE',
    price: '1,303.70',
    change: '+14.80',
    changePercent: '1.15%',
    isPositive: true,
  ),
  MarketMoverItem(
    name: 'Bharti Airtel',
    exchange: 'NSE',
    price: '1,879.90',
    change: '+7.70',
    changePercent: '0.41%',
    isPositive: true,
  ),
  MarketMoverItem(
    name: 'TCS',
    exchange: 'NSE',
    price: '3,850.25',
    change: '+22.50',
    changePercent: '0.59%',
    isPositive: true,
  ),
];

const List<InvestNewsItem> investNewsItems = [
  InvestNewsItem(
    companyName: 'Natco Pharma',
    headline: 'Natco Pharma gains on Pomalidomide capsules launch in US',
    price: '970.80',
    changePercent: '+1.52%',
    isPositive: true,
    timestamp: 'Mar 04, 09:49 AM',
  ),
  InvestNewsItem(
    companyName: 'Allied Blenders and Distillers',
    headline: "Allied Blenders' board nod to acquire 50% stake in Kion Blenders",
    price: '456.55',
    changePercent: '-3.07%',
    isPositive: false,
    timestamp: 'Mar 04, 09:40 AM',
  ),
  InvestNewsItem(
    companyName: 'Reliance',
    headline: 'Reliance Industries announces new green energy initiative',
    price: '1,245.00',
    changePercent: '+0.85%',
    isPositive: true,
    timestamp: 'Mar 04, 09:35 AM',
  ),
];

const List<ExpertRecommendationItem> investExpertRecommendations = [
  ExpertRecommendationItem(
    companyName: 'Somany Ceramics',
    price: '377.75',
    changePercent: '-2.73%',
    isPositive: false,
    recommendationText: '100% Experts recommend Buy',
  ),
  ExpertRecommendationItem(
    companyName: 'Asian Paints',
    price: '2,850.50',
    changePercent: '+1.20%',
    isPositive: true,
    recommendationText: '85% Experts recommend Buy',
  ),
  ExpertRecommendationItem(
    companyName: 'ITC',
    price: '425.30',
    changePercent: '+0.45%',
    isPositive: true,
    recommendationText: '90% Experts recommend Hold',
  ),
];

const List<InvestorToolItem> investTools = [
  InvestorToolItem(label: 'Margin Pledge', icon: Icons.account_balance_wallet_rounded),
  InvestorToolItem(label: 'Stocks SIP', icon: Icons.calendar_today_rounded),
  InvestorToolItem(label: 'MTF Calc', icon: Icons.calculate_rounded),
  InvestorToolItem(label: 'Price Alerts', icon: Icons.notifications_active_rounded),
];
