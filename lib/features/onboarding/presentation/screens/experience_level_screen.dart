import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/progress_indicator_widget.dart';
import '../../../../shared/widgets/app_icon_tile.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'risk_quiz_screen.dart';

/// Experience Level Screen
/// Users select their trading experience — same layout as goal selection
class ExperienceLevelScreen extends ConsumerStatefulWidget {
  const ExperienceLevelScreen({super.key});

  @override
  ConsumerState<ExperienceLevelScreen> createState() =>
      _ExperienceLevelScreenState();
}

class _ExperienceLevelScreenState extends ConsumerState<ExperienceLevelScreen> {
  String? selectedExperience;
  int? expandedIndex;

  static List<Map<String, dynamic>> _levels(AppLocalizations l10n) => [
        {'id': 'new', 'title': l10n.experienceNew, 'description': l10n.experienceDescNew, 'icon': Icons.rocket_launch},
        {'id': 'intermediate', 'title': l10n.experienceIntermediate, 'description': l10n.experienceDescIntermediate, 'icon': Icons.trending_up},
        {'id': 'pro', 'title': l10n.experiencePro, 'description': l10n.experienceDescPro, 'icon': Icons.star},
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
              const ProgressIndicatorWidget(currentStep: 3, totalSteps: 6),
              const SizedBox(height: 24),
              const AppIconTile(icon: Icons.school_outlined, size: 64),
              const SizedBox(height: 20),
              Text(
                l10n.howExperienced,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.experienceGuidance,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.separated(
                  itemCount: _levels(l10n).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    final level = _levels(l10n)[index];
                    final isExpanded = expandedIndex == index;
                    return _ExperienceListTile(
                      value: level['id'] as String,
                      title: level['title'] as String,
                      description: level['description'] as String,
                      icon: level['icon'] as IconData,
                      groupValue: selectedExperience,
                      isExpanded: isExpanded,
                      onTap: () => setState(
                        () => selectedExperience = level['id'] as String,
                      ),
                      onExpandToggle: () => setState(() {
                        expandedIndex = isExpanded ? null : index;
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: selectedExperience == null
                      ? null
                      : () async {
                          if (selectedExperience != null) {
                            await ref
                                .read(onboardingExperienceProvider.notifier)
                                .setExperience(selectedExperience!);
                          }
                          if (!context.mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RiskQuizScreen(),
                            ),
                          );
                        },
                  style: TextButton.styleFrom(
                    backgroundColor: selectedExperience != null
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

class _ExperienceListTile extends StatelessWidget {
  final String value;
  final String title;
  final String description;
  final IconData icon;
  final String? groupValue;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onExpandToggle;

  const _ExperienceListTile({
    required this.value,
    required this.title,
    required this.description,
    required this.icon,
    required this.groupValue,
    required this.isExpanded,
    required this.onTap,
    required this.onExpandToggle,
  });

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
                AppIconTile(
                  icon: icon,
                  size: 40,
                  iconColor: Colors.white,
                  backgroundColor: AppColors.iconTileBackground,
                ),
                const SizedBox(width: 16),
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
