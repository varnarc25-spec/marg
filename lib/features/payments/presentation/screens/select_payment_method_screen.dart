import 'package:flutter/material.dart';

/// Purple accent for payment method selection (per design)
const Color _paymentPurple = Color(0xFF6C63FF);

/// Select Payment Method screen – Bank Transfer, Credit/Debit Card, E-wallet sections with radio selection and Confirm button
class SelectPaymentMethodScreen extends StatefulWidget {
  const SelectPaymentMethodScreen({super.key});

  @override
  State<SelectPaymentMethodScreen> createState() => _SelectPaymentMethodScreenState();
}

class _SelectPaymentMethodScreenState extends State<SelectPaymentMethodScreen> {
  /// (sectionIndex, optionIndex) – section 0 = Bank Transfer, 1 = Credit/Debit Card, 2 = E-wallet
  int _selectedSection = 0;
  int _selectedOption = 0;

  static const List<Map<String, String>> _bankTransfer = [
    {'name': 'Bank of America', 'sub': 'Checked automatically'},
    {'name': 'Barclays', 'sub': 'Checked automatically'},
    {'name': 'Wells Fargo', 'sub': 'Checked automatically'},
  ];

  static const List<Map<String, String>> _creditDebitCard = [
    {'name': 'Visa', 'sub': '**** **** **** 4567'},
    {'name': 'Mastercard', 'sub': '**** **** **** 3456'},
  ];

  static const List<Map<String, String>> _eWallet = [];

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
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildSection(
                      context,
                      title: 'Bank Transfer',
                      options: _bankTransfer,
                      sectionIndex: 0,
                      logos: [
                        _LogoPlaceholder(colors: [Color(0xFFE53935), Color(0xFF1E88E5)]),
                        _LogoPlaceholder(colors: [Color(0xFF00ACC1)], text: 'B'),
                        _LogoPlaceholder(colors: [Color(0xFFD32F2F)], text: 'WF'),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _buildSection(
                      context,
                      title: 'Credit/Debit Card',
                      options: _creditDebitCard,
                      sectionIndex: 1,
                      logos: [
                        _LogoPlaceholder(colors: [Color(0xFF1A237E)], text: 'VISA'),
                        _LogoPlaceholder(colors: [Color(0xFFEB001B), Color(0xFFF79E1B)], isCircle: true),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _buildSection(
                      context,
                      title: 'E-wallet',
                      options: _eWallet,
                      sectionIndex: 2,
                      logos: [],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Map<String, String>> options,
    required int sectionIndex,
    required List<_LogoPlaceholder> logos,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        if (options.isEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'No options available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ] else ...[
          const SizedBox(height: 12),
          ...List.generate(
            options.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _PaymentOptionCard(
                name: options[i]['name']!,
                subtitle: options[i]['sub']!,
                logo: i < logos.length ? logos[i] : null,
                isSelected: _selectedSection == sectionIndex && _selectedOption == i,
                onTap: () => setState(() {
                  _selectedSection = sectionIndex;
                  _selectedOption = i;
                }),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(
            backgroundColor: _paymentPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Confirm'),
        ),
      ),
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final _LogoPlaceholder? logo;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.name,
    required this.subtitle,
    this.logo,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? _paymentPurple
                  : Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
              width: isSelected ? 2 : 1,
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
              if (logo != null) ...[
                logo!,
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              _RadioIndicator(isSelected: isSelected),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  final bool isSelected;

  const _RadioIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? _paymentPurple : Colors.transparent,
        border: Border.all(
          color: isSelected ? _paymentPurple : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: isSelected
          ? Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  final List<Color> colors;
  final String? text;
  final bool isCircle;

  const _LogoPlaceholder({
    required this.colors,
    this.text,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: colors.first,
        borderRadius: BorderRadius.circular(isCircle ? 22 : 10),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: text != null
          ? Text(
              text!,
              style: TextStyle(
                color: Colors.white,
                fontSize: text!.length > 3 ? 10 : 14,
                fontWeight: FontWeight.w700,
              ),
            )
          : null,
    );
  }
}
