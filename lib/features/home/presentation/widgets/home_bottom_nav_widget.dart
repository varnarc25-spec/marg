import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Bottom navigation bar for home screen: Home, Wealth, Discover, Profile.
class HomeBottomNav extends ConsumerWidget {
  final VoidCallback? onWealthTap;
  final VoidCallback? onDiscoverTap;
  final VoidCallback? onProfileTap;

  const HomeBottomNav({
    super.key,
    this.onWealthTap,
    this.onDiscoverTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 8 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HomeBottomNavItem(
            icon: Icons.home_rounded,
            label: l10n.homeNavHome,
            isSelected: true,
            onTap: () {},
          ),
          HomeBottomNavItem(
            icon: Icons.trending_up_rounded,
            label: l10n.homeNavWealth,
            onTap: onWealthTap ?? () {},
          ),
          HomeBottomNavItem(
            icon: Icons.explore_rounded,
            label: l10n.homeNavDiscover,
            onTap: onDiscoverTap ?? () {},
          ),
          HomeBottomNavItem(
            icon: Icons.person_rounded,
            label: l10n.homeNavProfile,
            onTap: onProfileTap ?? () {},
          ),
        ],
      ),
    );
  }
}

/// Single item in [HomeBottomNav].
class HomeBottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const HomeBottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
