import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/subscription_model.dart';
import '../providers/subscriptions_provider.dart';
import 'subscriptions_renewals_page.dart';
import 'subscriptions_analytics_page.dart';
import 'subscriptions_insights_page.dart';

class SubscriptionsListPage extends ConsumerWidget {
  const SubscriptionsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(subscriptionsListProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Subscriptions'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: async.when(
        data: (list) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const Icon(Icons.upcoming_rounded),
              title: const Text('Upcoming renewals'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionsRenewalsPage())),
            ),
            ListTile(
              leading: const Icon(Icons.analytics_rounded),
              title: const Text('Monthly spend'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionsAnalyticsPage())),
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb_rounded),
              title: const Text('Insights'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionsInsightsPage())),
            ),
            const SizedBox(height: 16),
            const Text('Your subscriptions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...list.map((s) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.subscriptions_rounded),
                title: Text(s.name),
                subtitle: Text('₹${s.amount}/${s.cycle} • Renews ${s.nextRenewal.day}/${s.nextRenewal.month}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showPauseCancelSheet(context, s),
              ),
            )),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showPauseCancelSheet(BuildContext context, SubscriptionModel s) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(s.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.pause_rounded),
              title: const Text('Pause'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TODO: Pause API')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_rounded),
              title: const Text('Cancel'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TODO: Cancel API')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
