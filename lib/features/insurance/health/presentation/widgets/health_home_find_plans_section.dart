import 'package:flutter/material.dart';

class HealthHomeFindPlansSection extends StatelessWidget {
  const HealthHomeFindPlansSection({
    super.key,
    required this.onFindPlans,
    this.enabled = true,
  });

  final VoidCallback onFindPlans;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: enabled ? onFindPlans : null,
            child: const Text('Find Plans'),
          ),
        ),
      ],
    );
  }
}
