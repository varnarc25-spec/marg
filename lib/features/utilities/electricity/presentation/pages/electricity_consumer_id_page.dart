import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../providers/electricity_provider.dart';
import 'electricity_fetch_bill_page.dart';

class ElectricityConsumerIdPage extends ConsumerStatefulWidget {
  const ElectricityConsumerIdPage({super.key});

  @override
  ConsumerState<ElectricityConsumerIdPage> createState() =>
      _ElectricityConsumerIdPageState();
}

class _ElectricityConsumerIdPageState
    extends ConsumerState<ElectricityConsumerIdPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Consumer number'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Enter consumer number',
              labelText: 'Consumer number',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) =>
                ref.read(electricityConsumerNumberProvider.notifier).state = v,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ref.read(electricityConsumerNumberProvider.notifier).state =
                  _controller.text.trim();
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const ElectricityFetchBillPage(),
                ),
              );
            },
            child: const Text('Fetch bill'),
          ),
        ],
      ),
    );
  }
}
