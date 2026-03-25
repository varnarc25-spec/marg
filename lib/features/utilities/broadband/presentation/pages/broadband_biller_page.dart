import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/broadband_api_exceptions.dart';
import '../providers/broadband_provider.dart';
import 'broadband_consumer_id_page.dart';

class BroadbandBillerPage extends ConsumerStatefulWidget {
  const BroadbandBillerPage({super.key});

  @override
  ConsumerState<BroadbandBillerPage> createState() => _BroadbandBillerPageState();
}

class _BroadbandBillerPageState extends ConsumerState<BroadbandBillerPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(selectedBroadbandStateProvider);
    final billersAsync = state != null ? ref.watch(broadbandBillersProvider(state.id)) : null;
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
                      leading: const Icon(Icons.router_rounded),
                      title: Text(b.name),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ref.read(selectedBroadbandBillerProvider.notifier).state = b;
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const BroadbandConsumerIdPage(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(broadbandApiUserMessage(e))),
            ),
    );
  }
}
