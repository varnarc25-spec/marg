import 'package:flutter/material.dart';

/// Small icon + label tile on the life insurance home hero row.
class LifeHomeFeatureCard extends StatelessWidget {
  const LifeHomeFeatureCard({
    super.key,
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.textTheme,
  });

  final IconData icon;
  final String label;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
