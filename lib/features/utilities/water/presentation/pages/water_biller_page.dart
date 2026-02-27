import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/repositories/water_repository.dart';

final waterRepositoryProvider = Provider<WaterRepository>((ref) => WaterRepository());

class WaterBillerPage extends ConsumerStatefulWidget {
  const WaterBillerPage({super.key});

  @override
  ConsumerState<WaterBillerPage> createState() => _WaterBillerPageState();
}

class _WaterBillerPageState extends ConsumerState<WaterBillerPage> {
  List<Map<String, String>> _billers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    ref.read(waterRepositoryProvider).getBillers().then((v) {
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
      appBar: AppBar(title: const Text('Water Bill'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
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
                    leading: const Icon(Icons.water_drop_rounded),
                    title: Text(b['name'] ?? ''),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TODO: Consumer ID & fetch bill (BBPS)')));
                    },
                  ),
                );
              },
            ),
    );
  }
}
