import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/car_insurance_plan.dart';
import '../providers/car_vehicle_provider.dart';
import 'car_insurance_review_page.dart';
import 'car_insurance_help_page.dart';

/// Select Plan page: car details, Plan, IDV, Add-on (Personal Accident), plan list.
/// Prices update when Plan or Add-on changes. Matches screenshots.
class CarInsuranceSelectPlanPage extends ConsumerStatefulWidget {
  const CarInsuranceSelectPlanPage({super.key});

  @override
  ConsumerState<CarInsuranceSelectPlanPage> createState() =>
      _CarInsuranceSelectPlanPageState();
}

class _CarInsuranceSelectPlanPageState
    extends ConsumerState<CarInsuranceSelectPlanPage> {
  String _plan = 'Comprehensive';
  int? _selectedIdv; // null when Third Party; when Comprehensive use first plan's idv as default
  bool _personalAccident = false;

  static String _formatIdv(int idv) {
    if (idv >= 1000) {
      return '${idv ~/ 1000},${idv % 1000}';
    }
    return idv.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final vehicleState = ref.watch(carVehicleProvider);
    final vehicleNumber = ref.watch(carVehicleNumberProvider);

    if (vehicleState is! CarVehicleSuccess) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Vehicle details not found. Go back and enter car number.',
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

    final vehicle = vehicleState.vehicle;
    final plans = vehicleState.plans;
    final selectedCarName = ref.watch(selectedCarNameProvider);
    final carDisplay = vehicleNumber.isNotEmpty
        ? '${vehicleNumber.toUpperCase()} • ${selectedCarName ?? vehicle.model}'
        : (selectedCarName ?? vehicle.model);

    // Unique IDVs for Comprehensive dropdown (from plans)
    final idvOptions = plans.map((p) => p.idv).toSet().toList()..sort();
    final effectiveIdv = _plan == 'Third Party'
        ? null
        : (_selectedIdv ?? (idvOptions.isNotEmpty ? idvOptions.first : null));

    // Show all plans; prices depend on plan type and add-on
    final count = plans.length;
    final planTypeLabel = _plan == 'Third Party' ? 'Third Party' : 'Comprehensive';

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
                  builder: (_) => const CarInsuranceHelpPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            children: [
              const SizedBox(height: 16),
              // Vehicle row with car icon
              Row(
                children: [
                  Icon(
                    Icons.directions_car_rounded,
                    size: 24,
                    color: colorScheme.onSurface,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      carDisplay,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
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
              const SizedBox(height: 20),
              // Plan dropdown
              Row(
                children: [
                  Expanded(
                    child: _DropdownCard(
                      label: 'Plan',
                      value: _plan,
                      items: const ['Comprehensive', 'Third Party'],
                      onChanged: (v) {
                        setState(() {
                          _plan = v ?? _plan;
                          if (_plan == 'Third Party') _selectedIdv = null;
                          else if (_selectedIdv == null && idvOptions.isNotEmpty) {
                            _selectedIdv = idvOptions.first;
                          }
                        });
                      },
                      textTheme: textTheme,
                      colorScheme: colorScheme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _plan == 'Third Party'
                        ? _IdvNotApplicableCard(
                            textTheme: textTheme,
                            colorScheme: colorScheme,
                          )
                        : _DropdownCard(
                            label: 'IDV',
                            value: effectiveIdv != null
                                ? '₹${_formatIdv(effectiveIdv)}'
                                : (idvOptions.isNotEmpty
                                    ? '₹${_formatIdv(idvOptions.first)}'
                                    : ''),
                            items: idvOptions
                                .map((idv) => '₹${_formatIdv(idv)}')
                                .toList(),
                            onChanged: (v) {
                              if (v == null) return;
                              final idv = idvOptions.firstWhere(
                                    (idv) => '₹${_formatIdv(idv)}' == v,
                                    orElse: () => idvOptions.first,
                                  );
                              setState(() => _selectedIdv = idv);
                            },
                            textTheme: textTheme,
                            colorScheme: colorScheme,
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Add-on section
              Text(
                'Add-on',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () =>
                    setState(() => _personalAccident = !_personalAccident),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _personalAccident
                        ? colorScheme.secondary.withValues(alpha: 0.2)
                        : colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _personalAccident
                          ? colorScheme.secondary
                          : colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 22,
                        color: _personalAccident
                            ? colorScheme.secondary
                            : colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Personal Accident',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: _personalAccident
                              ? colorScheme.secondary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // All quotes loaded
              Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 20,
                    color: colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'All quotes loaded and sorted',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Section header
              Text(
                '$count $planTypeLabel plans available',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              if (_plan == 'Third Party') ...[
                const SizedBox(height: 4),
                Text(
                  'Covers damages caused to third party and not your vehicle',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              ...plans.map(
                (plan) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PlanCard(
                    plan: plan,
                    planType: _plan,
                    personalAccident: _personalAccident,
                    onBuyNow: () {
                      ref.read(selectedCarPlanProvider.notifier).state = plan;
                      ref
                          .read(selectedCarPlanTypeProvider.notifier)
                          .state = _plan;
                      ref
                          .read(selectedCarPersonalAccidentProvider.notifier)
                          .state = _personalAccident;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CarInsuranceReviewPage(),
                        ),
                      );
                    },
                    formatIdv: _formatIdv,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: colorScheme.primary,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View all plans',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Footer note: "Note:" in orange, rest default
              RichText(
                text: TextSpan(
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  children: [
                    TextSpan(
                      text: 'Note: ',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentOrange,
                      ),
                    ),
                    const TextSpan(text: 'Prices are exclusive of GST'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
          // Need Help FAB
          Positioned(
            right: 16,
            bottom: 24,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              color: colorScheme.primary,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.headset_mic_rounded,
                        color: colorScheme.onPrimary,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Need Help?',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdvNotApplicableCard extends StatelessWidget {
  const _IdvNotApplicableCard({
    required this.textTheme,
    required this.colorScheme,
  });

  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'IDV',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Not Applicable',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownCard extends StatelessWidget {
  const _DropdownCard({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.textTheme,
    required this.colorScheme,
  });

  final String label;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final effectiveValue =
        items.contains(value) ? value : (items.isNotEmpty ? items.first : '');
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: effectiveValue.isEmpty ? null : effectiveValue,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.onSurface,
                ),
                dropdownColor: colorScheme.surfaceContainerHighest,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
                items: items
                    .map(
                      (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.planType,
    required this.personalAccident,
    required this.onBuyNow,
    required this.formatIdv,
  });

  final CarInsurancePlan plan;
  final String planType;
  final bool personalAccident;
  final VoidCallback onBuyNow;
  final String Function(int) formatIdv;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final displayPrice = plan.effectivePrice(planType,
        personalAccident: personalAccident);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Placeholder for logo (circle with initial)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  plan.insurerName.isNotEmpty
                      ? plan.insurerName[0].toUpperCase()
                      : '?',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (plan.tag != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        plan.tag!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    plan.insurerName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (planType == 'Comprehensive') ...[
                    const SizedBox(height: 4),
                    Text(
                      'IDV: ₹${formatIdv(plan.idv)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: onBuyNow,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Buy Now',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      '₹$displayPrice',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
