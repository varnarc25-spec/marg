import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/fastag_provider.dart';

class FastagRechargePage extends ConsumerStatefulWidget {
  const FastagRechargePage({super.key});

  @override
  ConsumerState<FastagRechargePage> createState() => _FastagRechargePageState();
}

class _FastagRechargePageState extends ConsumerState<FastagRechargePage> {
  final _amountController = TextEditingController();
  static const _presets = [100, 250, 500, 1000, 2000];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = ref.watch(selectedFastagVehicleProvider);
    if (v == null) return const Scaffold(body: Center(child: Text('Select vehicle')));

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Recharge FASTag'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Quick amount'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _presets.map((a) => ActionChip(
              label: Text('₹$a'),
              onPressed: () => _amountController.text = '$a',
            )).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              final amt = double.tryParse(_amountController.text);
              if (amt == null || amt <= 0) return;
              final ok = await ref.read(fastagRepositoryProvider).recharge(v.id, amt);
              if (context.mounted && ok) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recharge successful')));
                Navigator.pop(context);
              }
            },
            child: const Text('Recharge'),
          ),
        ],
      ),
    );
  }
}
