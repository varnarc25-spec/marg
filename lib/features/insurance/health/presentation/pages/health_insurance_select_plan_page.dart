import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:marg/features/insurance/health/data/models/health_network_hospital.dart';
import 'package:marg/shared/providers/app_providers.dart';

import '../../data/health_insurance_plan.dart';
import '../providers/health_insurance_provider.dart';
import 'health_insurance_review_page.dart';
import 'health_insurance_help_page.dart';

/// Cover chips → `coverAmount` in `POST /api/insurance/health/plans`.
const List<({String label, int amount})> kHealthCoverChipOptions = [
  (label: '₹1 Crore', amount: 10000000),
  (label: '₹50 Lakh', amount: 5000000),
  (label: '₹20 Lakh', amount: 2000000),
  (label: '₹10 Lakh', amount: 1000000),
];

/// Health Insurance Plans — layout aligned with design; wires APIs for cover, list, compare, proceed.
class HealthInsuranceSelectPlanPage extends ConsumerStatefulWidget {
  const HealthInsuranceSelectPlanPage({super.key});

  @override
  ConsumerState<HealthInsuranceSelectPlanPage> createState() =>
      _HealthInsuranceSelectPlanPageState();
}

class _HealthInsuranceSelectPlanPageState
    extends ConsumerState<HealthInsuranceSelectPlanPage> {
  int _selectedCoverAmount = kDefaultHealthCoverAmount;
  String? _selectedPlanId;
  bool _comparing = false;
  bool _pendingCoverRefetch = false;

  static final _currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  String _formatMonthly(int? rupees) {
    if (rupees == null) return '—';
    return '${_currency.format(rupees)}/month';
  }

  Future<void> _onCoverChipTap(int amount) async {
    if (amount == _selectedCoverAmount || _pendingCoverRefetch) return;
    setState(() {
      _selectedCoverAmount = amount;
      _pendingCoverRefetch = true;
    });
    final form = ref.read(healthDetailsFormProvider);
    final members = ref.read(healthSelectedMembersProvider);
    try {
      await ref.read(healthPlansProvider.notifier).refetchPlansForCoverAmount(
            memberTypes: members,
            form: form,
            coverAmount: amount,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not refresh plans: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _pendingCoverRefetch = false);
    }
  }

  Future<void> _runCompare(List<HealthInsurancePlan> plans) async {
    if (plans.length < 2) return;
    final first = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Compare — pick first plan'),
        children: plans
            .map(
              (p) => SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, p.id),
                child: Text(p.insurerName),
              ),
            )
            .toList(),
      ),
    );
    if (first == null || !mounted) return;
    final second = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Compare — pick second plan'),
        children: plans
            .where((p) => p.id != first)
            .map(
              (p) => SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, p.id),
                child: Text(p.insurerName),
              ),
            )
            .toList(),
      ),
    );
    if (second == null || !mounted) return;

    setState(() => _comparing = true);
    try {
      final api = ref.read(healthInsuranceApiServiceProvider);
      final auth = ref.read(firebaseAuthServiceProvider);
      final token = await auth.getIdToken();
      final form = ref.read(healthDetailsFormProvider);
      final members = ref.read(healthSelectedMembersProvider);
      final result = await api.comparePlans(
        {
          'planIds': [first, second],
          'age': form.resolveAgeForApi(members),
          'hasPreExistingDisease': form.preExistingDisease ?? false,
        },
        idToken: token,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Compare plans'),
          content: SingleChildScrollView(
            child: SelectableText(
              const JsonEncoder.withIndent('  ').convert(result),
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _comparing = false);
    }
  }

  Future<void> _showHospitals() async {
    final pin = ref.read(healthDetailsFormProvider).pincode.trim();
    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a valid pincode from the previous step.')),
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => _HospitalsSheet(pincode: pin),
    );
  }

  Future<void> _showPlanDetails(HealthInsurancePlan plan) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final api = ref.read(healthInsuranceApiServiceProvider);
      final auth = ref.read(firebaseAuthServiceProvider);
      final token = await auth.getIdToken();
      final detail = await api.getPlanDetails(plan.id, idToken: token);
      if (!mounted) return;
      Navigator.of(context).pop();
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(plan.insurerName),
          content: SingleChildScrollView(
            child: SelectableText(
              const JsonEncoder.withIndent('  ').convert(detail),
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _proceed(HealthInsurancePlan plan) async {
    ref.read(selectedHealthPlanProvider.notifier).state = plan;
    try {
      final api = ref.read(healthInsuranceApiServiceProvider);
      final auth = ref.read(firebaseAuthServiceProvider);
      final token = await auth.getIdToken();
      final members = ref.read(healthSelectedMembersProvider);
      await api.submitSelection(
        {
          'members': uiMembersToApiSlugs(members),
          'planId': plan.id,
        },
        idToken: token,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selection: $e')),
      );
      return;
    }
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const HealthInsuranceReviewPage(),
      ),
    );
  }

  List<String> _bulletLines(HealthInsurancePlan p) {
    final out = <String>[...p.highlights];
    if (p.claimSettlementRateLabel != null) {
      final c = p.claimSettlementRateLabel!;
      if (!out.any((x) => x.contains(c) || c.contains(x))) {
        out.add(c);
      }
    }
    if (out.isEmpty) {
      return [
        'Exclusive benefits on your plan',
        'Cashless network hospitals near you',
      ];
    }
    return out.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final plansState = ref.watch(healthPlansProvider);
    final selectedMembers = ref.watch(healthSelectedMembersProvider);
    final form = ref.watch(healthDetailsFormProvider);

    if (plansState is! HealthPlansSuccess) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Health Insurance Plans',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        plansState is HealthPlansError
                            ? plansState.message
                            : 'No plans available. Go back and try again.',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
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

    final memberCount = selectedMembers.length;
    final coveringLabel =
        '$memberCount member${memberCount == 1 ? '' : 's'}';
    final ageRange = healthAgeRangeLabel(form, selectedMembers);

    HealthInsurancePlan? selectedPlan;
    for (final p in plans) {
      if (p.id == _selectedPlanId) {
        selectedPlan = p;
        break;
      }
    }
    selectedPlan ??= plans.isNotEmpty ? plans.first : null;

    final bottomPremium = selectedPlan?.priceMonthly;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Health Insurance Plans',
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
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const HealthInsuranceHelpPage(),
                ),
              );
            },
            child: const Text('Help'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Covering',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                coveringLabel,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Age Range',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ageRange,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Change'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Select cover amount',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: kHealthCoverChipOptions.map((opt) {
                      final selected = _selectedCoverAmount == opt.amount;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Material(
                          color: selected
                              ? colorScheme.primary.withValues(alpha: 0.12)
                              : colorScheme.surfaceContainerHighest.withValues(
                                  alpha: 0.5,
                                ),
                          borderRadius: BorderRadius.circular(24),
                          child: InkWell(
                            onTap: _pendingCoverRefetch
                                ? null
                                : () => _onCoverChipTap(opt.amount),
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: selected
                                      ? colorScheme.primary
                                      : colorScheme.outline.withValues(alpha: 0.3),
                                  width: selected ? 2 : 1,
                                ),
                              ),
                              child: Text(
                                opt.label,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Select an insurer',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (_comparing)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      TextButton(
                        onPressed: plans.length >= 2 ? () => _runCompare(plans) : null,
                        child: const Text('Compare Plans'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                ...plans.map(
                  (plan) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _HealthPlanCard(
                      plan: plan,
                      groupValue: _selectedPlanId,
                      bulletLines: _bulletLines(plan),
                      premiumLabel: _formatMonthly(plan.priceMonthly),
                      onSelect: () => setState(() => _selectedPlanId = plan.id),
                      onHospitals: _showHospitals,
                      onViewDetails: () => _showPlanDetails(plan),
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Premium (incl. of GST) where shown from insurer quote.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Material(
            elevation: 8,
            color: colorScheme.surface,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Premium (incl. of GST)',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bottomPremium != null
                                ? '${_currency.format(bottomPremium)}/month'
                                : 'Premium on quote',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: selectedPlan == null
                          ? null
                          : () => _proceed(selectedPlan!),
                      child: const Text('Proceed'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const HealthInsuranceHelpPage(),
            ),
          );
        },
        icon: const Icon(Icons.phone_rounded),
        label: const Text('Help'),
      ),
    );
  }
}

class _HealthPlanCard extends StatelessWidget {
  const _HealthPlanCard({
    required this.plan,
    required this.groupValue,
    required this.bulletLines,
    required this.premiumLabel,
    required this.onSelect,
    required this.onHospitals,
    required this.onViewDetails,
    required this.colorScheme,
    required this.textTheme,
  });

  final HealthInsurancePlan plan;
  final String? groupValue;
  final List<String> bulletLines;
  final String premiumLabel;
  final VoidCallback onSelect;
  final VoidCallback onHospitals;
  final VoidCallback onViewDetails;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValue == plan.id;
    final border = isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.25);
    final bg = isSelected
        ? colorScheme.primary.withValues(alpha: 0.06)
        : colorScheme.surface;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: isSelected ? 2 : 1),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (plan.logoUrl != null && plan.logoUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          plan.logoUrl!,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.business_rounded,
                            size: 40,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.insurerName,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          premiumLabel,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onSelect,
                    icon: Icon(
                      isSelected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...bulletLines.map(
                (line) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          line,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onHospitals,
                      child: Text(
                        plan.hospitalCount != null
                            ? '${NumberFormat.decimalPattern('en_IN').format(plan.hospitalCount)} Hospitals >'
                            : 'Hospitals >',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onViewDetails,
                      child: const Text('View Plan Details >'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HospitalsSheet extends ConsumerStatefulWidget {
  const _HospitalsSheet({required this.pincode});

  final String pincode;

  @override
  ConsumerState<_HospitalsSheet> createState() => _HospitalsSheetState();
}

class _HospitalsSheetState extends ConsumerState<_HospitalsSheet> {
  bool _loading = true;
  String? _error;
  List<HealthNetworkHospital> _list = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    try {
      final api = ref.read(healthInsuranceApiServiceProvider);
      final auth = ref.read(firebaseAuthServiceProvider);
      final token = await auth.getIdToken();
      final list = await api.getNetworkHospitals(widget.pincode, idToken: token);
      if (!mounted) return;
      setState(() {
        _list = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(_error!, style: theme.textTheme.bodyMedium),
      );
    }
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: _list.length,
          itemBuilder: (context, i) {
            final h = _list[i];
            final name = h.name;
            final sub = [if (h.address != null) h.address, h.city]
                .whereType<String>()
                .where((s) => s.isNotEmpty)
                .join(' — ');
            return ListTile(
              title: Text(name),
              subtitle: sub.isEmpty ? null : Text(sub),
            );
          },
        );
      },
    );
  }
}
