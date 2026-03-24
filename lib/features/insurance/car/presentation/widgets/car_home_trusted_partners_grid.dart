import 'package:flutter/material.dart';

class CarHomeTrustedPartnersGrid extends StatelessWidget {
  const CarHomeTrustedPartnersGrid({super.key});

  static const _partners = <String>[
    'ACKO',
    'Bajaj General',
    'Generali',
    'The New India Assurance',
    'Oriental Insurance',
    'IndusInd General',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: _partners.map((name) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                name,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
