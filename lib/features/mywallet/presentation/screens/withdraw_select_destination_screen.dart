import 'package:flutter/material.dart';

/// Screen 103: Withdraw Balance - Select Withdrawal Destination – Bank Transfer, Credit/Debit Card, Confirm
const Color _destPurple = Color(0xFF6C63FF);

class WithdrawSelectDestinationScreen extends StatefulWidget {
  const WithdrawSelectDestinationScreen({super.key});

  @override
  State<WithdrawSelectDestinationScreen> createState() => _WithdrawSelectDestinationScreenState();
}

class _WithdrawSelectDestinationScreenState extends State<WithdrawSelectDestinationScreen> {
  int _selectedSection = 0;
  int _selectedOption = 1; // Barclays

  static const List<Map<String, String>> _bankTransfer = [
    {'name': 'Bank of America', 'sub': '**** **** **** 8907'},
    {'name': 'Barclays', 'sub': '**** **** **** 8907'},
  ];

  static const List<Map<String, String>> _creditDebitCard = [
    {'name': 'Visa', 'sub': '**** **** **** 4567'},
    {'name': 'Mastercard', 'sub': '**** **** **** 3456'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Withdrawal Destination'),
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
                    _buildSection('Bank Transfer', _bankTransfer, 0),
                    const SizedBox(height: 28),
                    _buildSection('Credit/Debit Card', _creditDebitCard, 1),
                    const SizedBox(height: 32),
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
                    backgroundColor: _destPurple,
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

  Widget _buildSection(String title, List<Map<String, String>> options, int sectionIndex) {
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
        const SizedBox(height: 12),
        ...List.generate(options.length, (i) {
          final isSelected = _selectedSection == sectionIndex && _selectedOption == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () => setState(() {
                  _selectedSection = sectionIndex;
                  _selectedOption = i;
                }),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? _destPurple : Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              options[i]['name']!,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              options[i]['sub']!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? _destPurple : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? _destPurple : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Padding(
                                padding: EdgeInsets.all(4),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
