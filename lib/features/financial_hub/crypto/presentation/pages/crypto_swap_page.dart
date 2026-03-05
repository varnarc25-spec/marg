import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import 'crypto_swap_success_page.dart';

/// Crypto swap page for the Exchange icon.
/// No app bar ? only a "Swap" title and swap cards.
class CryptoSwapPage extends StatelessWidget {
  const CryptoSwapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Swap'),
        backgroundColor: colorScheme.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Swap',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _SwapCard(
              title: 'You Pay',
              tokenSymbol: 'BNB',
              tokenName: 'BNB',
              balanceText: '52.34 BNB',
              amount: '0.01',
              amountHint: '= 6,247.70 USD',
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
            const SizedBox(height: 12),
            const _SwapToggleIcon(),
            const SizedBox(height: 12),
            _SwapCard(
              title: 'You Receive',
              tokenSymbol: 'USDT',
              tokenName: 'USDT',
              balanceText: '187 552 USDT',
              amount: '6.7345108344',
              amountHint: '= 28,197.64 USD',
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
            const SizedBox(height: 16),
            _FeeRow(textTheme: textTheme),
            const SizedBox(height: 24),
            _SlideToSwapBar(
              onCompleted: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CryptoSwapSuccessPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'powered by kima',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwapCard extends StatelessWidget {
  const _SwapCard({
    required this.title,
    required this.tokenSymbol,
    required this.tokenName,
    required this.balanceText,
    required this.amount,
    required this.amountHint,
    required this.colorScheme,
    required this.textTheme,
  });

  final String title;
  final String tokenSymbol;
  final String tokenName;
  final String balanceText;
  final String amount;
  final String amountHint;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                balanceText,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  tokenSymbol.substring(0, 1),
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        tokenName,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  Text(
                    tokenSymbol,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                amount,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              amountHint,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwapToggleIcon extends StatelessWidget {
  const _SwapToggleIcon();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.swap_vert_rounded, color: colorScheme.primary),
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  const _FeeRow({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Fee: 0.025851 USDT',
          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          '1 BNB = 673.45108 (198.98 USD)',
          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _SlideToSwapBar extends StatefulWidget {
  const _SlideToSwapBar({required this.onCompleted});

  final VoidCallback onCompleted;

  @override
  State<_SlideToSwapBar> createState() => _SlideToSwapBarState();
}

class _SlideToSwapBarState extends State<_SlideToSwapBar> {
  double _dragX = 0;
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        const knobSize = 46.0;
        const padding = 4.0;
        final maxDrag = constraints.maxWidth - knobSize - padding * 2;
        final knobOffset = _dragX.clamp(0, maxDrag);

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragX = (_dragX + details.delta.dx).clamp(0, maxDrag);
            });
          },
          onHorizontalDragEnd: (_) {
            if (_dragX > maxDrag * 0.7) {
              setState(() {
                _completed = true;
                _dragX = maxDrag;
              });
              Future.delayed(const Duration(milliseconds: 250), () {
                if (!mounted) return;
                widget.onCompleted();
                setState(() {
                  _completed = false;
                  _dragX = 0;
                });
              });
            } else {
              setState(() {
                _completed = false;
                _dragX = 0;
              });
            }
          },
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  _completed ? 'Swapping...' : 'Slide to Swap',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Positioned(
                  left: padding + knobOffset,
                  top: padding,
                  bottom: padding,
                  child: Container(
                    width: knobSize,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
