import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/fastag_api_exceptions.dart';
import '../../data/models/fastag_auto_recharge_rule.dart';
import '../providers/fastag_provider.dart';

/// Loads `GET` and saves `PUT /api/recharges/fastag/auto-recharge/{vehicleId}`.
class FastagAutorechargeRulesPage extends ConsumerWidget {
  const FastagAutorechargeRulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(selectedFastagVehicleProvider);
    if (v == null) {
      return const Scaffold(body: Center(child: Text('Select vehicle')));
    }

    final async = ref.watch(fastagAutoRechargeProvider(v.id));
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Auto-recharge'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                ref.invalidate(fastagAutoRechargeProvider(v.id)),
          ),
        ],
      ),
      body: async.when(
        data: (rule) => _AutoRechargeForm(
          key: ValueKey('${v.id}_${rule.raw.hashCode}'),
          vehicleId: v.id,
          initial: rule,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(fastagApiUserMessage(e))),
      ),
    );
  }
}

class _AutoRechargeForm extends ConsumerStatefulWidget {
  const _AutoRechargeForm({
    super.key,
    required this.vehicleId,
    required this.initial,
  });

  final String vehicleId;
  final FastagAutoRechargeRule initial;

  @override
  ConsumerState<_AutoRechargeForm> createState() => _AutoRechargeFormState();
}

class _AutoRechargeFormState extends ConsumerState<_AutoRechargeForm> {
  late final TextEditingController _thresholdController;
  late final TextEditingController _amountController;
  late bool _enabled;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final r = widget.initial;
    _enabled = r.enabled;
    _thresholdController = TextEditingController(
      text: r.thresholdAmount != null
          ? r.thresholdAmount!.toStringAsFixed(0)
          : '',
    );
    _amountController = TextEditingController(
      text: r.rechargeAmount != null
          ? r.rechargeAmount!.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final th = double.tryParse(_thresholdController.text);
    final amt = double.tryParse(_amountController.text);
    setState(() => _saving = true);
    try {
      await ref.read(fastagRepositoryProvider).setAutoRechargeRule(
            widget.vehicleId,
            FastagAutoRechargeRule(
              enabled: _enabled,
              thresholdAmount: th,
              rechargeAmount: amt,
            ),
          );
      ref.invalidate(fastagAutoRechargeProvider(widget.vehicleId));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(fastagApiUserMessage(e))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Auto-recharge when balance is low'),
          subtitle: const Text('Uses threshold and top-up amount below'),
          value: _enabled,
          onChanged: (x) => setState(() => _enabled = x),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _thresholdController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Threshold balance (₹)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Top-up amount (₹)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
