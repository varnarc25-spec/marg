import 'package:flutter/material.dart';

/// Purple accent for gold loan (per design)
const Color _loanPurple = Color(0xFF6C63FF);

/// Gold Loan screen – Create Loan: gold quantity slider, tenure chips, loan simulation, review
class GoldLoanScreen extends StatefulWidget {
  const GoldLoanScreen({super.key});

  @override
  State<GoldLoanScreen> createState() => _GoldLoanScreenState();
}

class _GoldLoanScreenState extends State<GoldLoanScreen> {
  static const double _pricePerGram = 87.65;
  static const double _minGrams = 0.5;
  static const double _maxGrams = 1000;

  double _quantityGrams = 50;
  int _selectedTenureIndex = 1; // 6 months selected

  static const List<int> _tenureMonths = [3, 6, 12, 18];
  static const List<String> _tenureLabels = ['3 months', '6 months', '12 months', '18 m'];

  double get _totalLoanValue => _quantityGrams * _pricePerGram;

  int get _tenureMonthsValue => _tenureMonths[_selectedTenureIndex];

  double get _monthlyInstallment =>
      _tenureMonthsValue > 0 ? _totalLoanValue / _tenureMonthsValue : 0;

  /// First payment (e.g. higher first installment); remaining months get _monthlyInstallment
  int get _remainingMonthsAfterFirst => (_tenureMonthsValue - 1).clamp(0, 999);

  double get _firstPayment {
    if (_tenureMonthsValue <= 0) return 0;
    // Option: first payment larger (e.g. down + first). Use 1.5x monthly for demo.
    return _monthlyInstallment * 1.5;
  }

  String _formatCurrency(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '\$$intPart.${parts[1]}';
  }

  String _formatGrams(double g) {
    if (g == g.truncateToDouble()) return '${g.toInt()} gr';
    return '${g.toStringAsFixed(1)} gr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Create Loan'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildGoldQuantitySection(context),
                    const SizedBox(height: 28),
                    _buildInstallmentTenureSection(context),
                    const SizedBox(height: 28),
                    _buildLoanSimulationSection(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildReviewButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldQuantitySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Gold Quantity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
            ),
          ),
          child: Text(
            _formatGrams(_quantityGrams),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _loanPurple,
            inactiveTrackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            thumbColor: _loanPurple,
            overlayColor: _loanPurple.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: _quantityGrams.clamp(_minGrams, _maxGrams),
            min: _minGrams,
            max: _maxGrams,
            onChanged: (v) => setState(() => _quantityGrams = v),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatGrams(_minGrams),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              Text(
                _formatGrams(_maxGrams),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstallmentTenureSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Installment Tenure',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            for (var i = 0; i < _tenureLabels.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(
                child: Material(
                  color: _selectedTenureIndex == i
                      ? _loanPurple
                      : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => setState(() => _selectedTenureIndex = i),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          _tenureLabels[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _selectedTenureIndex == i
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildLoanSimulationSection(BuildContext context) {
    final total = _totalLoanValue;
    final monthly = _monthlyInstallment;
    final first = _firstPayment;
    final nextMonths = _remainingMonthsAfterFirst;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan Simulation',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            children: [
              _buildSimRow(
                context,
                label: 'Total loan value',
                value: _formatCurrency(total),
                sub: 'Buy price \$${_pricePerGram.toStringAsFixed(2)}/g',
              ),
              const SizedBox(height: 18),
              _buildSimRow(
                context,
                label: 'Monthly installment',
                value: _formatCurrency(monthly),
                sub: nextMonths > 0 ? 'For the next $nextMonths months' : null,
              ),
              const SizedBox(height: 18),
              _buildSimRow(
                context,
                label: 'First payment',
                value: _formatCurrency(first),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSimRow(
    BuildContext context, {
    required String label,
    required String value,
    String? sub,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              if (sub != null) ...[
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
                      ),
                ),
              ],
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            backgroundColor: _loanPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Review Loan'),
        ),
      ),
    );
  }
}
