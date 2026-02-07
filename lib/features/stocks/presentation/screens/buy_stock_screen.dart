import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Buy Stock – Screen for entering quantity/amount and placing a buy order (e.g. AMZN)
class BuyStockScreen extends StatefulWidget {
  const BuyStockScreen({super.key});

  @override
  State<BuyStockScreen> createState() => _BuyStockScreenState();
}

class _BuyStockScreenState extends State<BuyStockScreen> {
  static const double _pricePerShare = 112.85;
  static const double _balance = 14456.00;
  static const String _symbol = 'AMZN';

  String _inputString = '85.00';
  bool _isSharesMode = true; // true = input is shares, false = input is USD amount

  double get _parsedValue => double.tryParse(_inputString) ?? 0;

  double get _shares => _isSharesMode ? _parsedValue : (_parsedValue / _pricePerShare);

  double get _totalUsd =>
      _isSharesMode ? (_parsedValue * _pricePerShare) : _parsedValue;

  void _onKeyTap(String key) {
    setState(() {
      if (key == '*') {
        if (!_inputString.contains('.')) {
          _inputString = _inputString.isEmpty ? '0.' : '$_inputString.';
        }
        return;
      }
      if (key == 'backspace') {
        if (_inputString.isNotEmpty) {
          _inputString = _inputString.substring(0, _inputString.length - 1);
        }
        return;
      }
      if (key == '0' && _inputString == '0') return;
      if (_inputString.contains('.')) {
        final parts = _inputString.split('.');
        if (parts.length == 2 && parts[1].length >= 2) return;
      }
      _inputString = _inputString == '0' && key != '.' ? key : '$_inputString$key';
    });
  }

  void _onPercentageTap(double pct) {
    setState(() {
      final amount = _balance * pct;
      if (_isSharesMode) {
        final shares = amount / _pricePerShare;
        _inputString = _formatNum(shares);
      } else {
        _inputString = _formatNum(amount);
      }
    });
  }

  String _formatNum(double v) {
    if (v == v.truncateToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2);
  }

  String _formatCurrency(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '${intPart}.${parts[1]}';
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
        title: Text('Buy $_symbol'),
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
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              child: Icon(
                Icons.help_outline_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
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
                  children: [
                    const SizedBox(height: 16),
                    _buildStockInfo(context),
                    const SizedBox(height: 32),
                    _buildAmountSection(context),
                    const SizedBox(height: 24),
                    _buildPercentageButtons(context),
                    const SizedBox(height: 28),
                    _buildKeypad(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBuyButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStockInfo(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.accentOrange,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.accentOrange.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'a',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '1 $_symbol = \$${_pricePerShare.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildAmountSection(BuildContext context) {
    final displayValue = _inputString.isEmpty ? '0' : _inputString;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayValue,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'USD balance \$${_formatCurrency(_balance)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        Material(
          color: AppColors.primaryBlue,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () {
              setState(() {
                _isSharesMode = !_isSharesMode;
                if (_isSharesMode) {
                  _inputString = _formatNum(_totalUsd / _pricePerShare);
                } else {
                  _inputString = _formatNum(_totalUsd);
                }
              });
            },
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.swap_vert_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPercentageButtons(BuildContext context) {
    const percentages = [0.25, 0.50, 0.75, 1.0];
    final labels = ['25%', '50%', '75%', '100%'];
    return Row(
      children: List.generate(
        4,
        (i) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 3 ? 12 : 0),
            child: Material(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => _onPercentageTap(percentages[i]),
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
                for (var i = 0; i < row.length; i++) ...[
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
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBuyButton(BuildContext context) {
    final total = _totalUsd;
    final canBuy = _shares > 0 && total <= _balance;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: canBuy ? () {} : null,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            disabledForegroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Buy \$${_formatCurrency(total)}',
          ),
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
