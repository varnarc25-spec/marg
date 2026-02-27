import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/mobile_plan.dart';
import '../providers/mobile_recharge_provider.dart';
import '../widgets/mobile_plan_tile.dart';
import '../widgets/plan_comparison_bottom_sheet.dart';
import 'mobile_payment_confirmation_page.dart';

/// Plan list with tabs (Prepaid / Top-up / etc.) and best plan highlight.
class MobilePlanListPage extends ConsumerStatefulWidget {
  const MobilePlanListPage({super.key});

  @override
  ConsumerState<MobilePlanListPage> createState() => _MobilePlanListPageState();
}

class _MobilePlanListPageState extends ConsumerState<MobilePlanListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final operator = ref.watch(selectedMobileOperatorProvider);
    final number = ref.watch(mobileRechargeNumberProvider);
    final params = operator != null && number.isNotEmpty
        ? MobilePlansParams(operatorId: operator.id, number: number, type: 'prepaid')
        : null;
    final topupParams = operator != null && number.isNotEmpty
        ? MobilePlansParams(operatorId: operator.id, number: number, type: 'topup')
        : null;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Select plan'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Prepaid'),
            Tab(text: 'Top-up'),
          ],
        ),
      ),
      body: params == null
          ? const Center(child: Text('Select operator and number first'))
          : TabBarView(
              controller: _tabController,
              children: [
                _PlanList(params: params),
                _PlanList(params: topupParams!),
              ],
            ),
    );
  }
}

class _PlanList extends ConsumerWidget {
  final MobilePlansParams params;

  const _PlanList({required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(mobilePlansProvider(params));

    return plansAsync.when(
      data: (plans) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MobilePlanTile(
              plan: plan,
              onTap: () {
                ref.read(selectedMobilePlanProvider.notifier).state = plan;
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) => PlanComparisonBottomSheet(
                    plan: plan,
                    onProceed: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MobilePaymentConfirmationPage(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
