import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Service Hub: message tiles and insurance promo card.
class HomeServiceHub extends StatelessWidget {
  final VoidCallback? onFirstMessageTap;
  final VoidCallback? onSecondMessageTap;

  const HomeServiceHub({
    super.key,
    this.onFirstMessageTap,
    this.onSecondMessageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeServiceMessageTile(
          title: 'Yay! You have a new message.',
          time: '2 hours ago',
          onTap: onFirstMessageTap,
        ),
        const SizedBox(height: 8),
        HomeServiceMessageTile(
          title: 'Congratulations! new year offers.',
          time: '2 hours ago',
          onTap: onSecondMessageTap,
        ),
        const SizedBox(height: 12),
        const HomeInsurancePromoCard(),
      ],
    );
  }
}

/// Single message/notification tile in Service Hub.
class HomeServiceMessageTile extends StatelessWidget {
  final String title;
  final String time;
  final VoidCallback? onTap;

  const HomeServiceMessageTile({
    super.key,
    required this.title,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Insurance promo card in Service Hub.
class HomeInsurancePromoCard extends StatelessWidget {
  const HomeInsurancePromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Grab your Insurance Offer Today!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Beat 25% off your next insurance renewals with us and protect your family!!',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(3, (_) => Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                  )),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.umbrella_rounded, size: 48, color: AppColors.primaryBlue),
        ],
      ),
    );
  }
}
