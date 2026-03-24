import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/fastag_api_exceptions.dart';
import '../providers/fastag_provider.dart';

/// POST `/api/recharges/fastag/vehicles`
class FastagAddVehiclePage extends ConsumerStatefulWidget {
  const FastagAddVehiclePage({super.key});

  @override
  ConsumerState<FastagAddVehiclePage> createState() =>
      _FastagAddVehiclePageState();
}

class _FastagAddVehiclePageState extends ConsumerState<FastagAddVehiclePage> {
  final _vehicleNumberController = TextEditingController();
  final _tagController = TextEditingController();
  final _labelController = TextEditingController();
  final _issuerBankController = TextEditingController();
  String _vehicleType = 'car';
  bool _isPrimary = true;
  bool _saving = false;

  static const _vehicleTypes = [
    ('car', 'Car'),
    ('bike', 'Bike'),
    ('lcv', 'LCV'),
    ('bus', 'Bus'),
    ('truck', 'Truck'),
  ];

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _tagController.dispose();
    _labelController.dispose();
    _issuerBankController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final vn = _vehicleNumberController.text.trim();
    if (vn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter vehicle number')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(fastagRepositoryProvider).addVehicle(
            vehicleNumber: vn,
            tagId: _tagController.text.trim(),
            vehicleType: _vehicleType,
            label: _labelController.text.trim(),
            issuerBank: _issuerBankController.text.trim(),
            isPrimary: _isPrimary,
          );
      ref.invalidate(fastagVehiclesProvider);
      if (!mounted) return;
      Navigator.of(context).pop(true);
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
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Add vehicle'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _vehicleNumberController,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Vehicle number',
              hintText: 'e.g. KA01AB1234',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tagController,
            decoration: const InputDecoration(
              labelText: 'Tag ID',
              hintText: 'FASTag serial / tag id',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _vehicleType,
            decoration: const InputDecoration(
              labelText: 'Vehicle type',
              border: OutlineInputBorder(),
            ),
            items: _vehicleTypes
                .map(
                  (e) => DropdownMenuItem(value: e.$1, child: Text(e.$2)),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _vehicleType = v);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _labelController,
            decoration: const InputDecoration(
              labelText: 'Label',
              hintText: 'e.g. My car',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _issuerBankController,
            decoration: const InputDecoration(
              labelText: 'Issuer bank',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Primary vehicle'),
            value: _isPrimary,
            onChanged: (v) => setState(() => _isPrimary = v),
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
