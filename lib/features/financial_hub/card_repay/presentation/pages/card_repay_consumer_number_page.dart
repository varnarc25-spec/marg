import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../providers/card_repay_provider.dart';
import 'card_repay_fetch_bill_page.dart';

class CardRepayConsumerNumberPage extends ConsumerStatefulWidget {
  const CardRepayConsumerNumberPage({super.key});

  @override
  ConsumerState<CardRepayConsumerNumberPage> createState() =>
      _CardRepayConsumerNumberPageState();
}

class _CardRepayConsumerNumberPageState extends ConsumerState<CardRepayConsumerNumberPage> {
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
        title: const Text('Consumer Number'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter consumer number',
              labelText: 'Consumer number',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => ref.read(cardRepayConsumerNumberProvider.notifier).state = v,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ref.read(cardRepayConsumerNumberProvider.notifier).state = _controller.text.trim();
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const CardRepayFetchBillPage(),
                ),
              );
            },
            child: const Text('Fetch Bill'),
          ),
        ],
      ),
    );
  }
}
