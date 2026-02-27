import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Bottom navigation bar for home screen: Home, Wealth, Scan (center), Discover, Profile.
/// Use [selectedIndex] to show which tab is active (0=Home, 1=Wealth, 2=Discover, 3=Profile).
class HomeBottomNav extends ConsumerWidget {
  /// Which tab is selected. 0=Home, 1=Wealth, 2=Discover, 3=Profile.
  final int selectedIndex;
  final VoidCallback? onHomeTap;
  final VoidCallback? onWealthTap;
  final VoidCallback? onScanTap;
  final VoidCallback? onDiscoverTap;
  final VoidCallback? onProfileTap;

  const HomeBottomNav({
    super.key,
    this.selectedIndex = 0,
    this.onHomeTap,
    this.onWealthTap,
    this.onScanTap,
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
            isSelected: selectedIndex == 0,
            onTap: onHomeTap ?? () {},
          ),
          HomeBottomNavItem(
            icon: Icons.trending_up_rounded,
            label: l10n.homeNavWealth,
            isSelected: selectedIndex == 1,
            onTap: onWealthTap ?? () {},
          ),
          _CenterScanButton(onTap: onScanTap ?? () {}),
          HomeBottomNavItem(
            icon: Icons.explore_rounded,
            label: l10n.homeNavDiscover,
            isSelected: selectedIndex == 2,
            onTap: onDiscoverTap ?? () {},
          ),
          HomeBottomNavItem(
            icon: Icons.person_rounded,
            label: l10n.homeNavProfile,
            isSelected: selectedIndex == 3,
            onTap: onProfileTap ?? () {},
          ),
        ],
      ),
    );
  }
}

/// Center scan button: elevated circle with QR scan icon.
class _CenterScanButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CenterScanButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryBlue,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          color: Colors.white,
          size: 28,
        ),
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
