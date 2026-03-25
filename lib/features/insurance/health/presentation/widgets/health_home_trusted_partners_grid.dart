import 'package:flutter/material.dart';
import 'package:marg/features/insurance/health/data/health_insurance_plan.dart';

class HealthHomeTrustedPartnersGrid extends StatelessWidget {
  const HealthHomeTrustedPartnersGrid({
    super.key,
    required this.colorScheme,
    required this.textTheme,
    required this.partners,
    this.isLoading = false,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  /// From GET `/api/insurance/health/partners`.
  final List<HealthInsurancePlan> partners;
  final bool isLoading;

  static const List<String> _fallbackNames = [
    'Aditya Birla Health',
    'Bajaj Allianz',
    'Digit',
    'ICICI Lombard',
    'Reliance General',
    'Star Health',
  ];

  @override
  Widget build(BuildContext context) {
    if (isLoading && partners.isEmpty) {
      return SizedBox(
        height: 120,
        child: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    final names = partners.isEmpty
        ? _fallbackNames
        : partners.map((p) => p.insurerName).where((n) => n.isNotEmpty).toList();

    if (names.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: names.map((name) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                name,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
