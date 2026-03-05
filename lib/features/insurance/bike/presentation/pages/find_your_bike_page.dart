import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/bike_list_data.dart';
import '../providers/bike_vehicle_provider.dart';
import 'bike_insurance_select_plan_page.dart';
import 'bike_insurance_help_page.dart';

/// Find Your Bike: search and select bike from Popular Bikes list. Then go to Select Plan.
class FindYourBikePage extends ConsumerStatefulWidget {
  const FindYourBikePage({super.key});

  @override
  ConsumerState<FindYourBikePage> createState() => _FindYourBikePageState();
}

class _FindYourBikePageState extends ConsumerState<FindYourBikePage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BikeOption> get _filteredBikes {
    if (_query.trim().isEmpty) return popularBikes;
    final q = _query.trim().toLowerCase();
    return popularBikes
        .where((b) =>
            b.name.toLowerCase().contains(q) ||
            b.engineCc.toString().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final filtered = _filteredBikes;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Find Your Bike',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.help_outline_rounded,
              size: 24,
              color: colorScheme.onSurface,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const BikeInsuranceHelpPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search bike name or model',
                  hintStyle: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 22,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            child: Text(
              'Popular Bikes',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
              itemBuilder: (context, index) {
                final bike = filtered[index];
                return InkWell(
                  onTap: () {
                    ref.read(selectedBikeNameProvider.notifier).state =
                        '${bike.name} (${bike.engineCc} cc)';
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BikeInsuranceSelectPlanPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      '${bike.name} (${bike.engineCc} cc)',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
