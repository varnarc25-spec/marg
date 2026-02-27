import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/data_card_plan.dart';
import '../providers/data_card_provider.dart';

class DataCardPlanPage extends ConsumerStatefulWidget {
  const DataCardPlanPage({super.key});

  @override
  ConsumerState<DataCardPlanPage> createState() => _DataCardPlanPageState();
}

class _DataCardPlanPageState extends ConsumerState<DataCardPlanPage> {
  final _numberController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final op = ref.watch(selectedDataCardOperatorProvider);
    final plansAsync = op != null ? ref.watch(dataCardPlansProvider(op.id)) : null;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Select plan'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _numberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Data card number'),
            onChanged: (v) => ref.read(dataCardNumberProvider.notifier).state = v,
          ),
          const SizedBox(height: 16),
          if (plansAsync != null)
            plansAsync.when(
              data: (plans) => Column(
                children: plans.map((plan) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(plan.name),
                    subtitle: Text('${plan.dataAllowance} • ${plan.validity}'),
                    trailing: Text('₹${plan.amount}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                    onTap: () async {
                      ref.read(selectedDataCardPlanProvider.notifier).state = plan;
                      final repo = ref.read(dataCardRepositoryProvider);
                      final ok = await repo.recharge(operatorId: op!.id, number: _numberController.text, amount: plan.amount);
                      if (context.mounted && ok) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recharge successful')));
                        Navigator.pop(context);
                      }
                    },
                  ),
                )).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
        ],
      ),
    );
  }
}
