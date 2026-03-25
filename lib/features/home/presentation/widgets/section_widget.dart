import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/home_section.dart';
import '../screens/home_section_all_screen.dart';
import '../utils/home_flow_router.dart';
import 'grid_item_widget.dart';

class SectionWidget extends StatelessWidget {
  const SectionWidget({
    super.key,
    required this.section,
    this.onViewAllTap,
  });

  final HomeSection section;

  /// When set, called instead of the default snackbar (e.g. Recharges hub detail).
  final VoidCallback? onViewAllTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final itemCount = section.items.length;
    debugPrint('Section: ${section.title}, itemCount: $itemCount');
    final visibleItemCount = itemCount > 4 ? 4 : itemCount;
    final showViewAll = section.viewAll || itemCount > 4;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  section.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (showViewAll)
                TextButton(
                  onPressed: () {
                    if (onViewAllTap != null) {
                      onViewAllTap!();
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        settings: RouteSettings(
                          name: '/home/section/${section.slug}',
                        ),
                        builder: (_) =>
                            HomeSectionAllScreen(section: section),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleItemCount,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 8,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (context, index) {
                final item = section.items[index];
                return GridItemWidget(
                  tileIndex: index,
                  item: item,
                  onTap: () => routeByFlowType(context, item.flowType),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
