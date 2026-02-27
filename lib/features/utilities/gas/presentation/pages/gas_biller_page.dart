import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/repositories/gas_repository.dart';

final gasRepositoryProvider = Provider<GasRepository>((ref) => GasRepository());

class GasBillerPage extends ConsumerStatefulWidget {
  const GasBillerPage({super.key});

  @override
  ConsumerState<GasBillerPage> createState() => _GasBillerPageState();
}

class _GasBillerPageState extends ConsumerState<GasBillerPage> {
  List<Map<String, String>> _billers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    ref.read(gasRepositoryProvider).getBillers().then((v) {
      if (mounted) setState(() {
        _billers = v;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Gas Bill'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _billers.length,
              itemBuilder: (_, i) {
                final b = _billers[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.local_fire_department_rounded),
                    title: Text(b['name'] ?? ''),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TODO: BBPS consumer ID & pay'))),
                  ),
                );
              },
            ),
    );
  }
}
