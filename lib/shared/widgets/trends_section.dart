import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trend_item.dart';
import '../providers/app_providers.dart';
import '../../core/theme/app_theme.dart';

/// Reusable trends/content section widget.
/// - Loads trend items from [trendsProvider] using [sectionKey] (e.g. 'gold_buy').
/// - Optional [contentType] can narrow results (article, guide, video, etc.).
class TrendsSection extends ConsumerWidget {
  final String sectionKey;
  final String? contentType;
  final String title;

  const TrendsSection({
    super.key,
    required this.sectionKey,
    this.contentType,
    this.title = 'Read On The Latest Trends',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTrends = ref.watch(
      trendsProvider(TrendsQuery(section: sectionKey, contentType: contentType)),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: asyncTrends.when(
        loading: () => const Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Read On The Latest Trends',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text(
              'Unable to load content right now. Please try again later.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        data: (items) {
          if (items.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Read On The Latest Trends',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 8),
                Text(
                  'No articles available yet for this section.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              ...items.map(_TrendTile.new),
            ],
          );
        },
      ),
    );
  }
}

class _TrendTile extends StatelessWidget {
  final TrendItem item;
  const _TrendTile(this.item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const _TrendIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 13),
                ),
                if (item.contentType.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.contentType.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendIcon extends StatelessWidget {
  const _TrendIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: const Icon(
        Icons.article_outlined,
        color: AppColors.primaryBlue,
        size: 18,
      ),
    );
  }
}

