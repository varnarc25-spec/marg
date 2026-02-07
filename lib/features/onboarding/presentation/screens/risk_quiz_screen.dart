import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/progress_indicator_widget.dart';
import '../../../../shared/widgets/app_icon_tile.dart';
import '../../../../shared/widgets/risk_profile_gauge.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'account_mode_screen.dart';

/// Risk Appetite Quiz Screen
/// 5 questions to assess user's risk tolerance — same layout as goal/experience screens
class RiskQuizScreen extends ConsumerStatefulWidget {
  const RiskQuizScreen({super.key});

  @override
  ConsumerState<RiskQuizScreen> createState() => _RiskQuizScreenState();
}

class _RiskQuizScreenState extends ConsumerState<RiskQuizScreen> {
  int currentQuestion = 0;
  final List<int> answers = List.filled(5, -1);

  static const int _numQuestions = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(l10nProvider);
    if (currentQuestion >= _numQuestions) {
      return _buildResultScreen(l10n);
    }

    final theme = Theme.of(context);
    final questionText = l10n.riskQuizQuestionAt(currentQuestion);
    final subtitle = l10n.riskQuizSubtitleAt(currentQuestion);
    final options = l10n.riskQuizOptionsAt(currentQuestion);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProgressIndicatorWidget(currentStep: 4, totalSteps: 6),
              const SizedBox(height: 24),
              const AppIconTile(icon: Icons.psychology_outlined, size: 64),
              const SizedBox(height: 20),
              Text(
                questionText,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              if (subtitle != null && subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              if (subtitle != null && subtitle.isNotEmpty)
                const SizedBox(height: 28)
              else
                const SizedBox(height: 28),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _OptionCard(
                        text: options[index],
                        isSelected: answers[currentQuestion] == index,
                        onTap: () {
                          setState(() {
                            answers[currentQuestion] = index;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: answers[currentQuestion] == -1
                      ? null
                      :                       () async {
                          if (currentQuestion == _numQuestions - 1) {
                            final totalScore =
                                answers.fold<int>(0, (sum, a) => sum + a);
                            String riskProfile;
                            if (totalScore <= 3) {
                              riskProfile = 'low';
                            } else if (totalScore <= 7) {
                              riskProfile = 'medium';
                            } else {
                              riskProfile = 'high';
                            }
                            await ref
                                .read(onboardingRiskProfileProvider.notifier)
                                .setRiskProfile(riskProfile);
                          }
                          setState(() {
                            if (currentQuestion < _numQuestions - 1) {
                              currentQuestion++;
                            } else {
                              currentQuestion++;
                            }
                          });
                        },
                  style: TextButton.styleFrom(
                    backgroundColor: answers[currentQuestion] != -1
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
                  child: Text(
                    currentQuestion < _numQuestions - 1 ? l10n.next : l10n.finish,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(AppLocalizations l10n) {
    int totalScore = answers.fold(0, (sum, answer) => sum + answer);
    String riskProfile;
    if (totalScore <= 3) {
      riskProfile = 'low';
    } else if (totalScore <= 7) {
      riskProfile = 'medium';
    } else {
      riskProfile = 'high';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProgressIndicatorWidget(currentStep: 5, totalSteps: 6),
              const SizedBox(height: 20),
              Text(
                l10n.yourRiskProfile,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Center(
                child: RiskProfileGauge(
                  riskProfile: riskProfile,
                  size: 240,
                  centerLabel: l10n.riskLabel,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      riskProfile.toUpperCase(),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: _getRiskColor(riskProfile),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.riskDescription(riskProfile),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AccountModeScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(l10n.continueLabel),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRiskColor(String risk) {
    switch (risk) {
      case 'low':
        return AppColors.riskLow;
      case 'medium':
        return AppColors.riskMedium;
      case 'high':
        return AppColors.riskHigh;
      default:
        return AppColors.textSecondary;
    }
  }

}

class _OptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.text,
    required this.isSelected,
    required this.onTap,
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _cardShadow,
            border: Border(
              left: BorderSide(
                color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                size: 28,
                color: isSelected
                    ? AppColors.primaryBlue
                    : Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
