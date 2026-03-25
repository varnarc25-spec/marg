import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/gas_api_exceptions.dart';
import '../providers/gas_provider.dart';
import 'gas_consumer_id_page.dart';

class GasBillerPage extends ConsumerStatefulWidget {
  const GasBillerPage({super.key});

  @override
  ConsumerState<GasBillerPage> createState() => _GasBillerPageState();
}

class _GasBillerPageState extends ConsumerState<GasBillerPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(selectedGasStateProvider);
    final billersAsync = state != null ? ref.watch(gasBillersProvider(state.id)) : null;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Select provider'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: billersAsync == null
          ? const Center(child: Text('Select state first'))
          : billersAsync.when(
              data: (billers) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: billers.length,
                itemBuilder: (_, i) {
                  final b = billers[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.local_fire_department_rounded),
                      title: Text(b.name),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ref.read(selectedGasBillerProvider.notifier).state = b;
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const GasConsumerIdPage(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(gasApiUserMessage(e))),
            ),
    );
  }
}
