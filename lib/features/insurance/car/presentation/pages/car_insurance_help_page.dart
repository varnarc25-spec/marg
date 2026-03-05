import 'package:flutter/material.dart';

/// Car Insurance help/info hub: list of topics and My Tickets button. Opened from app bar help icon.
class CarInsuranceHelpPage extends StatelessWidget {
  const CarInsuranceHelpPage({super.key});

  static const List<String> _helpItems = [
    'Common Car Insurance Terms',
    'Car Insurance Guide',
    'Buying Car Insurance on PhonePe',
    'Policy Document and mParivahan',
    'KYC and Inspection',
    'My Policies',
    'Ownership Transfer',
    'e-Insurance Account',
    'Support',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Car Insurance',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Material(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  showMenu<String>(
                    context: context,
                    position: const RelativeRect.fromLTRB(100, 80, 0, 0),
                    items: [
                      const PopupMenuItem(value: 'en', child: Text('English')),
                      const PopupMenuItem(value: 'hi', child: Text('हिंदी')),
                    ],
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'English',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: _helpItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final label = _helpItems[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('My Tickets'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
