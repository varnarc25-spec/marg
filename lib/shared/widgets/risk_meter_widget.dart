import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations.dart';

/// Risk Meter Widget
/// Visual indicator of current risk level
class RiskMeterWidget extends ConsumerWidget {
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

  String _getRiskLabel(AppLocalizations l10n) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return l10n.riskLow;
      case 'medium':
        return l10n.riskMedium;
      case 'high':
        return l10n.riskHigh;
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
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
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
                  l10n.homeRiskMeter,
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
                    _getRiskLabel(l10n),
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
