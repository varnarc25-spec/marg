import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_strings.dart';

/// Risk Meter Widget
/// Visual indicator of current risk level
class RiskMeterWidget extends StatelessWidget {
  final String riskLevel; // 'low', 'medium', 'high'

  const RiskMeterWidget({super.key, required this.riskLevel});

  Color _getRiskColor() {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return AppColors.riskLow;
      case 'medium':
        return AppColors.riskMedium;
      case 'high':
        return AppColors.riskHigh;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getRiskLabel() {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return AppStrings.riskLow;
      case 'medium':
        return AppStrings.riskMedium;
      case 'high':
        return AppStrings.riskHigh;
      default:
        return riskLevel;
    }
  }

  double _getRiskPercentage() {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return 0.33;
      case 'medium':
        return 0.66;
      case 'high':
        return 1.0;
      default:
        return 0.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final riskColor = _getRiskColor();
    final riskPercentage = _getRiskPercentage();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.homeRiskMeter,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getRiskLabel(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: riskColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: riskPercentage,
                minHeight: 12,
                backgroundColor: AppColors.textSecondary.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(riskColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
