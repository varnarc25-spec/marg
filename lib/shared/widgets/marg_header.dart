import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations.dart';

/// App bar–style header with Marg logo and app name.
/// Use [leading] for sub-pages (e.g. back icon).
class MargHeader extends StatelessWidget {
  final AppLocalizations l10n;
  final Widget? leading;
  final VoidCallback? onAiTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;

  const MargHeader({
    super.key,
    required this.l10n,
    this.leading,
    this.onAiTap,
    this.onSearchTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8),
          ],
          Icon(Icons.eco_rounded, size: 28, color: AppColors.primaryBlue),
          const SizedBox(width: 8),
          Text(
            l10n.appName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onAiTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'AI',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary),
            onPressed: onSearchTap,
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: onNotificationTap,
          ),
        ],
      ),
    );
  }
}
