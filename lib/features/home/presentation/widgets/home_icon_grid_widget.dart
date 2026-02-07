import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_icon_tile.dart';

/// Grid of icon + label items used for Financial Hub and Convenient Hub.
class HomeIconGrid extends StatelessWidget {
  final List<HomeIconGridItem> items;
  final int columns;

  const HomeIconGrid({
    super.key,
    required this.items,
    this.columns = 4,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += columns) {
      final rowItems = items.skip(i).take(columns).toList();
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + columns < items.length ? 16 : 0),
          child: Row(
            children: List.generate(columns, (j) {
              if (j < rowItems.length) {
                final e = rowItems[j];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: j < columns - 1 ? 16 : 0),
                    child: HomeHubIconItem(icon: e.icon, label: e.label),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: rows,
      ),
    );
  }
}

/// Single (icon, label) for [HomeIconGrid].
class HomeIconGridItem {
  final IconData icon;
  final String label;

  const HomeIconGridItem(this.icon, this.label);
}

/// One icon + label cell in the grid.
class HomeHubIconItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const HomeHubIconItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AppIconTile(
      icon: icon,
      label: label,
      size: 48,
    );
  }
}
