import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Reusable \"safe, secure and transparent\" info row with three icons.
class InfoIconsRow extends StatelessWidget {
  final Color accent;

  const InfoIconsRow({super.key, required this.accent});

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          const Text(
            'Safe, secure and transparent',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _InfoIcon(
                icon: Icons.thumb_up_alt_outlined,
                title: '99.99%',
                subtitle: 'Purity',
                accent: accent,
              ),
              _InfoIcon(
                icon: Icons.shield_outlined,
                title: 'Low-Risk',
                subtitle: 'Investment',
                accent: accent,
              ),
              _InfoIcon(
                icon: Icons.verified_user_outlined,
                title: 'Safe &',
                subtitle: 'Secure',
                accent: accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  const _InfoIcon({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: accent),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

