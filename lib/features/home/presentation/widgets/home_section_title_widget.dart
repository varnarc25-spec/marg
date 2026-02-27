import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Section title used above each hub on the home screen.
/// When [onViewAllTap] is non-null and [showViewAll] is true, shows "View All" on the right.
class HomeSectionTitle extends ConsumerWidget {
  final String title;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;

  const HomeSectionTitle({
    super.key,
    required this.title,
    this.showViewAll = false,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    final showTrailing = showViewAll && onViewAllTap != null;
    if (!showTrailing) {
      return Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onViewAllTap,
          child: Text(
            l10n.homeViewAll,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
      ],
    );
  }
}
