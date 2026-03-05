import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

/// Simple success screen shown after a swap completes.
class CryptoSwapSuccessPage extends StatelessWidget {
  const CryptoSwapSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _SuccessIcon(colorScheme: colorScheme),
                  const SizedBox(height: 20),
                  Text(
                    'Successful',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '18.93 SOL',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your assets are now in your Spot Account.',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.accentOrange,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Check Assets'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Trade with Hottest Crypto',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _TokenChip(label: 'BTC /USDT', color: Colors.orange),
                        _TokenChip(label: 'ETH /USDT', color: Colors.blue),
                        _TokenChip(label: 'BNB /USDT', color: Colors.amber),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Provide Feedback',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.chat_bubble_outline_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.accentGreen.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_circle_rounded,
        color: AppColors.accentGreen,
        size: 52,
      ),
    );
  }
}

class _TokenChip extends StatelessWidget {
  const _TokenChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

