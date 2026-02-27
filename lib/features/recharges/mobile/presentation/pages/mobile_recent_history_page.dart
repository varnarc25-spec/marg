import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/mobile_operator.dart';
import '../../data/models/mobile_recharge_history_item.dart';
import '../providers/mobile_recharge_provider.dart';
import 'mobile_plan_list_page.dart';

const Color _mobileRechargePurple = Color(0xFF6B2D91);

/// Full-screen list of all mobile recharge recent transactions.
class MobileRecentHistoryPage extends ConsumerWidget {
  const MobileRecentHistoryPage({super.key});

  static String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(mobileHistoryProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Recent Recharges'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: async.when(
        data: (items) => items.isEmpty
            ? const Center(
                child: Text(
                  'No recent recharges',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _RecentTile(
                    item: item,
                    formatDate: _formatDate,
                    onTap: () {
                      ref.read(mobileRechargeNumberProvider.notifier).state =
                          item.number;
                      ref.read(selectedMobileOperatorProvider.notifier).state =
                          MobileOperator(
                        id: item.operatorName.toLowerCase().replaceAll(' ', '_'),
                        name: item.operatorName,
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MobilePlanListPage(),
                        ),
                      );
                    },
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: AppColors.textSecondary)),
        ),
      ),
    );
  }
}

class _RecentTile extends StatelessWidget {
  final MobileRechargeHistoryItem item;
  final String Function(DateTime) formatDate;
  final VoidCallback onTap;

  const _RecentTile({
    required this.item,
    required this.formatDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: _mobileRechargePurple.withValues(alpha: 0.12),
              child: Text(
                item.avatarText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _mobileRechargePurple,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.displayName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.number,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Last Recharge: ₹${item.amount.toInt()} on ${formatDate(item.date)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: AppColors.textSecondary,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
