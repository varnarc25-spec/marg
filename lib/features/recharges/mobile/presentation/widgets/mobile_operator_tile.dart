import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/mobile_operator.dart';

class MobileOperatorTile extends StatelessWidget {
  final MobileOperator operator;
  final VoidCallback? onTap;

  const MobileOperatorTile({super.key, required this.operator, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryBlueLight,
          child: Text(
            operator.name.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        title: Text(operator.name),
        subtitle: Text(operator.circle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
