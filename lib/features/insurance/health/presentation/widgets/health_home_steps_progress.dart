import 'package:flutter/material.dart';

class HealthHomeStepsProgress extends StatelessWidget {
  const HealthHomeStepsProgress({
    super.key,
    required this.currentStep,
    required this.colorScheme,
    required this.textTheme,
  });

  final int currentStep;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  static const _stepLabels = [
    'Choose policy plan',
    'Submit details',
    'Complete KYC',
    'Get your policy',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (index) {
        final isActive = index + 1 <= currentStep;
        final isLast = index == 3;
        return Expanded(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? colorScheme.onPrimary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _stepLabels[index],
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 28),
                    color: colorScheme.surfaceContainerHighest,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
