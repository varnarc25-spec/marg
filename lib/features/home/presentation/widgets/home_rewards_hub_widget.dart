import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Rewards Hub: two reward cards (meal share 20%, invite friends CVR2242).
class HomeRewardsHub extends StatelessWidget {
  const HomeRewardsHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RewardCard(
            icon: Icons.notifications_active_rounded,
            text: 'Share a meal with your friends only for today!',
            badge: '20%',
            badgeAlign: Alignment.centerLeft,
            gradient: null,
            backgroundColor: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _RewardCard(
            icon: Icons.emoji_events_rounded,
            text: 'Get rewards of up to 200 points with every new friend you invite!',
            badge: 'CVR2242',
            badgeAlign: Alignment.centerRight,
            badgeColor: AppColors.accentGreen,
            gradient: LinearGradient(
              colors: [AppColors.primaryBlue, AppColors.accentOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final String badge;
  final Alignment badgeAlign;
  final Color? badgeColor;
  final Color? backgroundColor;
  final Gradient? gradient;

  const _RewardCard({
    required this.icon,
    required this.text,
    required this.badge,
    required this.badgeAlign,
    this.badgeColor,
    this.backgroundColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isGradient = gradient != null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isGradient ? null : backgroundColor,
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: isGradient ? 0.25 : 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: isGradient ? 12 : 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: badgeAlign,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: badgeAlign == Alignment.centerRight ? 8 : 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: badgeColor ?? Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: badgeColor != null ? 12 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
