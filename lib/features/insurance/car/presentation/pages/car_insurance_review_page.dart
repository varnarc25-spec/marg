import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/car_vehicle_provider.dart';
import 'car_insurance_help_page.dart';

/// Review selected car plan and proceed to payment.
/// Same structure and widget style as bike insurance; uses theme colorScheme.
class CarInsuranceReviewPage extends ConsumerWidget {
  const CarInsuranceReviewPage({super.key});

  static String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final vehicleState = ref.watch(carVehicleProvider);
    final selectedPlan = ref.watch(selectedCarPlanProvider);

    if (selectedPlan == null ||
        vehicleState is! CarVehicleSuccess) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'Review and buy',
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
          child: Text(
            'No plan selected. Go back and select a plan.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final vehicle = vehicleState.vehicle;
    final planType = ref.watch(selectedCarPlanTypeProvider);
    final personalAccident = ref.watch(selectedCarPersonalAccidentProvider);
    final totalPrice = selectedPlan.effectivePrice(planType, personalAccident: personalAccident);

    final planLabel = planType == 'Third Party'
        ? '1 Year Third Party'
        : '1 Year Comprehensive';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Review and buy',
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        children: [
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedPlan.insurerName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    planLabel,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    planType == 'Third Party'
                        ? '₹$totalPrice/yr'
                        : 'IDV: ₹${_formatIdv(selectedPlan.idv)} • ₹$totalPrice/yr',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Car Details',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReviewDetailRow(
                    label: 'Owner',
                    value: vehicle.ownerName,
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _ReviewDetailRow(
                    label: 'Model',
                    value: vehicle.model,
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _ReviewDetailRow(
                    label: 'Registration Date',
                    value: _formatDate(vehicle.registrationDate),
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _ReviewDetailRow(
                    label: 'Insurance Expiry',
                    value: _formatDate(vehicle.insuranceExpiry),
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'By clicking on \'Buy Plan\', I do hereby confirm that I have read and understood the Product Features/Benefits/Exclusions and agree to T&C and allow the insurer to fetch and process CKYC details for performing KYC. I hereby confirm that the details provided are correct.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: colorScheme.primary,
                ),
                child: Text(
                  'Product Features/Benefits/Exclusions',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                ' and ',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
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
                child: Text(
                  'T&C',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹$totalPrice',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Inclusive of GST',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment would be processed here'),
                      ),
                    );
                  },
                  child: const Text('BUY PLAN'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatIdv(int idv) {
    if (idv >= 1000) {
      return '${idv ~/ 1000},${idv % 1000}';
    }
    return idv.toString();
  }
}

class _ReviewDetailRow extends StatelessWidget {
  const _ReviewDetailRow({
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
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
