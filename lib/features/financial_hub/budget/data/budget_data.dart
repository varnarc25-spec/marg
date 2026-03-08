import 'package:flutter/material.dart';

/// Budget summary for the Mybudget dashboard card.
class BudgetSummary {
  final double totalAmount;
  final double expenses;
  final double budget;

  const BudgetSummary({
    required this.totalAmount,
    required this.expenses,
    required this.budget,
  });
}

/// A single recent transaction (expense entry).
class BudgetTransaction {
  final String title;
  final String dateTime;
  final double amount;
  final IconData icon;
  final String? note;
  final DateTime? date;

  const BudgetTransaction({
    required this.title,
    required this.dateTime,
    required this.amount,
    this.icon = Icons.restaurant_rounded,
    this.note,
    this.date,
  });
}

/// Single budget entry added from New income/expense sheets.
/// Positive amount = income, negative amount = expense.
class BudgetEntry {
  final String category;
  final double amount;
  final DateTime date;

  const BudgetEntry({
    required this.category,
    required this.amount,
    required this.date,
  });
}

/// Default summary for Mybudget page (Total Amount, Expenses, Budget).
const BudgetSummary defaultBudgetSummary = BudgetSummary(
  totalAmount: 0.0,
  expenses: 0.0,
  budget: 0.0,
);

/// Mock recent transactions.
final List<BudgetTransaction> defaultBudgetTransactions = [];

// --- Analytics ---

/// Analytics month card (Month, My Budget, Expenses, Balance).
class AnalyticsMonthCard {
  final String month;
  final double budget;
  final double expenses;
  final double balance;

  const AnalyticsMonthCard({
    required this.month,
    required this.budget,
    required this.expenses,
    required this.balance,
  });
}

/// Income vs expenses for bar chart.
class IncomeVsExpenses {
  final double income;
  final double expenses;

  const IncomeVsExpenses({required this.income, required this.expenses});
}

/// Single category row (e.g. Amount paid).
class AnalyticsCategory {
  final String label;
  final double amount;
  final IconData icon;

  const AnalyticsCategory({
    required this.label,
    required this.amount,
    this.icon = Icons.restaurant_rounded,
  });
}

/// Weekly chart value per day.
class WeeklyChartDay {
  final String day;
  final double value;

  const WeeklyChartDay({required this.day, required this.value});
}

/// Top expense item.
class TopExpenseItem {
  final String category;
  final double amount;
  final IconData icon;

  const TopExpenseItem({
    required this.category,
    required this.amount,
    this.icon = Icons.restaurant_rounded,
  });
}

const AnalyticsMonthCard defaultAnalyticsMonthCard = AnalyticsMonthCard(
  month: 'March',
  budget: 50000,
  expenses: 80,
  balance: 49920,
);

const IncomeVsExpenses defaultIncomeVsExpenses = IncomeVsExpenses(
  income: 50000,
  expenses: 80,
);

const List<AnalyticsCategory> defaultAnalyticsCategories = [
  AnalyticsCategory(
    label: 'Amount paid',
    amount: 80,
    icon: Icons.restaurant_rounded,
  ),
];

final List<WeeklyChartDay> defaultWeeklyChartData = [
  const WeeklyChartDay(day: 'Fri', value: 0),
  const WeeklyChartDay(day: 'Sat', value: 0),
  const WeeklyChartDay(day: 'Sun', value: 80),
  const WeeklyChartDay(day: 'Mon', value: 0),
  const WeeklyChartDay(day: 'Tue', value: 0),
  const WeeklyChartDay(day: 'Wed', value: 0),
  const WeeklyChartDay(day: 'Thu', value: 0),
];

final List<TopExpenseItem> defaultTopExpenses = [
  const TopExpenseItem(
    category: 'Category',
    amount: 80,
    icon: Icons.restaurant_rounded,
  ),
];
