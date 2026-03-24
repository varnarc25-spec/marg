import 'package:flutter/material.dart';

class FlightFilterSortBar extends StatelessWidget {
  const FlightFilterSortBar({
    super.key,
    required this.sortLabel,
    required this.onSortTap,
    required this.aiFiltersActive,
    required this.onAiFiltersTap,
    required this.nonStopOnly,
    required this.onNonStopTap,
    required this.onFiltersTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final String sortLabel;
  final VoidCallback onSortTap;
  final bool aiFiltersActive;
  final VoidCallback onAiFiltersTap;
  final bool nonStopOnly;
  final VoidCallback onNonStopTap;
  final VoidCallback onFiltersTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _FilterChip(
            icon: Icons.tune_rounded,
            label: 'Filters',
            onTap: onFiltersTap,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            icon: Icons.keyboard_arrow_down_rounded,
            label: sortLabel,
            onTap: onSortTap,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            icon: Icons.auto_awesome_rounded,
            label: 'AI Filters',
            selected: aiFiltersActive,
            onTap: onAiFiltersTap,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            icon: Icons.flight_rounded,
            label: 'Non-Stop',
            selected: nonStopOnly,
            onTap: onNonStopTap,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.icon,
    required this.label,
    this.selected = false,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? colorScheme.primary.withValues(alpha: 0.12)
          : colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: selected ? colorScheme.primary : colorScheme.onSurface,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
