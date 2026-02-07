import 'package:flutter/material.dart';
import 'transfer_balance_list_contact_screen.dart';
import 'transfer_balance_confirmation_screen.dart';

/// Screen 104: Transfer Balance – amount input, recipient card, keypad, Transfer Preview
const Color _transferPurple = Color(0xFF6C63FF);

class TransferBalanceScreen extends StatefulWidget {
  const TransferBalanceScreen({super.key});

  @override
  State<TransferBalanceScreen> createState() => _TransferBalanceScreenState();
}

class _TransferBalanceScreenState extends State<TransferBalanceScreen> {
  String _amountString = '567';
  static const double _usdBalance = 8786.55;

  TransferContact _selectedContact = const TransferContact(
    name: 'Aileen Fullbright',
    phone: '+17896 8797 908',
    initial: 'A',
  );

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

  Future<void> _openAddressBook() async {
    final contact = await Navigator.of(context).push<TransferContact>(
      MaterialPageRoute(
        builder: (_) => const TransferBalanceListContactScreen(),
      ),
    );
    if (contact != null && mounted) {
      setState(() => _selectedContact = contact);
    }
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
        title: const Text('Transfer USD'),
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      _amountString.isEmpty ? '\$0.00' : '\$$_amountString${_amountString.contains('.') ? '' : '.00'}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'USD Balance \$${_usdBalance.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 24),
                    _buildRecipientCard(context),
                    const SizedBox(height: 28),
                    _buildKeypad(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildTransferPreviewButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipientCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _transferPurple.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: _transferPurple.withValues(alpha: 0.2),
            child: Text(
              _selectedContact.initial,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _transferPurple,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedContact.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedContact.phone,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _openAddressBook,
            child: Text(
              'Change',
              style: TextStyle(
                color: _transferPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad(BuildContext context) {
    const keys = [
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
                                ? Icon(
                                    Icons.backspace_outlined,
                                    size: 24,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  )
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

  Widget _buildTransferPreviewButton(BuildContext context) {
    final canProceed = _amount > 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: canProceed
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TransferBalanceConfirmationScreen(
                        amount: _amount,
                        contact: _selectedContact,
                      ),
                    ),
                  );
                }
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: _transferPurple,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Transfer Preview'),
        ),
      ),
    );
  }
}
