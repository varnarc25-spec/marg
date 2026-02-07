import 'package:flutter/material.dart';

/// Screen 123: Payment Method - Link
const Color _paymentPurple = Color(0xFF6C63FF);

enum PaymentMethodType { bankTransfer, card, ewallet }

class _PaymentOption {
  final String name;
  final String subtitle;
  final IconData icon;
  final PaymentMethodType type;
  const _PaymentOption({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.type,
  });
}

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int? _selectedBankIndex;
  int? _selectedCardIndex;

  static const List<_PaymentOption> _banks = [
    _PaymentOption(
      name: 'Bank of America',
      subtitle: 'Checked automatically',
      icon: Icons.account_balance_rounded,
      type: PaymentMethodType.bankTransfer,
    ),
    _PaymentOption(
      name: 'Barclays',
      subtitle: 'Checked automatically',
      icon: Icons.account_balance_rounded,
      type: PaymentMethodType.bankTransfer,
    ),
    _PaymentOption(
      name: 'Wells Fargo',
      subtitle: 'Checked automatically',
      icon: Icons.account_balance_rounded,
      type: PaymentMethodType.bankTransfer,
    ),
  ];

  static const List<_PaymentOption> _cards = [
    _PaymentOption(
      name: 'Visa',
      subtitle: '**** **** **** 4567',
      icon: Icons.credit_card_rounded,
      type: PaymentMethodType.card,
    ),
    _PaymentOption(
      name: 'Mastercard',
      subtitle: '**** **** **** 3456',
      icon: Icons.credit_card_rounded,
      type: PaymentMethodType.card,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedBankIndex = 0;
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
        title: const Text('Payment Method'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Bank Transfer',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(_banks.length, (i) => _PaymentCard(
                          option: _banks[i],
                          value: i,
                          groupValue: _selectedBankIndex,
                          onTap: () => setState(() => _selectedBankIndex = i),
                        )),
                    const SizedBox(height: 24),
                    Text(
                      'Credit/Debit Card',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(_cards.length, (i) => _PaymentCard(
                          option: _cards[i],
                          value: 10 + i,
                          groupValue: _selectedCardIndex != null ? 10 + _selectedCardIndex! : null,
                          onTap: () => setState(() => _selectedCardIndex = i),
                        )),
                    const SizedBox(height: 24),
                    Text(
                      'E-wallet',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _PaymentCard(
                      option: const _PaymentOption(
                        name: 'E-wallet',
                        subtitle: 'Add e-wallet',
                        icon: Icons.account_balance_wallet_rounded,
                        type: PaymentMethodType.ewallet,
                      ),
                      value: 20,
                      groupValue: null,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: _paymentPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Confirm'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final _PaymentOption option;
  final int value;
  final int? groupValue;
  final VoidCallback onTap;

  const _PaymentCard({
    required this.option,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  bool get selected => groupValue != null && groupValue == value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _paymentPurple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(option.icon, size: 26, color: _paymentPurple),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option.subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Radio<int>(
                  value: value,
                  groupValue: groupValue,
                  onChanged: groupValue != null ? (_) => onTap() : null,
                  activeColor: _paymentPurple,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
