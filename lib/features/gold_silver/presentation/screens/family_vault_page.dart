import 'package:flutter/material.dart';
import 'gold_silver_common.dart';

class FamilyVaultPage extends StatelessWidget {
  const FamilyVaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoldSilverFeaturePlaceholderPage(
      title: 'Family Vault',
      subtitle: 'Create a shared vault for family investments and goals.',
      icon: Icons.lock_rounded,
    );
  }
}

