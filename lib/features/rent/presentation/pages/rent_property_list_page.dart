import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/rent_property.dart';
import '../providers/rent_provider.dart';
import 'rent_property_detail_page.dart';
import 'rent_add_property_page.dart';

class RentPropertyListPage extends ConsumerWidget {
  const RentPropertyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(rentPropertiesProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Rent & Society'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RentAddPropertyPage())),
          ),
        ],
      ),
      body: async.when(
        data: (list) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final p = list[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.home_rounded),
                title: Text(p.address),
                subtitle: Text('₹${p.monthlyRent}/month'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ref.read(selectedRentPropertyProvider.notifier).state = p;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RentPropertyDetailPage()));
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
