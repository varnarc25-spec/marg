import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../providers/dth_recharge_provider.dart';
import 'dth_plan_list_page.dart';

class DthNumberInputPage extends ConsumerStatefulWidget {
  const DthNumberInputPage({super.key});

  @override
  ConsumerState<DthNumberInputPage> createState() => _DthNumberInputPageState();
}

class _DthNumberInputPageState extends ConsumerState<DthNumberInputPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final op = ref.watch(selectedDthOperatorProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Subscriber ID'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (op != null) Text('Operator: ${op.name}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Enter subscriber ID / VC number'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(dthSubscriberIdProvider.notifier).state = _controller.text.trim();
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DthPlanListPage()));
            },
            child: const Text('View plans'),
          ),
        ],
      ),
    );
  }
}
