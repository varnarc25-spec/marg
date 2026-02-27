import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

/// Add credit card. TODO: Secure card tokenization via payment gateway.
class CreditCardAddPage extends ConsumerWidget {
  const CreditCardAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Add card'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const TextField(decoration: InputDecoration(labelText: 'Card number'), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Name on card')),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: TextField(decoration: InputDecoration(labelText: 'Expiry', hintText: 'MM/YY'), keyboardType: TextInputType.number)),
              const SizedBox(width: 16),
              Expanded(child: TextField(decoration: InputDecoration(labelText: 'CVV'), keyboardType: TextInputType.number, obscureText: true)),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TODO: Payment gateway tokenization')));
              Navigator.pop(context);
            },
            child: const Text('Save card'),
          ),
        ],
      ),
    );
  }
}
