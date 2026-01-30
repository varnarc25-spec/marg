import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../data/models/options_strategy.dart';
import '../widgets/payoff_chart_widget.dart';

/// Trade with Guidance Screen
/// Guided trade flow with strategy suggestions
class TradeGuidanceScreen extends ConsumerStatefulWidget {
  const TradeGuidanceScreen({super.key});

  @override
  ConsumerState<TradeGuidanceScreen> createState() =>
      _TradeGuidanceScreenState();
}

class _TradeGuidanceScreenState extends ConsumerState<TradeGuidanceScreen> {
  String? selectedInstrument;
  String? selectedSymbol;
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade with Guidance'),
      ),
      body: _buildStepContent(),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildInstrumentSelection();
      case 1:
        return _buildSymbolSelection();
      case 2:
        return _buildStrategySuggestion();
      default:
        return _buildInstrumentSelection();
    }
  }

  Widget _buildInstrumentSelection() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.tradeSelectInstrument,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Expanded(
              child: ListView(
                children: [
                  _InstrumentCard(
                    title: AppStrings.tradeEquity,
                    description: 'Trade stocks directly',
                    icon: Icons.show_chart,
                    isSelected: selectedInstrument == 'equity',
                    onTap: () => setState(() => selectedInstrument = 'equity'),
                  ),
                  const SizedBox(height: 16),
                  _InstrumentCard(
                    title: AppStrings.tradeOptions,
                    description: 'Trade options strategies',
                    icon: Icons.trending_up,
                    isSelected: selectedInstrument == 'options',
                    onTap: () => setState(() => selectedInstrument = 'options'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: selectedInstrument == null
                  ? null
                  : () => setState(() => currentStep = 1),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymbolSelection() {
    final symbols = ['NIFTY', 'BANKNIFTY', 'RELIANCE', 'TCS', 'INFY'];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.tradeSelectSymbol,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Expanded(
              child: ListView(
                children: symbols.map((symbol) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _SymbolCard(
                      symbol: symbol,
                      isSelected: selectedSymbol == symbol,
                      onTap: () => setState(() => selectedSymbol = symbol),
                    ),
                  );
                }).toList(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => currentStep = 0),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedSymbol == null
                        ? null
                        : () => setState(() => currentStep = 2),
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrategySuggestion() {
    final strategyAsync = ref.watch(optionsStrategyProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.tradeStrategySuggestion,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            strategyAsync.when(
              data: (strategy) => Column(
                children: [
                  _StrategyCard(strategy: strategy),
                  const SizedBox(height: 24),
                  _RiskWarningCard(riskLevel: strategy.riskLevel),
                  const SizedBox(height: 24),
                  const PayoffChartWidget(),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _showConfirmDialog(strategy);
                    },
                    child: const Text(AppStrings.tradeConfirm),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: $error'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => setState(() => currentStep = 1),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog(OptionsStrategy strategy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Trade'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Strategy: ${strategy.strategy}'),
            Text('Symbol: ${strategy.symbol}'),
            Text('Max Profit: ₹${strategy.maxProfit.toStringAsFixed(2)}'),
            Text('Max Loss: ₹${strategy.maxLoss.toStringAsFixed(2)}'),
            Text('Margin: ₹${strategy.marginRequired.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Trade placed successfully (Mock)'),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class _InstrumentCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _InstrumentCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      color: isSelected
          ? AppColors.primaryBlue.withOpacity(0.1)
          : AppColors.surfaceLight,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryBlue
                  : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: AppColors.primaryBlue),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primaryBlue,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SymbolCard extends StatelessWidget {
  final String symbol;
  final bool isSelected;
  final VoidCallback onTap;

  const _SymbolCard({
    required this.symbol,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryBlue
                  : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                symbol,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primaryBlue,
                ),
            ],
          ),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strategy.strategy,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StrategyMetric(
                    label: 'Max Profit',
                    value: '₹${strategy.maxProfit.toStringAsFixed(2)}',
                    color: AppColors.accentGreen,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StrategyMetric(
                    label: 'Max Loss',
                    value: '₹${strategy.maxLoss.toStringAsFixed(2)}',
                    color: AppColors.accentRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Breakeven: ${strategy.breakeven.join(' - ')}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Margin Required: ₹${strategy.marginRequired.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrategyMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StrategyMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
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
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _RiskWarningCard extends StatelessWidget {
  final String riskLevel;

  const _RiskWarningCard({required this.riskLevel});

  Color _getRiskColor() {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return AppColors.riskLow;
      case 'medium':
        return AppColors.riskMedium;
      case 'high':
        return AppColors.riskHigh;
      default:
        return AppColors.accentOrange;
    }
  }

  String _getRiskMessage() {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return 'This strategy has low risk. Suitable for conservative traders.';
      case 'medium':
        return 'This strategy has moderate risk. Monitor your positions closely.';
      case 'high':
        return 'This strategy has high risk. Only trade if you understand the risks.';
      default:
        return 'Please assess the risks before trading.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final riskColor = _getRiskColor();
    return Card(
      color: riskColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.warning, color: riskColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _getRiskMessage(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: riskColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
