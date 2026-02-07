import 'package:flutter/material.dart';

/// Purple accent for redeem silver (per design)
const Color _redeemPurple = Color(0xFF6C63FF);

/// Silver color for silver icon
const Color _silverColor = Color(0xFFC0C0C0);

/// Silver Redeem screen – Silver balance header, amount input, quick amounts, keypad, redeem button
class SilverRedeemScreen extends StatefulWidget {
  const SilverRedeemScreen({super.key});

  @override
  State<SilverRedeemScreen> createState() => _SilverRedeemScreenState();
}

class _SilverRedeemScreenState extends State<SilverRedeemScreen> {
  static const double _silverBalance = 100; // gr

  String _amountString = '0.5';

  double get _amount => double.tryParse(_amountString) ?? 0;

  void _onKeyTap(String key) {
    setState(() {
      if (key == '*') {
        if (!_amountString.contains('.')) {
          _amountString = _amountString.isEmpty ? '0.' : '$_amountString.';
        }
        return;
      }
      if (key == 'backspace') {
        if (_amountString.isNotEmpty) {
          _amountString = _amountString.substring(0, _amountString.length - 1);
        }
        return;
      }
      if (key == '0' && _amountString == '0') return;
      if (_amountString.contains('.')) {
        final parts = _amountString.split('.');
        if (parts.length == 2 && parts[1].length >= 2) return;
      }
      _amountString = _amountString == '0' && key != '.' ? key : '$_amountString$key';
    });
  }

  void _onQuickAmountTap(double grams) {
    setState(() {
      _amountString = grams == grams.truncateToDouble()
          ? grams.toInt().toString()
          : grams.toStringAsFixed(2);
    });
  }

  String _formatGrams(double g) {
    if (g == g.truncateToDouble()) return '${g.toInt()} gr';
    return '${g.toStringAsFixed(2)} gr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAmountRow(context),
                    const SizedBox(height: 20),
                    _buildQuickAmountChips(context),
                    const SizedBox(height: 28),
                    _buildKeypad(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildRedeemButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 8,
        left: 16,
        right: 16,
        bottom: 24,
      ).copyWith(
        top: 8 + MediaQuery.of(context).padding.top,
      ),
      decoration: const BoxDecoration(
        color: _redeemPurple,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              const Text(
                'Redeem',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _silverColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.diamond_rounded, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Silver Balance',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatGrams(_silverBalance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _amountString.isEmpty ? '0' : _amountString,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _silverColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'g',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Gram',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAmountChips(BuildContext context) {
    const amounts = [0.10, 0.50, 5.00, 10.00];
    const labels = ['0,10g', '0,50g', '5,00g', '10,00g'];
    return Row(
      children: [
        for (var i = 0; i < amounts.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(
            child: Material(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => _onQuickAmountTap(amounts[i]),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text(
                      labels[i],
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildKeypad(BuildContext context) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['*', '0', 'backspace'],
    ];
    return Column(
      children: [
        for (final row in keys)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                for (var i = 0; i < row.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < row.length - 1 ? 12 : 0),
                      child: _KeypadButton(
                        label: row[i] == '*'
                            ? '·'
                            : (row[i] == 'backspace' ? null : row[i]),
                        isBackspace: row[i] == 'backspace',
                        onTap: () => _onKeyTap(row[i]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRedeemButton(BuildContext context) {
    final canRedeem = _amount > 0 && _amount <= _silverBalance;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: canRedeem ? () {} : null,
          style: FilledButton.styleFrom(
            backgroundColor: _redeemPurple,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            disabledForegroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Redeem'),
        ),
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String? label;
  final bool isBackspace;
  final VoidCallback onTap;

  const _KeypadButton({
    this.label,
    required this.isBackspace,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          alignment: Alignment.center,
          child: isBackspace
              ? Icon(
                  Icons.backspace_outlined,
                  size: 24,
                  color: Theme.of(context).colorScheme.onSurface,
                )
              : Text(
                  label ?? '',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
        ),
      ),
    );
  }
}
