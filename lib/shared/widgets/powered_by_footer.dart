import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Reusable \"Powered by\" footer that can be placed at the bottom of pages.
class PoweredByFooter extends StatelessWidget {
  final String text;

  const PoweredByFooter({
    super.key,
    this.text = 'Powered by Marg Metals Partner',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        const Icon(Icons.verified_rounded, color: AppColors.textSecondary),
      ],
    );
  }
}

