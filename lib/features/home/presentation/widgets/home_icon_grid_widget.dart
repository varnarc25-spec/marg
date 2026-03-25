import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_icon_tile.dart';

/// Grid of icon + label items used for Financial Hub and Convenient Hub.
/// When [maxItems] is set (e.g. 4), only that many items are shown (for home; use "View All" for the rest).
class HomeIconGrid extends StatelessWidget {
  final List<HomeIconGridItem> items;
  final int columns;

  /// When non-null, only the first [maxItems] items are displayed (e.g. 4 on home screen).
  final int? maxItems;

  const HomeIconGrid({
    super.key,
    required this.items,
    this.columns = 4,
    this.maxItems,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = maxItems != null
        ? items.take(maxItems!).toList()
        : items;
    final rows = <Widget>[];
    for (var i = 0; i < displayItems.length; i += columns) {
      final rowItems = displayItems.skip(i).take(columns).toList();
      rows.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: i + columns < displayItems.length ? 16 : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(columns, (j) {
              if (j < rowItems.length) {
                final e = rowItems[j];
                final index = i * columns + j;
                final bgColor = index.isEven
                    ? AppColors.iconTilePastelBlue
                    : AppColors.iconTilePastelPurple;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: j < columns - 1 ? 16 : 0),
                    child: HomeHubIconItem(
                      icon: e.icon,
                      label: e.label,
                      iconColor: Colors.white,
                      backgroundColor: bgColor,
                      onTap: e.onTap,
                    ),
                  ),
                );
              }
              return const Expanded(child: SizedBox.shrink());
            }),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: rows),
    );
  }
}

/// Single (icon, label) for [HomeIconGrid].
/// [onTap] is optional; when set, the tile is tappable (e.g. navigate to feature).
class HomeIconGridItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const HomeIconGridItem(this.icon, this.label, {this.onTap});
}

/// One icon + label cell in the grid.
class HomeHubIconItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const HomeHubIconItem({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppIconTile(
      icon: icon,
      label: label,
      size: 58,
      iconColor: iconColor ?? AppColors.primaryBlueDark,
      backgroundColor: backgroundColor ?? AppColors.primaryBlueLight,
      onTap: onTap,
    );
  }
}
