import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/life_insurance_provider.dart';
import '../widgets/life_insurance_plans_actions.dart';
import 'life_insurance_help_page.dart';

/// Top term plans from `POST /api/insurance/life/plans`.
class LifeInsurancePlansPage extends ConsumerStatefulWidget {
  const LifeInsurancePlansPage({super.key});

  @override
  ConsumerState<LifeInsurancePlansPage> createState() =>
      _LifeInsurancePlansPageState();
}

class _LifeInsurancePlansPageState extends ConsumerState<LifeInsurancePlansPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final dob = ref.read(lifeDateOfBirthProvider);
    final incomeStr = ref.read(lifeAnnualIncomeProvider);
    final income = int.tryParse(incomeStr.replaceAll(RegExp(r'[,\s]'), ''));
    final lakhs = ref.read(lifeSelectedSumAssuredLakhsProvider);
    final coverTill = ref.read(lifeCoverTillAgeProvider);
    final gender = ref.read(lifeGenderProvider);
    final occupation = ref.read(lifeOccupationProvider);
    final education = ref.read(lifeEducationProvider);
    final tobacco = ref.read(lifeTobaccoConsumerProvider);
    final sortBy = ref.read(lifePlansSortByProvider);

    if (dob == null || income == null || income <= 0 || lakhs == null) {
      return;
    }

    await ref.read(lifePlansProvider.notifier).fetchTopPlans(
          dateOfBirth: dob,
          annualIncome: income,
          sumAssuredLakhs: lakhs,
          coverTillAge: coverTill,
          gender: gender,
          occupation: occupation,
          education: education,
          tobaccoConsumer: tobacco,
          sortBy: sortBy,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final state = ref.watch(lifePlansProvider);

    Widget body;
    if (state is LifePlansInitial || state is LifePlansLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (state is LifePlansError) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _load,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    } else if (state is LifePlansSuccess) {
      final plans = state.plans;
      body = Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Plans for your profile',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: plans.length >= 2
                      ? () => showLifePlansCompareDialog(context, ref, plans)
                      : null,
                  child: const Text('Compare'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: plans.length,
              itemBuilder: (context, i) {
                final p = plans[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: p.logoUrl != null && p.logoUrl!.isNotEmpty
                        ? Image.network(
                            p.logoUrl!,
                            width: 40,
                            height: 40,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.business_rounded),
                          )
                        : const Icon(Icons.business_rounded),
                    title: Text(p.insurerName),
                    subtitle: Text(
                      [
                        if (p.premiumMonthly != null)
                          '₹${p.premiumMonthly}/mo',
                        if (p.sumAssuredLakhs != null)
                          ' · ${p.sumAssuredLakhs} Lakh SA',
                      ].join(),
                    ),
                    trailing: TextButton(
                      onPressed: () =>
                          showLifePlanDetailsDialog(context, ref, p),
                      child: const Text('Details'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      body = const Center(child: Text('Loading…'));
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Top term plans',
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
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LifeInsuranceHelpPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: body,
    );
  }
}
