part of 'mybudget_page.dart';

/// Dashboard tab content extracted into its own file.
class BudgetDashboardPage extends StatelessWidget {
  const BudgetDashboardPage({
    super.key,
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
    return _DashboardContent(
      monthLabel: monthLabel,
      summary: summary,
      incomeAmount: incomeAmount,
      formatCurrency: formatCurrency,
      formatAmount: formatAmount,
    );
  }
}

