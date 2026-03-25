import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/bike_insurance_plan.dart';
import '../providers/bike_vehicle_provider.dart';
import 'bike_insurance_review_page.dart';
import 'bike_insurance_help_page.dart';

/// Select Plan page: bike details, Plan (Comprehensive/Own Damage), Duration or IDV, add-ons, plan list. Matches screenshots.
class BikeInsuranceSelectPlanPage extends ConsumerStatefulWidget {
  const BikeInsuranceSelectPlanPage({super.key});

  @override
  ConsumerState<BikeInsuranceSelectPlanPage> createState() =>
      _BikeInsuranceSelectPlanPageState();
}

class _BikeInsuranceSelectPlanPageState
    extends ConsumerState<BikeInsuranceSelectPlanPage> {
  String _plan = 'Comprehensive';
  String _duration = '1 Year';
  String _idv = 'Standard';
  bool _personalAccidentCover = true;
  bool _zeroDepreciation = false;

  static String _formatVehicleDate(DateTime? d) {
    if (d == null) return '—';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  static String _formatIdv(int idv) {
    if (idv >= 100000) {
      final lakh = idv ~/ 100000;
      final rest = idv % 100000;
      final thousand = rest ~/ 1000;
      final hundred = rest % 1000;
      if (thousand > 0 && hundred > 0) {
        return '$lakh,$thousand,$hundred';
      }
      if (thousand > 0) return '$lakh,$thousand';
      return '$lakh,$hundred';
    }
    if (idv >= 1000) {
      return '${idv ~/ 1000},${idv % 1000}';
    }
    return idv.toString();
  }

  int _effectivePrice(BikeInsurancePlan plan) {
    int p = plan.price;
    if (_plan == 'Comprehensive' && _personalAccidentCover) p += 500;
    if (_plan == 'Own Damage' && _zeroDepreciation) p += 400;
    return p;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final vehicleState = ref.watch(bikeVehicleProvider);
    final vehicleNumber = ref.watch(bikeVehicleNumberProvider);

    if (vehicleState is! BikeVehicleSuccess) {
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
                'Vehicle details not found. Go back and enter bike number.',
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
    final selectedBikeName = ref.watch(selectedBikeNameProvider);
    final bikeDisplay = vehicleNumber.isNotEmpty
        ? '${vehicleNumber.toUpperCase()} • ${selectedBikeName ?? vehicle.model}'
        : (selectedBikeName ?? vehicle.model);

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
                  builder: (_) => const BikeInsuranceHelpPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const SizedBox(height: 16),
          Text(
            'Bike Details',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  bikeDisplay,
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
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehicle details',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _VehicleDetailLine(
                    label: 'Registration',
                    value: vehicle.registrationNumber,
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _VehicleDetailLine(
                    label: 'Owner',
                    value: vehicle.ownerName,
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _VehicleDetailLine(
                    label: 'Model',
                    value: vehicle.model,
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _VehicleDetailLine(
                    label: 'Registered on',
                    value: _formatVehicleDate(vehicle.registrationDate),
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _VehicleDetailLine(
                    label: 'Insurance expires',
                    value: _formatVehicleDate(vehicle.insuranceExpiry),
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _DropdownCard(
                  label: 'Plan',
                  value: _plan,
                  items: const ['Comprehensive', 'Own Damage'],
                  onChanged: (v) => setState(() => _plan = v ?? _plan),
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _plan == 'Comprehensive'
                    ? _DropdownCard(
                        label: 'Duration',
                        value: _duration,
                        items: const ['1 Year', '2 Years', '3 Years'],
                        onChanged: (v) =>
                            setState(() => _duration = v ?? _duration),
                        textTheme: textTheme,
                        colorScheme: colorScheme,
                      )
                    : _DropdownCard(
                        label: 'IDV',
                        value: _idv,
                        items: const ['Minimum', 'Standard'],
                        onChanged: (v) => setState(() => _idv = v ?? _idv),
                        textTheme: textTheme,
                        colorScheme: colorScheme,
                      ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_plan == 'Comprehensive')
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            'Personal Accident Cover',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _personalAccidentCover,
                      onChanged: (v) =>
                          setState(() => _personalAccidentCover = v),
                    ),
                  ],
                ),
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.two_wheeler_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            'Add Zero Depreciation',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _zeroDepreciation,
                      onChanged: (v) =>
                          setState(() => _zeroDepreciation = v),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
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
          ...plans.map(
            (plan) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PlanCard(
                plan: plan,
                effectivePrice: _effectivePrice(plan),
                onBuyNow: () {
                  ref.read(selectedBikePlanProvider.notifier).state = plan;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const BikeInsuranceReviewPage(),
                    ),
                  );
                },
                formatIdv: _formatIdv,
              ),
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              children: [
                TextSpan(
                  text: 'Note:',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.accentOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' Prices are exclusive of GST'),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _VehicleDetailLine extends StatelessWidget {
  const _VehicleDetailLine({
    required this.label,
    required this.value,
    required this.textTheme,
    required this.colorScheme,
  });

  final String label;
  final String value;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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
                value: value,
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

class _PlanLogoFallback extends StatelessWidget {
  const _PlanLogoFallback({
    required this.initial,
    required this.colorScheme,
    required this.textTheme,
  });

  final String initial;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          initial,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.effectivePrice,
    required this.onBuyNow,
    required this.formatIdv,
  });

  final BikeInsurancePlan plan;
  final int effectivePrice;
  final VoidCallback onBuyNow;
  final String Function(int) formatIdv;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final initial = plan.insurerName.isNotEmpty
        ? plan.insurerName[0].toUpperCase()
        : '?';

    final logoUrl = plan.logoUrl;
    final logoWidget = logoUrl != null && logoUrl.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              logoUrl,
              width: 44,
              height: 44,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => _PlanLogoFallback(
                initial: initial,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          )
        : _PlanLogoFallback(
            initial: initial,
            colorScheme: colorScheme,
            textTheme: textTheme,
          );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            logoWidget,
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
                  const SizedBox(height: 4),
                  Text(
                    'IDV: ₹${formatIdv(plan.idv)}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: onBuyNow,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                minimumSize: const Size(90, 56),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Buy Now',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹$effectivePrice',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
