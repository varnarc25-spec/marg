import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/fastag_provider.dart';

class FastagTollHistoryPage extends ConsumerStatefulWidget {
  const FastagTollHistoryPage({super.key});

  @override
  ConsumerState<FastagTollHistoryPage> createState() => _FastagTollHistoryPageState();
}

class _FastagTollHistoryPageState extends ConsumerState<FastagTollHistoryPage> {
  List<Map<String, dynamic>> _trips = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final v = ref.read(selectedFastagVehicleProvider);
    if (v != null) {
      ref.read(fastagRepositoryProvider).getTollHistory(v.id).then((list) {
        if (mounted) setState(() {
          _trips = list;
          _loading = false;
        });
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Toll history'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _trips.length,
              itemBuilder: (_, i) {
                final t = _trips[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.toll_rounded),
                    title: Text(t['toll']?.toString() ?? 'Toll'),
                    subtitle: Text(t['date']?.toString().substring(0, 10) ?? ''),
                    trailing: Text('₹${t['amount']}'),
                  ),
                );
              },
            ),
    );
  }
}
