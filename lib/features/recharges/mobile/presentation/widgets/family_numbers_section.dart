import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../providers/mobile_recharge_provider.dart';
import '../pages/mobile_plan_list_page.dart';

/// Family numbers section for quick recharge.
class FamilyNumbersSection extends ConsumerWidget {
  const FamilyNumbersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyNumbers = ref.watch(mobileFamilyNumbersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recharge for',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...familyNumbers.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.person_rounded),
                  title: Text(entry.label),
                  subtitle: Text(entry.number),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ref.read(mobileRechargeNumberProvider.notifier).state = entry.number;
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MobilePlanListPage()),
                    );
                  },
                ),
              ),
            )),
      ],
    );
  }
}
