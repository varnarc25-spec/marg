import 'package:flutter/material.dart';

import '../providers/bike_vehicle_provider.dart';

class BikeHomeFindPlansSection extends StatelessWidget {
  const BikeHomeFindPlansSection({
    super.key,
    required this.vehicleState,
    required this.onFindPlans,
  });

  final BikeVehicleState vehicleState;
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
            onPressed: vehicleState is BikeVehicleLoading ? null : onFindPlans,
            child: const Text('Find Plans'),
          ),
        ),
        if (vehicleState is BikeVehicleLoading) ...[
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
        if (vehicleState is BikeVehicleError) ...[
          const SizedBox(height: 12),
          Text(
            (vehicleState as BikeVehicleError).message,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
          ),
        ],
      ],
    );
  }
}
