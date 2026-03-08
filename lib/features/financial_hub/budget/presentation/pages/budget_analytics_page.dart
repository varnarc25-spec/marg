part of 'mybudget_page.dart';

/// Analytics tab content extracted into its own file.
class BudgetAnalyticsPage extends StatelessWidget {
  const BudgetAnalyticsPage({
    super.key,
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
    return _AnalyticsContent(
      monthLabel: monthLabel,
      budgetAmount: budgetAmount,
      expenses: expenses,
      formatAmount: formatAmount,
    );
  }
}

