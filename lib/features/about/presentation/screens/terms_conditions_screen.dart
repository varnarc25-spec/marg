import 'package:flutter/material.dart';

/// Screen 130: Term & Condition
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  static const String lastUpdate = 'Last update: 12 October 2022';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Terms & Conditions'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
              ),
              child: Text(
                lastUpdate,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            const SizedBox(height: 24),
            _Section(
              title: 'Introduction',
              body: 'These General Terms and Conditions ("TC") govern your use of Financial Services. '
                  '"Financial Company" ("Financial") refers to the company providing Financial Services, '
                  'including the application, associated websites, API, and related services.',
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Usage Recommendation',
              body: 'Please read carefully the entire contents of this TC before using Financial Services. '
                  'By registering for an account, you declare that you have READ, UNDERSTOOD, COMPREHENDED, '
                  'OBSERVED, AGREED AND ACCEPTED all terms and conditions set out in this TC.',
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Changes & Revisions',
              body: 'Financial may upload, change, or replace this TC from time to time. The revised version '
                  'will take effect on the date of publication. It is your responsibility to review this TC '
                  'periodically. If you do not agree to any changes, you must immediately stop using Financial Services.',
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Risk Disclosure',
              body: 'Investing in financial products involves risk, including the possible loss of principal. '
                  'Past performance is not indicative of future results. You should only invest what you can '
                  'afford to lose and seek independent advice if necessary. Financial does not provide '
                  'investment advice.',
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Account and Eligibility',
              body: 'You must be at least 18 years old and meet eligibility requirements to use Financial Services. '
                  'You are responsible for maintaining the confidentiality of your account credentials and for '
                  'all activities that occur under your account.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
        ),
      ],
    );
  }
}
