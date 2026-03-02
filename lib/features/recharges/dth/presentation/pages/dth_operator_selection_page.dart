import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../providers/dth_recharge_provider.dart';
import '../widgets/dth_operator_tile.dart';
import 'dth_number_input_page.dart';

/// Operator selection screen for DTH recharge (mirrors [MobileOperatorSelectionPage]).
class DthOperatorSelectionPage extends ConsumerWidget {
  const DthOperatorSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dthOperatorsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('DTH Recharge'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: async.when(
        data: (list) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Select operator',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...list.map(
              (op) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DthOperatorTile(
                  operator: op,
                  onTap: () {
                    ref.read(selectedDthOperatorProvider.notifier).state = op;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DthNumberInputPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
