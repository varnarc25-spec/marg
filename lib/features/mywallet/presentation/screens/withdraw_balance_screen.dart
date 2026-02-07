import 'package:flutter/material.dart';

/// Screen 102: Withdraw Balance – amount, Withdraw fee, bank selector, 25/50/75/100%, keypad, Withdraw Preview
const Color _withdrawPurple = Color(0xFF6C63FF);

class WithdrawBalanceScreen extends StatefulWidget {
  const WithdrawBalanceScreen({super.key});

  @override
  State<WithdrawBalanceScreen> createState() => _WithdrawBalanceScreenState();
}

class _WithdrawBalanceScreenState extends State<WithdrawBalanceScreen> {
  String _amountString = '1567';
  static const double _withdrawFee = 2.00;
  static const double _maxBalance = 8786.55;

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
        if (_amountString.isNotEmpty) _amountString = _amountString.substring(0, _amountString.length - 1);
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

  void _onPercentTap(int pct) {
    setState(() {
      final value = (_maxBalance * pct / 100).toStringAsFixed(2);
      _amountString = value.replaceAll('.00', '');
    });
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
        title: const Text('Withdraw'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              child: Icon(Icons.help_outline_rounded, size: 20, color: Theme.of(context).colorScheme.onSurface),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _withdrawPurple.withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _amountString.isEmpty ? '0' : '\$$_amountString${_amountString.contains('.') ? '' : '.00'}',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Withdraw fee \$${_withdrawFee.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Barclays',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        TextButton(onPressed: () {}, child: const Text('Change')),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        for (final pct in [25, 50, 75, 100])
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: pct < 100 ? 10 : 0),
                              child: Material(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: () => _onPercentTap(pct),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    child: Center(
                                      child: Text(
                                        '$pct%',
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
                          ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _buildKeypad(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _amount > 0 ? () {} : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: _withdrawPurple,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Withdraw Preview'),
                ),
              ),
            ),
          ],
        ),
      ),
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
                      child: Material(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () => _onKeyTap(row[i]),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            alignment: Alignment.center,
                            child: row[i] == 'backspace'
                                ? Icon(Icons.backspace_outlined, size: 24, color: Theme.of(context).colorScheme.onSurface)
                                : Text(
                                    row[i] == '*' ? '·' : row[i],
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
