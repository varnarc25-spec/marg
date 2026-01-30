import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/progress_indicator_widget.dart';
import 'account_mode_screen.dart';

/// Risk Appetite Quiz Screen
/// 5 questions to assess user's risk tolerance
class RiskQuizScreen extends StatefulWidget {
  const RiskQuizScreen({super.key});

  @override
  State<RiskQuizScreen> createState() => _RiskQuizScreenState();
}

class _RiskQuizScreenState extends State<RiskQuizScreen> {
  int currentQuestion = 0;
  final List<int> answers = List.filled(5, -1);

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'How do you react to market volatility?',
      'options': [
        'I stay calm and stick to my strategy',
        'I get slightly nervous but continue',
        'I panic and want to exit immediately',
      ],
    },
    {
      'question': 'What percentage of your portfolio are you willing to risk?',
      'options': [
        'Less than 5%',
        '5-15%',
        'More than 15%',
      ],
    },
    {
      'question': 'How long do you plan to hold your trades?',
      'options': [
        'Long-term (months/years)',
        'Medium-term (weeks)',
        'Short-term (days)',
      ],
    },
    {
      'question': 'What\'s your primary trading goal?',
      'options': [
        'Steady growth with low risk',
        'Balanced growth and risk',
        'Maximum returns, high risk',
      ],
    },
    {
      'question': 'How do you handle losses?',
      'options': [
        'I accept it as part of trading',
        'I review and learn from it',
        'I get emotional and make impulsive decisions',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (currentQuestion >= questions.length) {
      return _buildResultScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Risk Assessment (${currentQuestion + 1}/5)'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProgressIndicatorWidget(
                currentStep: 4,
                totalSteps: 6,
              ),
              const SizedBox(height: 48),
              Text(
                questions[currentQuestion]['question'] as String,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Expanded(
                child: ListView(
                  children: List.generate(
                    (questions[currentQuestion]['options'] as List).length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _OptionCard(
                        text: (questions[currentQuestion]['options']
                            as List)[index] as String,
                        isSelected: answers[currentQuestion] == index,
                        onTap: () {
                          setState(() {
                            answers[currentQuestion] = index;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: answers[currentQuestion] == -1
                    ? null
                    : () {
                        if (currentQuestion < questions.length - 1) {
                          setState(() {
                            currentQuestion++;
                          });
                        } else {
                          setState(() {
                            currentQuestion++;
                          });
                        }
                      },
                child: Text(
                  currentQuestion < questions.length - 1
                      ? 'Next'
                      : 'Finish',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    // Calculate risk profile based on answers
    // Simple scoring: 0 = low risk, 1 = medium, 2 = high risk
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
      appBar: AppBar(
        title: const Text('Risk Assessment Complete'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProgressIndicatorWidget(
                currentStep: 5,
                totalSteps: 6,
              ),
              const SizedBox(height: 48),
              Icon(
                Icons.check_circle,
                size: 80,
                color: AppColors.accentGreen,
              ),
              const SizedBox(height: 24),
              Text(
                'Your Risk Profile',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        riskProfile.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              color: _getRiskColor(riskProfile),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getRiskDescription(riskProfile),
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AccountModeScreen(),
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

  String _getRiskDescription(String risk) {
    switch (risk) {
      case 'low':
        return 'You prefer conservative strategies with lower risk. We\'ll suggest safer trading approaches.';
      case 'medium':
        return 'You\'re comfortable with balanced risk. We\'ll provide a mix of strategies.';
      case 'high':
        return 'You\'re willing to take higher risks for potential returns. We\'ll show advanced strategies.';
      default:
        return '';
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
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge,
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
