import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../providers/broadband_provider.dart';
import 'broadband_fetch_bill_page.dart';

class BroadbandConsumerIdPage extends ConsumerStatefulWidget {
  const BroadbandConsumerIdPage({super.key});

  @override
  ConsumerState<BroadbandConsumerIdPage> createState() => _BroadbandConsumerIdPageState();
}

class _BroadbandConsumerIdPageState extends ConsumerState<BroadbandConsumerIdPage> {
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
            onChanged: (v) => ref.read(broadbandConsumerNumberProvider.notifier).state = v,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ref.read(broadbandConsumerNumberProvider.notifier).state = _controller.text.trim();
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const BroadbandFetchBillPage(),
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
