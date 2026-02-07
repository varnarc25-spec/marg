import 'package:flutter/material.dart';

/// Screen 129: Privacy & Policy
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
        title: const Text('Privacy Policy'),
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
              body: 'The protection and confidentiality of your personal information is very important to us. '
                  'This Privacy Policy describes how Financial Company and the Financial mobile application '
                  '(collectively, "Financial") collect, use, store, and protect your information.',
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Our Commitment',
              body: 'We are committed to collecting, using, storing, and protecting your personal information '
                  'in accordance with applicable data protection law. This policy applies to the applications, '
                  'websites, and related services offered by Financial.',
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Scope and Approval',
              body: 'By registering, accessing, or using the products, services, content, features, technology, '
                  'or functions of Financial Services, you accept this policy. We may change this policy from '
                  'time to time and will notify you of any material changes. It is your responsibility to '
                  'review this policy periodically.',
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Information We Collect',
              body: 'We collect information you provide directly to us, including account registration details, '
                  'identity verification documents, transaction history, and communications. We also collect '
                  'information automatically when you use our services, such as device information and usage data.',
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'How We Use Your Information',
              body: 'We use your information to provide, maintain, and improve our services; to process '
                  'transactions; to communicate with you; to comply with legal obligations; and to protect '
                  'the security and integrity of our platform.',
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
