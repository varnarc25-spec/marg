import 'package:flutter/material.dart';

/// Purple accent for payments (per design)
const Color _paymentPurple = Color(0xFF6C63FF);

/// Create Order screen – order details, amount, payment method, create order button
class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  String _amountString = '';
  String _description = '';
  int _selectedPaymentIndex = 0;

  static const List<String> _paymentMethods = [
    'Wallet',
    'UPI',
    'Card',
    'Bank Transfer',
  ];

  double get _amount => double.tryParse(_amountString) ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Create Order'),
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
                    _buildAmountSection(context),
                    const SizedBox(height: 24),
                    _buildDescriptionSection(context),
                    const SizedBox(height: 24),
                    _buildPaymentMethodSection(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildCreateOrderButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _paymentPurple.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Text(
                r'$',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  onChanged: (v) => setState(() => _amountString = v),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (optional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Add a note for this order',
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            maxLines: 2,
            onChanged: (v) => setState(() => _description = v),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment method',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 12),
        ...List.generate(
          _paymentMethods.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: _selectedPaymentIndex == i
                  ? _paymentPurple.withValues(alpha: 0.12)
                  : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () => setState(() => _selectedPaymentIndex = i),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selectedPaymentIndex == i
                          ? _paymentPurple
                          : Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
                      width: _selectedPaymentIndex == i ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _iconForPayment(_paymentMethods[i]),
                        size: 24,
                        color: _selectedPaymentIndex == i
                            ? _paymentPurple
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        _paymentMethods[i],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const Spacer(),
                      if (_selectedPaymentIndex == i)
                        Icon(
                          Icons.check_circle_rounded,
                          size: 22,
                          color: _paymentPurple,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _iconForPayment(String method) {
    switch (method) {
      case 'Wallet':
        return Icons.account_balance_wallet_rounded;
      case 'UPI':
        return Icons.phone_android_rounded;
      case 'Card':
        return Icons.credit_card_rounded;
      case 'Bank Transfer':
        return Icons.account_balance_rounded;
      default:
        return Icons.payment_rounded;
    }
  }

  Widget _buildCreateOrderButton(BuildContext context) {
    final canCreate = _amount > 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: canCreate
              ? () {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _description.isEmpty
                              ? 'Order created for \$${_amount.toStringAsFixed(2)}'
                              : 'Order: $_description — \$${_amount.toStringAsFixed(2)}',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: _paymentPurple,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            disabledForegroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Create Order'),
        ),
      ),
    );
  }
}
