import 'package:flutter/material.dart';

class HealthHomeTestimonialCard extends StatelessWidget {
  const HealthHomeTestimonialCard({
    super.key,
    required this.quote,
    required this.author,
    required this.avatarColor,
    required this.colorScheme,
    required this.textTheme,
  });

  final String quote;
  final String author;
  final Color avatarColor;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final parts = author.split(' ').where((e) => e.isNotEmpty).take(2);
    final initial = parts.isEmpty ? '?' : parts.map((e) => e[0].toUpperCase()).join();

    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.surface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.format_quote_rounded,
                  size: 24,
                  color: colorScheme.primary.withValues(alpha: 0.6),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              quote,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Text(
              author,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
