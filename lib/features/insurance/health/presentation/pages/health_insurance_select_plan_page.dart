import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/health_insurance_plan.dart';
import '../providers/health_insurance_provider.dart';
import 'health_insurance_review_page.dart';
import 'health_insurance_help_page.dart';

/// Select Plan page: selected members summary, health plan list. On Buy → Review.
class HealthInsuranceSelectPlanPage extends ConsumerWidget {
  const HealthInsuranceSelectPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final plansState = ref.watch(healthPlansProvider);
    final selectedMembers = ref.watch(healthSelectedMembersProvider);

    if (plansState is! HealthPlansSuccess) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Select Plan',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
        ),
                body: Center(
                  child: plansState is HealthPlansLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              plansState is HealthPlansError
                                  ? plansState.message
                                  : 'No plans available. Go back and try again.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Back'),
                    ),
                  ],
                ),
        ),
      );
    }

    final plans = plansState.plans;
    final membersLabel = selectedMembers.join(', ');

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Select Plan',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.help_outline_rounded,
              size: 24,
              color: colorScheme.onSurface,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const HealthInsuranceHelpPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.medical_services_rounded,
                size: 24,
                color: colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Covering',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      membersLabel,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                ),
                child: const Text('Modify'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Choose a plan',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...plans.map(
            (plan) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _HealthPlanCard(
                plan: plan,
                onBuyNow: () {
                  ref.read(selectedHealthPlanProvider.notifier).state = plan;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HealthInsuranceReviewPage(),
                    ),
                  );
                },
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Note: Prices are exclusive of GST. Premium may vary by age and sum insured.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _HealthPlanCard extends StatelessWidget {
  const _HealthPlanCard({
    required this.plan,
    required this.onBuyNow,
    required this.colorScheme,
    required this.textTheme,
  });

  final HealthInsurancePlan plan;
  final VoidCallback onBuyNow;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.insurerName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                if (plan.tag != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      plan.tag!,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Cover: ${plan.coverLakhs} Lakh',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${plan.priceMonthly}/month',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                FilledButton(
                  onPressed: onBuyNow,
                  child: const Text('Buy'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
