import 'package:flutter/material.dart';

/// Summary for the total balance card (income, expense, last month savings).
class SavingsSummary {
  final double totalBalance;
  final double income;
  final double expense;
  final double lastMonthSavings;

  const SavingsSummary({
    required this.totalBalance,
    required this.income,
    required this.expense,
    required this.lastMonthSavings,
  });
}

/// A single savings goal (e.g. New Bike, Home).
class SavingsGoal {
  final String title;
  final double targetAmount;
  final DateTime targetDate;
  final double progress; // 0.0 to 1.0
  final IconData icon;

  const SavingsGoal({
    required this.title,
    required this.targetAmount,
    required this.targetDate,
    required this.progress,
    required this.icon,
  });
}

// Default summary for My Savings page (using ₹ for app consistency).
const SavingsSummary defaultSavingsSummary = SavingsSummary(
  totalBalance: 2024.8,
  income: 5400,
  expense: 3543,
  lastMonthSavings: 520,
);

// Mock list of savings goals (not const because DateTime is not a compile-time constant).
final List<SavingsGoal> defaultSavingsGoals = [
  SavingsGoal(
    title: 'New Bike',
    targetAmount: 4550,
    targetDate: DateTime(2025, 1, 1),
    progress: 0.35,
    icon: Icons.two_wheeler_rounded,
  ),
  SavingsGoal(
    title: 'Home',
    targetAmount: 55000,
    targetDate: DateTime(2025, 2, 15),
    progress: 0.62,
    icon: Icons.home_rounded,
  ),
  SavingsGoal(
    title: 'Business Savings',
    targetAmount: 4550,
    targetDate: DateTime(2025, 3, 1),
    progress: 0.18,
    icon: Icons.business_center_rounded,
  ),
];
