import 'package:flutter/material.dart';

/// Market accent – purple used on stocks/market screens
const Color _marketPurple = Color(0xFF6C63FF);

/// Market Sectors screen – Top Sectors and All Market Sectors grid
class MarketSectorsScreen extends StatelessWidget {
  const MarketSectorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Market Sectors',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            // Top Sectors
            Text(
              'Top Sectors',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SectorTile(
                    icon: Icons.account_balance_rounded,
                    label: 'Finance',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SectorTile(
                    icon: Icons.memory_rounded,
                    label: 'Technology',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SectorTile(
                    icon: Icons.inventory_2_rounded,
                    label: 'Utilities',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // All Market Sectors
            Text(
              'All Market Sectors',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.95,
              children: const [
                _SectorGridTile(icon: Icons.trending_up_rounded, label: 'Business'),
                _SectorGridTile(icon: Icons.bolt_rounded, label: 'Energy'),
                _SectorGridTile(icon: Icons.health_and_safety_rounded, label: 'Healthcare'),
                _SectorGridTile(icon: Icons.home_work_rounded, label: 'Real Estate'),
                _SectorGridTile(icon: Icons.shopping_bag_rounded, label: 'Consumer'),
                _SectorGridTile(icon: Icons.phone_rounded, label: 'Communication'),
                _SectorGridTile(icon: Icons.account_balance_rounded, label: 'Finance'),
                _SectorGridTile(icon: Icons.memory_rounded, label: 'Technology'),
                _SectorGridTile(icon: Icons.engineering_rounded, label: 'Industry'),
                _SectorGridTile(icon: Icons.description_rounded, label: 'Materials'),
                _SectorGridTile(icon: Icons.inventory_2_rounded, label: 'Utilities'),
                _SectorGridTile(icon: Icons.wifi_rounded, label: 'Information'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectorTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectorTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: _marketPurple.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _marketPurple.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _marketPurple.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: _marketPurple),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectorGridTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectorGridTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.6),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _marketPurple.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: _marketPurple),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
