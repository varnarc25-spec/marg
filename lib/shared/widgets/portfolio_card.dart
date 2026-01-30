import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/portfolio.dart';

/// Portfolio Card Widget
/// Displays portfolio snapshot with P&L
class PortfolioCard extends StatelessWidget {
  final PortfolioSnapshot portfolio;

  const PortfolioCard({super.key, required this.portfolio});

  String _formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.primaryBlue.withOpacity(0.1),
              AppColors.primaryBlue.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.homePortfolio,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _formatCurrency(portfolio.totalValue),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _PnlItem(
                    label: AppStrings.homeTodayPnl,
                    value: portfolio.todayPnl,
                    isPositive: portfolio.isTodayPnlPositive,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _PnlItem(
                    label: AppStrings.homeOverallPnl,
                    value: portfolio.overallPnl,
                    isPositive: portfolio.isOverallPnlPositive,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PnlItem extends StatelessWidget {
  final String label;
  final double value;
  final bool isPositive;

  const _PnlItem({
    required this.label,
    required this.value,
    required this.isPositive,
  });

  String _formatCurrency(double amount) {
    final sign = amount >= 0 ? '+' : '';
    return '$sign₹${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          _formatCurrency(value),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isPositive ? AppColors.accentGreen : AppColors.accentRed,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
