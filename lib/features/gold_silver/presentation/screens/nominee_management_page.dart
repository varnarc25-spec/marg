import 'package:flutter/material.dart';
import 'gold_silver_common.dart';

class NomineeManagementPage extends StatelessWidget {
  const NomineeManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoldSilverFeaturePlaceholderPage(
      title: 'Nominee Management',
      subtitle: 'Add / update nominees for smooth transmission of assets.',
      icon: Icons.person_add_alt_1_rounded,
    );
  }
}

