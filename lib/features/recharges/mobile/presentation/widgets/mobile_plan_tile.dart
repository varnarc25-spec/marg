import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/mobile_plan.dart';

class MobilePlanTile extends StatelessWidget {
  final MobilePlan plan;
  final VoidCallback? onTap;

  const MobilePlanTile({super.key, required this.plan, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: plan.isBestValue ? AppColors.primaryBlueLight.withValues(alpha: 0.15) : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Text(
              plan.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            if (plan.isBestValue) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Best value',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (plan.validity.isNotEmpty) Text('Validity: ${plan.validity}'),
            if (plan.dataAllowance.isNotEmpty) Text('Data: ${plan.dataAllowance}'),
            if (plan.talktime.isNotEmpty) Text('Talktime: ${plan.talktime}'),
          ],
        ),
        trailing: Text(
          '₹${plan.amount}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.primaryBlue,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
