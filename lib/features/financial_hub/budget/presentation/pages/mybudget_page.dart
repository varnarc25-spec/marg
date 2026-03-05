// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/budget_data.dart';

/// Mybudget page: Dashboard or Monthly details content; floating nav (Dashboard, Monthly details, Chart, Settings).
/// Tapping a nav item switches content and updates only the selected icon/label; bar stays fixed.
class MybudgetPage extends StatefulWidget {
  const MybudgetPage({super.key});

  @override
  State<MybudgetPage> createState() => _MybudgetPageState();
}

class _MybudgetPageState extends State<MybudgetPage> {
  int _navIndex = 0;

  static String _formatCurrency(double value) {
    return 'Rs.${value.toStringAsFixed(2)}';
  }

  static String _formatAmount(double value) {
    return '₹${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.35,
      ),
      appBar: _navIndex == 1
          ? AppBar(
              title: Text(
                'Previous Months',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : _navIndex == 2
          ? AppBar(
              title: Text(
                'Analytics',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Mybudget',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.onSurface,
              elevation: 0,
            ),
      body: Stack(
        children: [
          IndexedStack(
            index: _navIndex,
            children: [
              _DashboardContent(
                formatCurrency: _formatCurrency,
                formatAmount: _formatAmount,
              ),
              _MonthlyDetailsContent(formatAmount: _formatAmount),
              _AnalyticsContent(formatAmount: _formatAmount),
              _PlaceholderContent(title: 'Settings'),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.paddingOf(context).bottom + 16,
            child: _FloatingNavBar(
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.formatCurrency,
    required this.formatAmount,
  });

  final String Function(double) formatCurrency;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const summary = defaultBudgetSummary;
    final transactions = defaultBudgetTransactions;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        24 + MediaQuery.paddingOf(context).bottom + 80,
      ),
      children: [
        _SummaryCard(
          summary: summary,
          colorScheme: colorScheme,
          textTheme: textTheme,
          formatCurrency: formatCurrency,
        ),
        const SizedBox(height: 24),
        Text(
          'Recent Transactions',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ...transactions.map(
          (t) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _TransactionCard(
              transaction: t,
              colorScheme: colorScheme,
              textTheme: textTheme,
              formatAmount: formatAmount,
            ),
          ),
        ),
      ],
    );
  }
}

/// Previous Months view: gradient card with Month, Budget, Expenses, Balance.
class _MonthlyDetailsContent extends StatelessWidget {
  const _MonthlyDetailsContent({required this.formatAmount});

  final String Function(double) formatAmount;

  static const _monthBudget = 50000.0;
  static const _monthExpenses = 8424.0;
  static double get _balance => _monthBudget - _monthExpenses;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        24 + MediaQuery.paddingOf(context).bottom + 80,
      ),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.iconTilePastelPurple,
                AppColors.accentOrange.withValues(alpha: 0.75),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Month',
                style: textTheme.titleSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '2026-02',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Budget',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formatAmount(_monthBudget),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expenses: ${formatAmount(_monthExpenses)}',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Balance: ${formatAmount(_balance)}',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Analytics tab: Month Card, Income Vs Expenses, Categories, Weekly Chart, Top Expenses.
/// Structure mirrors crypto wallet (ListView with sections and cards).
class _AnalyticsContent extends StatelessWidget {
  const _AnalyticsContent({required this.formatAmount});

  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    const monthCard = defaultAnalyticsMonthCard;
    const incomeVsExpenses = defaultIncomeVsExpenses;
    final categories = defaultAnalyticsCategories;
    final weeklyData = defaultWeeklyChartData;
    final topExpenses = defaultTopExpenses;
    final padding = EdgeInsets.fromLTRB(
      16,
      16,
      16,
      24 + MediaQuery.paddingOf(context).bottom + 80,
    );

    return ListView(
      padding: padding,
      children: [
        _AnalyticsMonthCardWidget(
          monthCard: monthCard,
          formatAmount: formatAmount,
        ),
        const SizedBox(height: 24),
        Text(
          'Income Vs Expenses',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _IncomeVsExpensesChart(incomeVsExpenses: incomeVsExpenses),
        const SizedBox(height: 24),
        Text(
          'Categories',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...categories.map(
          (c) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AnalyticsCategoryRow(
              category: c,
              formatAmount: formatAmount,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Weekly Chart',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _WeeklyChartCard(
          weeklyData: weeklyData,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 24),
        Text(
          'Top Expenses of the Month',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...topExpenses.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _TopExpenseCard(
              expense: e,
              formatAmount: formatAmount,
              textTheme: textTheme,
            ),
          ),
        ),
      ],
    );
  }
}

class _AnalyticsMonthCardWidget extends StatelessWidget {
  const _AnalyticsMonthCardWidget({
    required this.monthCard,
    required this.formatAmount,
  });

  final AnalyticsMonthCard monthCard;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.iconTilePastelBlue,
            const Color(0xFF26A69A),
            AppColors.iconTilePastelPurple,
            AppColors.iconTilePastelPurple.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Month Card',
            style: textTheme.titleSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.95),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            monthCard.month,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'My Budget : ${monthCard.budget.toStringAsFixed(0)}',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expenses : ${monthCard.expenses.toStringAsFixed(0)}',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                'Balance : ${monthCard.balance.toStringAsFixed(0)}',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IncomeVsExpensesChart extends StatelessWidget {
  const _IncomeVsExpensesChart({required this.incomeVsExpenses});

  final IncomeVsExpenses incomeVsExpenses;

  static const double _maxValue = 60000;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final incomeWidth = (incomeVsExpenses.income / _maxValue).clamp(0.0, 1.0);
    final expensesWidth = (incomeVsExpenses.expenses / _maxValue).clamp(
      0.0,
      1.0,
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentGreen.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 72,
                child: Text(
                  'Expenses',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: expensesWidth,
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 72,
                child: Text(
                  'Income',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: incomeWidth,
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '0',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(5, (i) {
                final v = (i + 1) * 10000;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    v >= 1000 ? '${v ~/ 1000}k' : '$v',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class FractionallySizedBox extends StatelessWidget {
  const FractionallySizedBox({
    super.key,
    required this.widthFactor,
    required this.child,
  });

  final double widthFactor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth * widthFactor;
        return SizedBox(width: w, child: child);
      },
    );
  }
}

class _AnalyticsCategoryRow extends StatelessWidget {
  const _AnalyticsCategoryRow({
    required this.category,
    required this.formatAmount,
  });

  final AnalyticsCategory category;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(category.icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.label,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            formatAmount(category.amount),
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyChartCard extends StatelessWidget {
  const _WeeklyChartCard({
    required this.weeklyData,
    required this.colorScheme,
    required this.textTheme,
  });

  final List<WeeklyChartDay> weeklyData;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final maxVal = weeklyData.fold<double>(
      0,
      (m, d) => d.value > m ? d.value : m,
    );
    final scale = maxVal > 0 ? 100.0 / maxVal : 1.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weeklyData.map((d) {
                final h = (d.value * scale).clamp(4.0, 120.0);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24,
                      height: h,
                      decoration: BoxDecoration(
                        color: d.value > 0
                            ? AppColors.primaryBlue
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      d.day,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopExpenseCard extends StatelessWidget {
  const _TopExpenseCard({
    required this.expense,
    required this.formatAmount,
    required this.textTheme,
  });

  final TopExpenseItem expense;
  final String Function(double) formatAmount;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.accentOrange.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(expense.icon, color: AppColors.textPrimary, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              expense.category,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            formatAmount(expense.amount),
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderContent extends StatelessWidget {
  const _PlaceholderContent({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 80 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.summary,
    required this.colorScheme,
    required this.textTheme,
    required this.formatCurrency,
  });

  final BudgetSummary summary;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final String Function(double) formatCurrency;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.iconTilePastelPurple,
            AppColors.accentGreen.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Total Amount',
            style: textTheme.titleSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.95),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formatCurrency(summary.totalAmount),
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expenses',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatCurrency(summary.expenses),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Budget',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatCurrency(summary.budget),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    required this.transaction,
    required this.colorScheme,
    required this.textTheme,
    required this.formatAmount,
  });

  final BudgetTransaction transaction;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                transaction.icon,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.dateTime,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              formatAmount(transaction.amount),
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.accentRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientFab extends StatelessWidget {
  const _GradientFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.iconTilePastelPurple, AppColors.primaryBlue],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(28),
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _FloatingNavButton(
              icon: Icons.dashboard_rounded,
              label: 'DashBoard',
              selected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _FloatingNavButton(
              icon: Icons.calendar_view_month_rounded,
              label: 'Monthly details',
              selected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _FloatingNavButton(
              icon: Icons.bar_chart_rounded,
              label: 'Analytic',
              selected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _FloatingNavButton(
              icon: Icons.settings_rounded,
              label: '',
              selected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingNavButton extends StatelessWidget {
  const _FloatingNavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 26,
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.7),
              ),
              if (label.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: selected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.7),
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
