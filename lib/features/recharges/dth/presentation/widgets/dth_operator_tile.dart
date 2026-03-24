import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/models/dth_operator.dart';

/// Operator row for lists (logo + name).
class DthOperatorTile extends StatelessWidget {
  const DthOperatorTile({super.key, required this.operator, this.onTap});

  final DthOperator operator;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final initial =
        operator.name.isNotEmpty ? operator.name.substring(0, 1).toUpperCase() : 'D';
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryBlueLight,
          child: operator.logoUrl != null && operator.logoUrl!.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    operator.logoUrl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
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
