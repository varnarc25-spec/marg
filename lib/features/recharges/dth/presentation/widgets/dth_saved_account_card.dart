import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/models/dth_saved_account.dart';

/// Saved DTH row: logo, title, id · operator, footer (expiry or added date).
class DthSavedAccountCard extends StatelessWidget {
  const DthSavedAccountCard({
    super.key,
    required this.account,
    this.onTap,
    this.onDelete,
  });

  final DthSavedAccount account;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  static String _formatShortDate(DateTime d) {
    return DateFormat('d MMM').format(d);
  }

  static String _formatAdded(DateTime d) {
    return DateFormat('d MMM yyyy').format(d);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasExpiry = account.planExpiresOn != null;
    final expirySoon = hasExpiry &&
        account.planExpiresOn!.difference(DateTime.now()).inDays <= 30;

    Widget? footer;
    if (hasExpiry && account.planAmount != null) {
      footer = Text(
        '₹${account.planAmount!.toStringAsFixed(0)} plan expires on ${_formatShortDate(account.planExpiresOn!)}',
        style: textTheme.bodySmall?.copyWith(
          color: expirySoon ? Colors.red.shade700 : AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (account.createdAt != null) {
      footer = Text(
        'Added on ${_formatAdded(account.createdAt!)}',
        style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Logo(logoUrl: account.logoUrl, label: account.operatorName),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.displayTitle,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      account.subtitleLine,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (footer != null) ...[
                      const SizedBox(height: 8),
                      footer,
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.grey.shade600,
                ),
                onSelected: (v) {
                  if (v == 'delete') onDelete?.call();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({this.logoUrl, required this.label});

  final String? logoUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    final initial = label.isNotEmpty ? label.substring(0, 1).toUpperCase() : 'D';
    final url = logoUrl?.trim();
    return CircleAvatar(
      radius: 26,
      backgroundColor: AppColors.primaryBlueLight.withValues(alpha: 0.2),
      child: url != null && url.isNotEmpty
          ? ClipOval(
              child: Image.network(
                url,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Text(
                  initial,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            )
          : Text(
              initial,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.primaryBlue,
              ),
            ),
    );
  }
}
