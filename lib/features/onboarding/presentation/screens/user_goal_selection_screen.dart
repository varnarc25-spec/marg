import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/progress_indicator_widget.dart';
import '../../../../shared/widgets/app_icon_tile.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'experience_level_screen.dart';

/// User Goal Selection Screen
/// Users select their trading goal — layout inspired by search engine choice pattern
class UserGoalSelectionScreen extends ConsumerStatefulWidget {
  const UserGoalSelectionScreen({super.key});

  @override
  ConsumerState<UserGoalSelectionScreen> createState() =>
      _UserGoalSelectionScreenState();
}

class _UserGoalSelectionScreenState extends ConsumerState<UserGoalSelectionScreen> {
  String? selectedGoal;
  int? expandedIndex;

  static List<Map<String, dynamic>> _goals(AppLocalizations l10n) => [
        {'id': 'beginner', 'title': l10n.goalBeginner, 'description': l10n.goalBeginnerDesc, 'icon': Icons.school},
        {'id': 'active', 'title': l10n.goalActive, 'description': l10n.goalActiveDesc, 'icon': Icons.trending_up},
        {'id': 'options', 'title': l10n.goalOptions, 'description': l10n.goalOptionsDesc, 'icon': Icons.show_chart},
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = ref.watch(l10nProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProgressIndicatorWidget(currentStep: 2, totalSteps: 6),
              const SizedBox(height: 24),
              // Header icon
              const AppIconTile(icon: Icons.flag_outlined, size: 64),
              const SizedBox(height: 20),
              // Title
              Text(
                l10n.whyAreYouHere,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Descriptive paragraph
              Text(
                l10n.personalizeExperience,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              // List of options
              Expanded(
                child: ListView.separated(
                  itemCount: _goals(l10n).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    final goal = _goals(l10n)[index];
                    final isExpanded = expandedIndex == index;
                    return _GoalListTile(
                      value: goal['id'] as String,
                      title: goal['title'] as String,
                      description: goal['description'] as String,
                      icon: goal['icon'] as IconData,
                      groupValue: selectedGoal,
                      isExpanded: isExpanded,
                      onTap: () =>
                          setState(() => selectedGoal = goal['id'] as String),
                      onExpandToggle: () => setState(() {
                        expandedIndex = isExpanded ? null : index;
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Next button — bottom right
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: selectedGoal == null
                      ? null
                      : () async {
                          if (selectedGoal != null) {
                            await ref
                                .read(onboardingUserGoalProvider.notifier)
                                .setGoal(selectedGoal!);
                          }
                          if (!context.mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ExperienceLevelScreen(),
                            ),
                          );
                        },
                  style: TextButton.styleFrom(
                    backgroundColor: selectedGoal != null
                        ? AppColors.primaryBlue.withOpacity(0.9)
                        : AppColors.textSecondary.withOpacity(0.3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(l10n.next),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalListTile extends StatelessWidget {
  final String value;
  final String title;
  final String description;
  final IconData icon;
  final String? groupValue;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onExpandToggle;

  const _GoalListTile({
    required this.value,
    required this.title,
    required this.description,
    required this.icon,
    required this.groupValue,
    required this.isExpanded,
    required this.onTap,
    required this.onExpandToggle,
  });

  /// Soft, diffuse box shadow for lifted card effect (light grey, low opacity, large blur)
  static List<BoxShadow> get _cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 24,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _cardShadow,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leading icon (styled tile)
                AppIconTile(
                  icon: icon,
                  size: 40,
                  iconColor: Colors.white,
                  backgroundColor: AppColors.iconTileBackground,
                ),
                const SizedBox(width: 16),
                // Title + optional description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: onExpandToggle,
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                size: 24,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Tick when selected, grey circle when not
                Icon(
                  groupValue == value
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  size: 28,
                  color: groupValue == value
                      ? AppColors.primaryBlue
                      : Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
