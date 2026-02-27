import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/mobile_plan.dart';

/// Plan comparison bottom sheet before proceeding to payment.
class PlanComparisonBottomSheet extends StatelessWidget {
  final MobilePlan plan;
  final VoidCallback onProceed;

  const PlanComparisonBottomSheet({
    super.key,
    required this.plan,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            plan.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text('₹${plan.amount}'),
          if (plan.validity.isNotEmpty) Text('Validity: ${plan.validity}'),
          if (plan.dataAllowance.isNotEmpty) Text('Data: ${plan.dataAllowance}'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => onProceed(),
              child: const Text('Proceed to pay'),
            ),
          ),
        ],
      ),
    );
  }
}
