import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/mobile_operator.dart';
import '../providers/mobile_recharge_provider.dart';
import '../widgets/mobile_operator_tile.dart';
import 'mobile_number_input_page.dart';

/// Operator selection screen for mobile recharge.
/// TODO: Use BBPS operator list when API is integrated.
class MobileOperatorSelectionPage extends ConsumerWidget {
  const MobileOperatorSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operatorsAsync = ref.watch(mobileOperatorsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Mobile Recharge'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: operatorsAsync.when(
        data: (operators) => ListView(
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
            ...operators.map((op) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MobileOperatorTile(
                    operator: op,
                    onTap: () {
                      ref.read(selectedMobileOperatorProvider.notifier).state = op;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MobileNumberInputPage(),
                        ),
                      );
                    },
                  ),
                )),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
