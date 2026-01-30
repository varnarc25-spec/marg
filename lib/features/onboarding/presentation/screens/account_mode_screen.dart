import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/progress_indicator_widget.dart';
import 'onboarding_success_screen.dart';

/// Account Mode Selection Screen
/// Users choose between Paper Trading (default) and Real Trading (locked)
class AccountModeScreen extends StatefulWidget {
  const AccountModeScreen({super.key});

  @override
  State<AccountModeScreen> createState() => _AccountModeScreenState();
}

class _AccountModeScreenState extends State<AccountModeScreen> {
  String? selectedMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Mode'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProgressIndicatorWidget(
                currentStep: 6,
                totalSteps: 6,
              ),
              const SizedBox(height: 48),
              Text(
                'Choose your trading mode',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You can switch later in settings',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Expanded(
                child: ListView(
                  children: [
                    _AccountModeCard(
                      title: AppStrings.accountPaper,
                      description: AppStrings.accountPaperDesc,
                      icon: Icons.school,
                      isSelected: selectedMode == 'paper',
                      isLocked: false,
                      onTap: () => setState(() => selectedMode = 'paper'),
                    ),
                    const SizedBox(height: 16),
                    _AccountModeCard(
                      title: AppStrings.accountReal,
                      description: AppStrings.accountRealDesc,
                      lockedDescription: AppStrings.accountRealLocked,
                      icon: Icons.account_balance,
                      isSelected: selectedMode == 'real',
                      isLocked: true,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Complete onboarding to unlock real trading'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: selectedMode == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const OnboardingSuccessScreen(),
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

class _AccountModeCard extends StatelessWidget {
  final String title;
  final String description;
  final String? lockedDescription;
  final IconData icon;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  const _AccountModeCard({
    required this.title,
    required this.description,
    this.lockedDescription,
    required this.icon,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      color: isLocked
          ? AppColors.textSecondary.withOpacity(0.1)
          : isSelected
              ? AppColors.primaryBlue.withOpacity(0.1)
              : AppColors.surfaceLight,
      child: InkWell(
        onTap: isLocked ? null : onTap,
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
                  color: isLocked
                      ? AppColors.textSecondary.withOpacity(0.2)
                      : isSelected
                          ? AppColors.primaryBlue
                          : AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isLocked ? Icons.lock : icon,
                  color: isLocked
                      ? AppColors.textSecondary
                      : isSelected
                          ? Colors.white
                          : AppColors.primaryBlue,
                  size: 28,
                ),
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
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isLocked
                                      ? AppColors.textSecondary
                                      : isSelected
                                          ? AppColors.primaryBlue
                                          : null,
                                ),
                          ),
                        ),
                        if (isLocked)
                          const Icon(
                            Icons.lock,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isLocked && lockedDescription != null
                          ? lockedDescription!
                          : description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isLocked
                                ? AppColors.textSecondary
                                : null,
                          ),
                    ),
                  ],
                ),
              ),
              if (isSelected && !isLocked)
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
