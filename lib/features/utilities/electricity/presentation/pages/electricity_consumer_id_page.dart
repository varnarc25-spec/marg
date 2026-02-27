import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../providers/electricity_provider.dart';
import 'electricity_fetch_bill_page.dart';

class ElectricityConsumerIdPage extends ConsumerStatefulWidget {
  const ElectricityConsumerIdPage({super.key});

  @override
  ConsumerState<ElectricityConsumerIdPage> createState() => _ElectricityConsumerIdPageState();
}

class _ElectricityConsumerIdPageState extends ConsumerState<ElectricityConsumerIdPage> {
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
      appBar: AppBar(title: const Text('Consumer ID'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Enter consumer number'),
            onChanged: (v) => ref.read(electricityConsumerIdProvider.notifier).state = v,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(electricityConsumerIdProvider.notifier).state = _controller.text;
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ElectricityFetchBillPage()));
            },
            child: const Text('Fetch bill'),
          ),
        ],
      ),
    );
  }
}
