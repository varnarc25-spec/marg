import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/home_section.dart';
import '../utils/home_flow_router.dart';
import '../widgets/grid_item_widget.dart';

/// Full grid for one dynamic home section (opened from "View All").
///
/// [section.slug] identifies the section from app-data; items are the same
/// list already loaded for the home screen (no extra API call).
class HomeSectionAllScreen extends StatelessWidget {
  const HomeSectionAllScreen({super.key, required this.section});

  final HomeSection section;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(section.title),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: section.items.isEmpty
            ? Center(
                child: Text(
                  'No services in this section',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.82,
                ),
                itemCount: section.items.length,
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
    );
  }
}
