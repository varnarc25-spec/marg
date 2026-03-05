import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/my_savings_data.dart';
import '../../ai_assistant/presentation/pages/ai_assistant_page.dart';

/// My Savings page: total balance card, income/expense, goals list, Add new Savings.
/// Uses app theme; no bottom nav (uses existing app bar/back only).
class MySavingsPage extends StatelessWidget {
  const MySavingsPage({super.key});

  static String _formatCurrency(double value) {
    final intPart = value.floor();
    final decPart = value - intPart;
    if (intPart >= 1000) {
      final s = intPart.toString();
      final buf = StringBuffer();
      for (var i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      if (decPart > 0) buf.write(decPart.toStringAsFixed(1).substring(1));
      return '₹$buf';
    }
    if (decPart > 0) return '₹${value.toStringAsFixed(1)}';
    return '₹$intPart';
  }

  static String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month - 1]}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    const summary = defaultSavingsSummary;
    final goals = defaultSavingsGoals;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.3,
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Savings',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        titleSpacing: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Material(
              color: AppColors.iconTilePastelPurple,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () {},
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _TotalBalanceCard(
            summary: summary,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onBoostTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AiAssistantPage()),
              );
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My goals',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'See All',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...goals.map(
            (goal) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _GoalCard(
                goal: goal,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ),
          const SizedBox(height: 32),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_rounded, size: 22),
                  label: const Text('Add new Savings'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalBalanceCard extends StatelessWidget {
  const _TotalBalanceCard({
    required this.summary,
    required this.colorScheme,
    required this.textTheme,
    this.onBoostTap,
  });

  final SavingsSummary summary;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback? onBoostTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOTAL BALANCE',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              MySavingsPage._formatCurrency(summary.totalBalance),
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Income',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '+${MySavingsPage._formatCurrency(summary.income)}',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: colorScheme.outlineVariant,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expense',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '-${MySavingsPage._formatCurrency(summary.expense)}',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last month savings',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      MySavingsPage._formatCurrency(summary.lastMonthSavings),
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: 18,
                      color: AppColors.accentGreen,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Material(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: onBoostTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Boost savings with AI',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      Text(
                        'Analyze now',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 20,
                        color: colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.colorScheme,
    required this.textTheme,
  });

  final SavingsGoal goal;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final progressColor = goal.progress >= 0.5
        ? AppColors.accentGreen
        : AppColors.accentOrange;
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      MySavingsPage._formatCurrency(goal.targetAmount),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      MySavingsPage._formatDate(goal.targetDate),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(
                        value: goal.progress,
                        strokeWidth: 4,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor,
                        ),
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        goal.icon,
                        size: 24,
                        color: colorScheme.onSurfaceVariant,
                      ),
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
}
