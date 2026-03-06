part of 'mybudget_page.dart';

/// Monthly details tab content extracted into its own file.
class BudgetMonthlyDetailsPage extends StatelessWidget {
  const BudgetMonthlyDetailsPage({
    super.key,
    required this.monthLabel,
    required this.budgetAmount,
    required this.formatAmount,
  });

  final String monthLabel;
  final double budgetAmount;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    return _MonthlyDetailsContent(
      monthLabel: monthLabel,
      budgetAmount: budgetAmount,
      formatAmount: formatAmount,
    );
  }
}

