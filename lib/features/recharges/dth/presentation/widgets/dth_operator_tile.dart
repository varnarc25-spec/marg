import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/dth_operator.dart';

/// Operator tile for DTH selection, matching [MobileOperatorTile] style.
class DthOperatorTile extends StatelessWidget {
  final DthOperator operator;
  final VoidCallback? onTap;

  const DthOperatorTile({super.key, required this.operator, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryBlueLight,
          child: Text(
            operator.name.isNotEmpty ? operator.name.substring(0, 1).toUpperCase() : 'D',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        title: Text(operator.name),
        subtitle: const Text('DTH'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
