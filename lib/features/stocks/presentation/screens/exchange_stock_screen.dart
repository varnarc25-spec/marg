import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Purple accent for exchange UI (per design)
const Color _exchangePurple = Color(0xFF6C63FF);

/// Exchange Stock – Convert one stock balance into another (e.g. AMZN → ABNB)
class ExchangeStockScreen extends StatefulWidget {
  const ExchangeStockScreen({super.key});

  @override
  State<ExchangeStockScreen> createState() => _ExchangeStockScreenState();
}

class _ExchangeStockScreenState extends State<ExchangeStockScreen> {
  static const double _amazonBalance = 4987.00;

  String _fromAmount = '890.00';
  String _toAmount = '789.00';
  bool _activeFrom = true; // true = editing From, false = editing To

  String get _activeValue => _activeFrom ? _fromAmount : _toAmount;

  set _activeValue(String v) {
    if (_activeFrom) {
      _fromAmount = v;
    } else {
      _toAmount = v;
    }
  }

  void _onKeyTap(String key) {
    setState(() {
      String s = _activeValue;
      if (key == '*') {
        if (!s.contains('.')) {
          s = s.isEmpty ? '0.' : '$s.';
        }
        _activeValue = s;
        return;
      }
      if (key == 'backspace') {
        if (s.isNotEmpty) {
          s = s.substring(0, s.length - 1);
        }
        _activeValue = s.isEmpty ? '0' : s;
        return;
      }
      if (key == '0' && s == '0') return;
      if (s.contains('.')) {
        final parts = s.split('.');
        if (parts.length == 2 && parts[1].length >= 2) return;
      }
      s = s == '0' && key != '.' ? key : '$s$key';
      _activeValue = s;
    });
  }

  void _swap() {
    setState(() {
      final f = _fromAmount;
      final t = _toAmount;
      _fromAmount = t;
      _toAmount = f;
    });
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

  String _formatDisplay(String raw) {
    if (raw.isEmpty) return '0.00';
    final v = double.tryParse(raw) ?? 0;
    return v.toStringAsFixed(2);
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
        title: const Text('Exchange'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Amazon balance',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatCurrency(_amazonBalance),
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 28),
                    _buildExchangeRow(
                      context,
                      label: 'From',
                      value: _fromAmount,
                      isActive: _activeFrom,
                      logoChar: 'a',
                      logoColor: AppColors.accentOrange,
                      ticker: 'AMZN',
                      onTap: () => setState(() => _activeFrom = true),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Material(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: _swap,
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.swap_vert_rounded,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExchangeRow(
                      context,
                      label: 'To',
                      value: _toAmount,
                      isActive: !_activeFrom,
                      logoChar: 'A',
                      logoColor: AppColors.accentRed,
                      ticker: 'ABNB',
                      onTap: () => setState(() => _activeFrom = false),
                    ),
                    const SizedBox(height: 28),
                    _buildKeypad(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildConvertButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildExchangeRow(
    BuildContext context, {
    required String label,
    required String value,
    required bool isActive,
    required String logoChar,
    required Color logoColor,
    required String ticker,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? _exchangePurple : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDisplay(value),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: logoColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                logoChar,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              ticker,
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

  Widget _buildConvertButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            backgroundColor: _exchangePurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Convert'),
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
