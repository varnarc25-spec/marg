import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Home screen header: search bar and quick action chips (Send, Receive, Balance).
class HomeHeader extends ConsumerWidget {
  const HomeHeader({
    super.key,
    this.onSendTap,
    this.onReceiveTap,
    this.onBalanceTap,
  });

  final VoidCallback? onSendTap;
  final VoidCallback? onReceiveTap;
  final VoidCallback? onBalanceTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, size: 22, color: AppColors.textSecondary),
                      const SizedBox(width: 10),
                      Text(
                        l10n.homeSearchHint,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HomeQuickActionChip(
                  icon: Icons.send_rounded,
                  label: l10n.homeQuickSend,
                  onTap: onSendTap,
                ),
                HomeQuickActionChip(
                  icon: Icons.call_received_rounded,
                  label: l10n.homeQuickReceive,
                  onTap: onReceiveTap,
                ),
                HomeQuickActionChip(
                  icon: Icons.account_balance_wallet_rounded,
                  label: l10n.homeQuickBalance,
                  onTap: onBalanceTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Single quick action in the header row.
class HomeQuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const HomeQuickActionChip({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: AppColors.primaryBlue),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: content,
        ),
      );
    }
    return content;
  }
}
