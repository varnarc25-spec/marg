import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/education_api_exceptions.dart';
import '../providers/education_provider.dart';

class EducationAddAccountPage extends ConsumerStatefulWidget {
  const EducationAddAccountPage({super.key});

  @override
  ConsumerState<EducationAddAccountPage> createState() => _EducationAddAccountPageState();
}

class _EducationAddAccountPageState extends ConsumerState<EducationAddAccountPage> {
  final _accountNumberController = TextEditingController();
  final _labelController = TextEditingController();
  final _consumerNameController = TextEditingController();
  bool _autopay = false;
  bool _saving = false;

  @override
  void dispose() {
    _accountNumberController.dispose();
    _labelController.dispose();
    _consumerNameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final biller = ref.read(selectedEducationBillerProvider);
    if (biller == null) return;
    final acc = _accountNumberController.text.trim();
    if (acc.isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(educationRepositoryProvider).createAccount(
            accountNumber: acc,
            label: _labelController.text.trim().isEmpty ? 'My account' : _labelController.text.trim(),
            billerId: biller.id,
            billerName: biller.name,
            consumerName: _consumerNameController.text.trim(),
            isAutopay: _autopay,
          );
      ref.invalidate(educationSavedAccountsProvider);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(educationApiUserMessage(e))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
