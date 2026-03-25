import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../providers/gas_provider.dart';
import 'gas_fetch_bill_page.dart';

class GasConsumerIdPage extends ConsumerStatefulWidget {
  const GasConsumerIdPage({super.key});

  @override
  ConsumerState<GasConsumerIdPage> createState() => _GasConsumerIdPageState();
}

class _GasConsumerIdPageState extends ConsumerState<GasConsumerIdPage> {
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
            onChanged: (v) => ref.read(gasConsumerNumberProvider.notifier).state = v,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ref.read(gasConsumerNumberProvider.notifier).state = _controller.text.trim();
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const GasFetchBillPage(),
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

