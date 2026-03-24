import 'package:flutter/material.dart';

import '../providers/car_vehicle_provider.dart';

class CarHomeFindPlansSection extends StatelessWidget {
  const CarHomeFindPlansSection({
    super.key,
    required this.vehicleState,
    required this.onFindPlans,
  });

  final CarVehicleState vehicleState;
  final VoidCallback onFindPlans;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: vehicleState is CarVehicleLoading ? null : onFindPlans,
            child: const Text('Find Plans'),
          ),
        ),
        if (vehicleState is CarVehicleLoading) ...[
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
        if (vehicleState is CarVehicleError) ...[
          const SizedBox(height: 12),
          Text(
            (vehicleState as CarVehicleError).message,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
          ),
        ],
      ],
    );
  }
}
