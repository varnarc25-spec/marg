import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/progress_indicator_widget.dart';
import '../../../../shared/providers/app_providers.dart';
import 'user_goal_selection_screen.dart';

/// Language Selection Screen
/// Users choose their preferred language
class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Language'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProgressIndicatorWidget(
                currentStep: 1,
                totalSteps: 6,
              ),
              const SizedBox(height: 48),
              Text(
                'Select your preferred language',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You can change this later in settings',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Expanded(
                child: ListView(
                  children: [
                    _LanguageCard(
                      language: 'English',
                      languageCode: 'en',
                      icon: Icons.language,
                      onTap: () => _onLanguageSelected(context, ref, 'en'),
                    ),
                    const SizedBox(height: 16),
                    _LanguageCard(
                      language: AppStrings.languageHindi,
                      languageCode: 'hi',
                      icon: Icons.language,
                      onTap: () => _onLanguageSelected(context, ref, 'hi'),
                    ),
                    const SizedBox(height: 16),
                    _LanguageCard(
                      language: AppStrings.languageTelugu,
                      languageCode: 'te',
                      icon: Icons.language,
                      onTap: () => _onLanguageSelected(context, ref, 'te'),
                    ),
                    const SizedBox(height: 16),
                    _LanguageCard(
                      language: AppStrings.languageTamil,
                      languageCode: 'ta',
                      icon: Icons.language,
                      onTap: () => _onLanguageSelected(context, ref, 'ta'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLanguageSelected(
    BuildContext context,
    WidgetRef ref,
    String languageCode,
  ) {
    ref.read(languageProvider.notifier).setLanguage(languageCode);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const UserGoalSelectionScreen(),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String language;
  final String languageCode;
  final IconData icon;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.language,
    required this.languageCode,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  language,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
