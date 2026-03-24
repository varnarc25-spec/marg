import 'package:flutter/material.dart';

void showHealthHowItWorksBottomSheet(BuildContext context, String? body) {
  final theme = Theme.of(context);
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: SingleChildScrollView(
        child: Text(
          body?.trim().isNotEmpty == true
              ? body!
              : 'We match the best available price for your profile. If you find a lower eligible price elsewhere for the same plan, we\'ll help you with the difference as per applicable terms.',
          style: theme.textTheme.bodyLarge,
        ),
      ),
    ),
  );
}
