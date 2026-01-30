import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/progress_indicator_widget.dart';
import 'experience_level_screen.dart';

/// User Goal Selection Screen
/// Users select their trading goal
class UserGoalSelectionScreen extends StatefulWidget {
  const UserGoalSelectionScreen({super.key});

  @override
  State<UserGoalSelectionScreen> createState() =>
      _UserGoalSelectionScreenState();
}

class _UserGoalSelectionScreenState extends State<UserGoalSelectionScreen> {
  String? selectedGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What\'s your goal?'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProgressIndicatorWidget(
                currentStep: 2,
                totalSteps: 6,
              ),
              const SizedBox(height: 48),
              Text(
                'Why are you here?',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'We\'ll personalize your experience',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Expanded(
                child: ListView(
                  children: [
                    _GoalCard(
                      title: AppStrings.goalBeginner,
                      description: AppStrings.goalBeginnerDesc,
                      icon: Icons.school,
                      isSelected: selectedGoal == 'beginner',
                      onTap: () => setState(() => selectedGoal = 'beginner'),
                    ),
                    const SizedBox(height: 16),
                    _GoalCard(
                      title: AppStrings.goalActive,
                      description: AppStrings.goalActiveDesc,
                      icon: Icons.trending_up,
                      isSelected: selectedGoal == 'active',
                      onTap: () => setState(() => selectedGoal = 'active'),
                    ),
                    const SizedBox(height: 16),
                    _GoalCard(
                      title: AppStrings.goalOptions,
                      description: AppStrings.goalOptionsDesc,
                      icon: Icons.show_chart,
                      isSelected: selectedGoal == 'options',
                      onTap: () => setState(() => selectedGoal = 'options'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: selectedGoal == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ExperienceLevelScreen(),
                          ),
                        );
                      },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      color: isSelected
          ? AppColors.primaryBlue.withOpacity(0.1)
          : AppColors.surfaceLight,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryBlue
                  : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : AppColors.primaryBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.primaryBlue
                                : null,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primaryBlue,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
