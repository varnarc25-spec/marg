import 'package:flutter/material.dart';
import 'bank_account_detail_screen.dart';
import 'bank_account_list_screen.dart';
import 'bank_account_add_screen.dart';

/// Screen 118: Bank Account – overview list, Add Bank Account/E-wallet button
const Color _bankPurple = Color(0xFF6C63FF);

class _LinkedItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _LinkedItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

class BankAccountScreen extends StatelessWidget {
  const BankAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bankItems = [
      _LinkedItem(
        title: 'Bank of America',
        subtitle: '•••• •••• •••• 8907',
        icon: Icons.account_balance_rounded,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const BankAccountDetailScreen(
                bankName: 'Bank of America',
                lastFour: '7777',
              ),
            ),
          );
        },
      ),
      _LinkedItem(
        title: 'Barclays',
        subtitle: '•••• •••• •••• 8907',
        icon: Icons.account_balance_rounded,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const BankAccountDetailScreen(
                bankName: 'Barclays',
                lastFour: '8907',
              ),
            ),
          );
        },
      ),
    ];

    final ewalletItems = [
      _LinkedItem(
        title: 'Paypal',
        subtitle: 'uiuxseju@gmail.com',
        icon: Icons.account_balance_wallet_rounded,
        onTap: () {},
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Bank Account'),
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
                      'Bank Account',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ...bankItems.map((i) => _LinkedCard(item: i)),
                    const SizedBox(height: 24),
                    Text(
                      'E-wallet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ...ewalletItems.map((i) => _LinkedCard(item: i)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const BankAccountListScreen()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: _bankPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add Bank Account/E-wallet'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkedCard extends StatelessWidget {
  final _LinkedItem item;

  const _LinkedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _bankPurple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(item.icon, size: 24, color: _bankPurple),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
