import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/market_data.dart';

/// Market Overview Card
/// Displays NIFTY and BANKNIFTY data
class MarketOverviewCard extends StatelessWidget {
  final MarketData marketData;

  const MarketOverviewCard({super.key, required this.marketData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: marketData.indices.map((index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _IndexRow(index: index),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _IndexRow extends StatelessWidget {
  final IndexData index;

  const _IndexRow({required this.index});

  String _formatPrice(double price) {
    return price.toStringAsFixed(2);
  }

  String _formatChange(double change) {
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(2)}%';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                index.symbol,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatPrice(index.price),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: index.isPositive
                ? AppColors.accentGreen.withOpacity(0.1)
                : AppColors.accentRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                index.isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: index.isPositive
                    ? AppColors.accentGreen
                    : AppColors.accentRed,
              ),
              const SizedBox(width: 4),
              Text(
                _formatChange(index.change),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: index.isPositive
                          ? AppColors.accentGreen
                          : AppColors.accentRed,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
