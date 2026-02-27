import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

/// Add property, owner details, monthly rent. TODO: API to save.
class RentAddPropertyPage extends ConsumerWidget {
  const RentAddPropertyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Add property'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const TextField(decoration: InputDecoration(labelText: 'Property address')),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Owner name')),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Owner phone'), keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Monthly rent (₹)'), keyboardType: TextInputType.number),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TODO: Save via API')));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
