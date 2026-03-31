import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/service_item.dart';
import '../utils/home_icon_mapper.dart';

class GridItemWidget extends StatelessWidget {
  const GridItemWidget({
    super.key,
    required this.item,
    required this.onTap,
    required this.tileIndex,
  });

  final ServiceItem item;
  final VoidCallback onTap;

  /// Alternating pastel blue / purple tile backgrounds (matches home section design).
  final int tileIndex;

  Color get _tileBackground =>
      tileIndex.isEven ? AppColors.iconTilePastelBlue : AppColors.iconTilePastelPurple;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _tileBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: item.iconUrl != null && item.iconUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: item.iconUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Icon(
                              mapHomeIcon(item.icon),
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        )
                      : Icon(
                          mapHomeIcon(item.icon),
                          color: Colors.white,
                          size: 28,
                        ),
                ),
                if (item.badge != null && item.badge!.isNotEmpty)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.badge!,
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
