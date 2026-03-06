// ignore_for_file: unused_element

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/budget_data.dart';
import 'new_expense_page.dart';
import 'new_income_page.dart';

part 'budget_dashboard_page.dart';
part 'budget_monthly_details_page.dart';
part 'budget_analytics_page.dart';
part 'budget_settings_page.dart';

/// Mybudget page: Dashboard or Monthly details content; floating nav (Dashboard, Monthly details, Chart, Settings).
/// Tapping a nav item switches content and updates only the selected icon/label; bar stays fixed.
class MybudgetPage extends StatefulWidget {
  const MybudgetPage({super.key});

  @override
  State<MybudgetPage> createState() => _MybudgetPageState();
}

class _MybudgetPageState extends State<MybudgetPage> {
  int _navIndex = 0;
  double _budgetAmount = 0;

  static String _formatCurrency(double value) {
    return 'Rs.${value.toStringAsFixed(2)}';
  }

  String _formatMonthYear(DateTime d) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[d.month - 1]} ${d.year}';
  }

  static String _formatAmount(double value) {
    return '₹${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final monthLabel = _formatMonthYear(DateTime.now());
    double dynamicExpenses = 0;
    double dynamicIncome = 0;
    for (final t in defaultBudgetTransactions) {
      if (t.amount < 0) {
        dynamicExpenses += -t.amount;
      } else {
        dynamicIncome += t.amount;
      }
    }
    final dynamicBudget = _budgetAmount + dynamicIncome;
    final dynamicTotalAmount = dynamicBudget - dynamicExpenses;
    final summary = BudgetSummary(
      totalAmount: dynamicTotalAmount,
      expenses: dynamicExpenses,
      budget: dynamicBudget,
    );

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.35,
      ),
      appBar: _buildAppBar(theme, colorScheme, textTheme),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _navIndex,
              children: [
                BudgetDashboardPage(
                  monthLabel: monthLabel,
                  summary: summary,
                  incomeAmount: dynamicIncome,
                  formatCurrency: _formatCurrency,
                  formatAmount: _formatAmount,
                ),
                BudgetMonthlyDetailsPage(
                  monthLabel: monthLabel,
                  budgetAmount: _budgetAmount,
                  formatAmount: _formatAmount,
                ),
                BudgetAnalyticsPage(
                  monthLabel: monthLabel,
                  budgetAmount: dynamicBudget,
                  expenses: dynamicExpenses,
                  formatAmount: _formatAmount,
                ),
                const BudgetSettingsPage(),
              ],
            ),
          ),
          if (_navIndex == 0)
            _BudgetBottomButtons(
              onExpense: () async {
                await showNewExpenseSheet(context);
                setState(() {});
              },
              onIncome: () async {
                await showNewIncomeSheet(context);
                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isWhiteAppBar = _navIndex == 1 || _navIndex == 2;
    final title = _navIndex == 1
        ? 'Previous Months'
        : _navIndex == 2
        ? 'Analytics'
        : 'Mybudget';
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isWhiteAppBar ? Colors.white : colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
      backgroundColor: isWhiteAppBar
          ? AppColors.primaryBlue
          : colorScheme.surface,
      foregroundColor: isWhiteAppBar ? Colors.white : colorScheme.onSurface,
      elevation: 0,
      actions: [
        PopupMenuButton<int>(
          icon: Icon(
            Icons.more_vert_rounded,
            color: isWhiteAppBar ? Colors.white : colorScheme.onSurface,
          ),
          onSelected: (value) => setState(() => _navIndex = value),
          itemBuilder: (context) => [
            const PopupMenuItem<int>(
              value: 0,
              child: ListTile(
                leading: Icon(Icons.dashboard_rounded),
                title: Text('Dashboard'),
              ),
            ),
            const PopupMenuItem<int>(
              value: 1,
              child: ListTile(
                leading: Icon(Icons.calendar_view_month_rounded),
                title: Text('Monthly details'),
              ),
            ),
            const PopupMenuItem<int>(
              value: 2,
              child: ListTile(
                leading: Icon(Icons.bar_chart_rounded),
                title: Text('Analytics'),
              ),
            ),
            const PopupMenuItem<int>(
              value: 3,
              child: ListTile(
                leading: Icon(Icons.settings_rounded),
                title: Text('Settings'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Two flexible buttons at the bottom, side by side: EXPENSE (red) and INCOME (green).
class _BudgetBottomButtons extends StatelessWidget {
  const _BudgetBottomButtons({required this.onExpense, required this.onIncome});

  final VoidCallback onExpense;
  final VoidCallback onIncome;

  static const _red = Color(0xFFE53935);
  static const _green = Color(0xFF43A047);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: _OutlinedActionButton(
                label: 'EXPENSE',
                color: _red,
                onPressed: onExpense,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OutlinedActionButton(
                label: 'INCOME',
                color: _green,
                onPressed: onIncome,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  const _OutlinedActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: color, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.monthLabel,
    required this.summary,
    required this.incomeAmount,
    required this.formatCurrency,
    required this.formatAmount,
  });

  final String monthLabel;
  final BudgetSummary summary;
  final double incomeAmount;
  final String Function(double) formatCurrency;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transactions = defaultBudgetTransactions;
    final Map<String, List<BudgetTransaction>> grouped = {};
    for (final t in transactions) {
      grouped.putIfAbsent(t.title, () => []).add(t);
    }
    final groups = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        24 + 72 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        _SummaryCard(
          monthLabel: monthLabel,
          summary: summary,
          incomeAmount: incomeAmount,
          colorScheme: colorScheme,
          textTheme: textTheme,
          formatCurrency: formatCurrency,
        ),
        const SizedBox(height: 24),
        Text(
          'Categories',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ...groups.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _CategoryGroupCard(
              category: entry.key,
              transactions: entry.value,
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
  const _MonthlyDetailsContent({
    required this.monthLabel,
    required this.budgetAmount,
    required this.formatAmount,
  });

  final String monthLabel;
  final double budgetAmount;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Group transactions by month (year+month), skipping the current month.
    final txns =
        defaultBudgetTransactions.where((t) => t.date != null).toList();
    final Map<DateTime, List<BudgetTransaction>> monthGroups = {};
    for (final t in txns) {
      final d = t.date!;
      final key = DateTime(d.year, d.month);
      monthGroups.putIfAbsent(key, () => []).add(t);
    }
    final now = DateTime.now();
    final currentMonthKey = DateTime(now.year, now.month);
    final entries = monthGroups.entries
        .where((e) => e.key.isBefore(currentMonthKey))
        .toList()
      ..sort((a, b) => b.key.compareTo(a.key)); // latest past month first

    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        24 + 72 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        if (entries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'No monthly data yet.\nAdd income or expenses to see monthly cards here.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...entries.map((entry) {
            final monthDate = entry.key;
            final list = entry.value;
            double income = 0;
            double expenses = 0;
            for (final t in list) {
              if (t.amount >= 0) {
                income += t.amount;
              } else {
                expenses += -t.amount;
              }
            }
            final balance = income - expenses;
            final label = _formatMonthLabel(monthDate);

            // Group by category inside this month.
            final Map<String, List<BudgetTransaction>> byCategory = {};
            for (final t in list) {
              byCategory.putIfAbsent(t.title, () => []).add(t);
            }
            final catEntries = byCategory.entries.toList()
              ..sort((a, b) => a.key.compareTo(b.key));

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Income: ${formatAmount(income)}',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.accentGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Expenses: ${formatAmount(expenses)}',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.accentRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Balance: ${formatAmount(balance)}',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  children: [
                    const SizedBox(height: 8),
                    ...catEntries.map(
                      (cat) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _CategoryGroupCard(
                          category: cat.key,
                          transactions: cat.value,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                          formatAmount: formatAmount,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  String _formatMonthLabel(DateTime d) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[d.month - 1]} ${d.year}';
  }
}

/// Analytics tab: Month Card, Income Vs Expenses, Categories, Weekly Chart, Top Expenses.
/// Structure mirrors crypto wallet (ListView with sections and cards).
class _AnalyticsContent extends StatelessWidget {
  const _AnalyticsContent({
    required this.monthLabel,
    required this.budgetAmount,
    required this.expenses,
    required this.formatAmount,
  });

  final String monthLabel;
  final double budgetAmount;
  final double expenses;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final monthCard = AnalyticsMonthCard(
      month: monthLabel,
      budget: budgetAmount,
      expenses: expenses,
      balance: budgetAmount - expenses,
    );
    final incomeVsExpenses = IncomeVsExpenses(
      income: budgetAmount,
      expenses: expenses,
    );
    final weeklyData = _buildWeeklyExpenses();
    final padding = EdgeInsets.fromLTRB(
      16,
      16,
      16,
      24 + 72 + MediaQuery.paddingOf(context).bottom,
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
          'My Budget vs Expenses',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _IncomeVsExpensesChart(incomeVsExpenses: incomeVsExpenses),
        const SizedBox(height: 24),
        _ExpensesPieChartSection(
          budgetAmount: budgetAmount,
          expenses: expenses,
          colorScheme: colorScheme,
          textTheme: textTheme,
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
      ],
    );
  }

  /// Build weekly chart data from current transactions (daily expenses for this week).
  List<WeeklyChartDay> _buildWeeklyExpenses() {
    final now = DateTime.now();
    // Sliding window: last 7 days including today.
    final startDay = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));
    final days = <WeeklyChartDay>[];

    for (int i = 0; i < 7; i++) {
      final day = startDay.add(Duration(days: i));
      final totalForDay = defaultBudgetTransactions
          .where((t) {
            if (t.date == null || t.amount >= 0) return false;
            final d = t.date!;
            return d.year == day.year &&
                d.month == day.month &&
                d.day == day.day;
          })
          .fold<double>(0, (sum, t) => sum + (-t.amount));

      final label = '${day.day} ${_shortMonthLabel(day.month)}';
      days.add(WeeklyChartDay(day: label, value: totalForDay));
    }

    return days;
  }

  String _shortMonthLabel(int month) {
    const labels = [
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
    return labels[month - 1];
  }
}

class _CategorySlice {
  const _CategorySlice({
    required this.name,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String name;
  final double amount;
  final IconData icon;
  final Color color;
}

class _ExpensesPieChartSection extends StatelessWidget {
  const _ExpensesPieChartSection({
    required this.budgetAmount,
    required this.expenses,
    required this.colorScheme,
    required this.textTheme,
  });

  final double budgetAmount;
  final double expenses;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    if (budgetAmount <= 0 && expenses <= 0) {
      return const SizedBox.shrink();
    }
    if (expenses <= 0) {
      // No expenses -> nothing meaningful to show in category pie.
      return const SizedBox.shrink();
    }

    final slices = _buildExpenseSlices(colorScheme);
    if (slices.isEmpty) return const SizedBox.shrink();

    final total = slices.fold<double>(0, (sum, s) => sum + s.amount);

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
            height: 200,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: slices.map((s) {
                      final percent = total > 0
                          ? (s.amount / total) * 100.0
                          : 0.0;
                      return PieChartSectionData(
                        value: s.amount,
                        color: s.color,
                        radius: 40,
                        showTitle: percent >= 8,
                        title:
                            '${percent.toStringAsFixed(0)}%', // only on bigger slices
                        titleStyle: textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₹${budgetAmount.toStringAsFixed(2)}',
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.accentGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${expenses.toStringAsFixed(2)}',
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.accentRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: slices.map((s) {
              final percent = total > 0 ? (s.amount / total) * 100.0 : 0.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: s.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(s.icon, size: 18, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.name,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      '${percent.toStringAsFixed(1)}%',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<_CategorySlice> _buildExpenseSlices(ColorScheme colorScheme) {
    final Map<String, _CategorySlice> byCategory = {};
    final palette = <Color>[
      AppColors.primaryBlue,
      AppColors.accentRed,
      AppColors.accentOrange,
      colorScheme.secondary,
      AppColors.iconTilePastelPurple,
      AppColors.iconTilePastelBlue,
    ];
    int colorIndex = 0;

    for (final t in defaultBudgetTransactions) {
      if (t.amount >= 0) continue; // only expenses
      final key = t.title;
      final amountAbs = -t.amount;
      final existing = byCategory[key];
      if (existing == null) {
        final color = palette[colorIndex % palette.length];
        colorIndex++;
        byCategory[key] = _CategorySlice(
          name: key,
          amount: amountAbs,
          icon: t.icon,
          color: color,
        );
      } else {
        byCategory[key] = _CategorySlice(
          name: existing.name,
          amount: existing.amount + amountAbs,
          icon: existing.icon,
          color: existing.color,
        );
      }
    }

    final slices = byCategory.values.toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    return slices;
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // If both budget (treated as income) and expenses are zero, hide the chart.
    if (incomeVsExpenses.income == 0 && incomeVsExpenses.expenses == 0) {
      return const SizedBox.shrink();
    }

    final maxRaw = incomeVsExpenses.income > incomeVsExpenses.expenses
        ? incomeVsExpenses.income
        : incomeVsExpenses.expenses;
    final maxValue = maxRaw <= 0 ? 1.0 : maxRaw;
    final incomeWidth = (incomeVsExpenses.income / maxValue).clamp(0.0, 1.0);
    final expensesWidth = (incomeVsExpenses.expenses / maxValue).clamp(
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
                  'Budget',
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
                      color: AppColors.primaryBlue.withValues(alpha: 0.85),
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
                      color: AppColors.accentRed.withValues(alpha: 0.7),
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Budget',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${incomeVsExpenses.income.toStringAsFixed(2)}',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Expenses',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${incomeVsExpenses.expenses.toStringAsFixed(2)}',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentRed,
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
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weeklyData.map((d) {
                final h = (d.value * scale).clamp(4.0, 120.0);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      d.value > 0 ? '₹${d.value.toStringAsFixed(0)}' : '',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
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
    required this.monthLabel,
    required this.summary,
    required this.incomeAmount,
    required this.colorScheme,
    required this.textTheme,
    required this.formatCurrency,
  });

  final String monthLabel;
  final BudgetSummary summary;
  final double incomeAmount;
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
            monthLabel,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
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
                    'Income',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatCurrency(incomeAmount),
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
    final isIncome = transaction.amount >= 0;
    final displayAmount = transaction.amount.abs();
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
              formatAmount(displayAmount),
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isIncome ? AppColors.accentGreen : AppColors.accentRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grouped view of all transactions for a single category.
class _CategoryGroupCard extends StatelessWidget {
  const _CategoryGroupCard({
    required this.category,
    required this.transactions,
    required this.colorScheme,
    required this.textTheme,
    required this.formatAmount,
  });

  final String category;
  final List<BudgetTransaction> transactions;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) return const SizedBox.shrink();
    final icon = transactions.first.icon;
    final total = transactions.fold<double>(0, (sum, t) => sum + t.amount);
    final isIncome = total >= 0;
    final displayTotal = total.abs();
    final count = transactions.length;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.textSecondary, size: 24),
          ),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          category,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '$count',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.accentGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatAmount(displayTotal),
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isIncome ? AppColors.accentGreen : AppColors.accentRed,
                ),
              ),
            ],
          ),
          children: transactions.map((t) {
            final isIncomeTx = t.amount >= 0;
            final amountAbs = t.amount.abs();
            final noteOrDate = (t.note != null && t.note!.isNotEmpty)
                ? t.note!
                : t.dateTime;
            final dateLabel = t.dateTime;

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isIncomeTx
                          ? AppColors.accentGreen
                          : AppColors.accentRed,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          noteOrDate,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dateLabel,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatAmount(amountAbs),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isIncomeTx
                          ? AppColors.accentGreen
                          : AppColors.accentRed,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
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
