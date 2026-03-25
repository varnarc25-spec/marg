import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../data/gas_api_exceptions.dart';
import '../providers/gas_provider.dart';

/// `POST /api/utilities/piped-gas/accounts`
class GasAddAccountPage extends ConsumerStatefulWidget {
  const GasAddAccountPage({super.key});

  @override
  ConsumerState<GasAddAccountPage> createState() => _GasAddAccountPageState();
}

class _GasAddAccountPageState extends ConsumerState<GasAddAccountPage> {
  final _accountNumberController = TextEditingController();
  final _labelController = TextEditingController();
  final _billerNameController = TextEditingController();
  final _consumerNameController = TextEditingController();
  bool _autopay = false;
  bool _saving = false;

  @override
  void dispose() {
    _accountNumberController.dispose();
    _labelController.dispose();
    _billerNameController.dispose();
    _consumerNameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final biller = ref.read(selectedGasBillerProvider);
    if (biller == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a biller from Piped Gas flow first')),
      );
      return;
    }
    final acc = _accountNumberController.text.trim();
    if (acc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter account number')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(gasRepositoryProvider).createAccount(
            accountNumber: acc,
            label: _labelController.text.trim().isEmpty ? 'My account' : _labelController.text.trim(),
            billerId: biller.id,
            billerName: _billerNameController.text.trim().isEmpty
                ? biller.name
                : _billerNameController.text.trim(),
            consumerName: _consumerNameController.text.trim(),
            isAutopay: _autopay,
          );
      ref.invalidate(gasSavedAccountsProvider);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(gasApiUserMessage(e))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final biller = ref.watch(selectedGasBillerProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Save account'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (biller != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(biller.name),
              subtitle: const Text('Biller'),
            ),
          const SizedBox(height: 8),
          TextField(
            controller: _accountNumberController,
            decoration: const InputDecoration(
              labelText: 'Account number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _labelController,
            decoration: const InputDecoration(
              labelText: 'Label',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _billerNameController,
            decoration: InputDecoration(
              labelText: 'Biller name',
              hintText: biller?.name,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _consumerNameController,
            decoration: const InputDecoration(
              labelText: 'Consumer name',
              border: OutlineInputBorder(),
            ),
          ),
          SwitchListTile(
            title: const Text('Autopay'),
            value: _autopay,
            onChanged: (v) => setState(() => _autopay = v),
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
      ),
    );
  }
}
