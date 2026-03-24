import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../providers/water_provider.dart';
import 'water_fetch_bill_page.dart';

class WaterConsumerIdPage extends ConsumerStatefulWidget {
  const WaterConsumerIdPage({super.key});

  @override
  ConsumerState<WaterConsumerIdPage> createState() =>
      _WaterConsumerIdPageState();
}

class _WaterConsumerIdPageState extends ConsumerState<WaterConsumerIdPage> {
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
                ref.read(waterConsumerNumberProvider.notifier).state = v,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ref.read(waterConsumerNumberProvider.notifier).state =
                  _controller.text.trim();
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const WaterFetchBillPage(),
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
