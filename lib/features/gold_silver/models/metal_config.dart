import 'package:flutter/material.dart';

class MetalConfig {
  final String appBarTitle;
  final String balanceTitle;
  final String investTitle;
  final String buyPriceLabel;
  final String buyPriceValue;
  final String buyPriceMeta;
  final String riseText;
  final String purityText;
  final Color appBarColor;
  final Color accentColor;
  final Color chartFill;
  final String sectionKey;

  const MetalConfig({
    required this.appBarTitle,
    required this.balanceTitle,
    required this.investTitle,
    required this.buyPriceLabel,
    required this.buyPriceValue,
    required this.buyPriceMeta,
    required this.riseText,
    required this.purityText,
    required this.appBarColor,
    required this.accentColor,
    required this.chartFill,
    required this.sectionKey,
  });

  static const gold = MetalConfig(
    appBarTitle: 'Marg Digital Gold',
    balanceTitle: 'My Gold Balance 123',
    investTitle: 'Invest in 24k Gold',
    buyPriceLabel: 'Buying Price:',
    buyPriceValue: '₹1634.18/gm',
    buyPriceMeta: '(+3% GST)',
    riseText: '245.8% Gold price rise in last 5 years',
    purityText: 'You will be purchasing gold of 24K | 99.9% purity',
    appBarColor: Color(0xFF1876B6),
    accentColor: Color(0xFF1876B6),
    chartFill: Color(0xFFFFC107),
    sectionKey: 'gold_buy',
  );

  static const silver999 = MetalConfig(
    appBarTitle: 'Digital Silver (999)',
    balanceTitle: 'My Silver Balance',
    investTitle: 'Invest in 999 Silver',
    buyPriceLabel: 'Buying Price:',
    buyPriceValue: '₹120.50/gm',
    buyPriceMeta: '(+3% GST)',
    riseText: '112.4% Silver price rise in last 5 years',
    purityText: 'You will be purchasing silver of 999 | 99.9% purity',
    appBarColor: Color(0xFF374151),
    accentColor: Color(0xFF374151),
    chartFill: Color(0xFFB0BEC5),
    sectionKey: 'silver_buy',
  );
}
