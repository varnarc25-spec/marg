import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../data/models/options_strategy.dart';

/// Options Strategy Builder Screen
/// UI for building and viewing options strategies
class OptionsStrategyBuilderScreen extends ConsumerWidget {
  const OptionsStrategyBuilderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strategyAsync = ref.watch(optionsStrategyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Options Strategy Builder'),
      ),
      body: strategyAsync.when(
        data: (strategy) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StrategyCard(strategy: strategy),
              const SizedBox(height: 16),
              _StrikeSelector(),
              const SizedBox(height: 16),
              _MaxProfitLossCard(strategy: strategy),
              const SizedBox(height: 16),
              _BreakevenCard(strategy: strategy),
              const SizedBox(height: 16),
              _MarginCard(strategy: strategy),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  final OptionsStrategy strategy;

  const _StrategyCard({required this.strategy});

  @override
  Widget build(BuildContext context) {
    final strategies = [
      'Iron Condor',
      'Straddle',
      'Strangle',
      'Butterfly',
      'Covered Call',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Strategy',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: strategies.map((strategyName) {
                final isSelected = strategyName == strategy.strategy;
                return FilterChip(
                  label: Text(strategyName),
                  selected: isSelected,
                  onSelected: (selected) {
                    // In real app, update strategy
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrikeSelector extends StatefulWidget {
  @override
  State<_StrikeSelector> createState() => _StrikeSelectorState();
}

class _StrikeSelectorState extends State<_StrikeSelector> {
  double strikePrice = 21850.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Strike Price',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              '₹${strikePrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Slider(
              value: strikePrice,
              min: 21000,
              max: 23000,
              divisions: 200,
              label: strikePrice.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  strikePrice = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MaxProfitLossCard extends StatelessWidget {
  final OptionsStrategy strategy;

  const _MaxProfitLossCard({required this.strategy});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: _ProfitLossItem(
                label: 'Max Profit',
                value: strategy.maxProfit,
                color: AppColors.accentGreen,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ProfitLossItem(
                label: 'Max Loss',
                value: strategy.maxLoss,
                color: AppColors.accentRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfitLossItem extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _ProfitLossItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            '₹${value.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _BreakevenCard extends StatelessWidget {
  final OptionsStrategy strategy;

  const _BreakevenCard({required this.strategy});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Breakeven Points',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: strategy.breakeven.map((point) {
                return Chip(
                  label: Text('₹$point'),
                  backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarginCard extends StatelessWidget {
  final OptionsStrategy strategy;

  const _MarginCard({required this.strategy});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Margin Required',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${strategy.marginRequired.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // In real app, proceed to trade
              },
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
