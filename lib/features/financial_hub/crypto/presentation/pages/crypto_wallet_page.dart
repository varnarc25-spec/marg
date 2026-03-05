import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import 'crypto_swap_page.dart';

/// Crypto wallet page: dark theme card with total balance,
/// quick actions, and recent transactions list.
/// Inspired by the provided design; uses app theme colors.
class CryptoWalletPage extends StatelessWidget {
  const CryptoWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final background = AppColors.backgroundLight;
    final cardColor = const Color(0xFFF8F3DB);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Crypto',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: background,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.textPrimary,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            color: AppColors.textPrimary,
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _BalanceCard(cardColor: cardColor, textTheme: textTheme),
          const SizedBox(height: 20),
          _ActionRow(colorScheme: colorScheme),
          const SizedBox(height: 24),
          _TransactionsHeader(textTheme: textTheme),
          const SizedBox(height: 12),
          const _TransactionsList(),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.cardColor, required this.textTheme});

  final Color cardColor;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'USD',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility_rounded,
                      size: 16,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Portfolio',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '194,284',
            style: textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$2,678',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '+1.6%',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.accentGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const _CircleAction(
          icon: Icons.arrow_downward_rounded,
          label: 'Receive',
        ),
        const _CircleAction(
          icon: Icons.add_rounded,
          label: 'Buy',
        ),
        const _CircleAction(
          icon: Icons.arrow_upward_rounded,
          label: 'Send',
        ),
        _CircleAction(
          icon: Icons.swap_horiz_rounded,
          label: 'Exchange',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CryptoSwapPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.textPrimaryDark),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _TransactionsHeader extends StatelessWidget {
  const _TransactionsHeader({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Transactions',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          'Last 4 days',
          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _TransactionsList extends StatelessWidget {
  const _TransactionsList();

  static final List<_CryptoTx> _items = [
    _CryptoTx(
      name: 'Bitcoin',
      symbol: 'BTC',
      amount: '\$2,950.75',
      direction: 'Send',
      highlighted: false,
    ),
    _CryptoTx(
      name: 'Litecoin',
      symbol: 'LTC',
      amount: '\$1,983.02',
      direction: 'Send',
      highlighted: false,
    ),
    _CryptoTx(
      name: 'Bitcoin',
      symbol: 'BTC',
      amount: '\$3,629.41',
      direction: 'Send',
      highlighted: true,
    ),
    _CryptoTx(
      name: 'Ethereum',
      symbol: 'ETH',
      amount: '\$5,710.20',
      direction: 'Received',
      highlighted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _items.map((tx) => _TransactionTile(tx: tx)).toList(),
    );
  }
}

class _CryptoTx {
  const _CryptoTx({
    required this.name,
    required this.symbol,
    required this.amount,
    required this.direction,
    required this.highlighted,
  });

  final String name;
  final String symbol;
  final String amount;
  final String direction;
  final bool highlighted;
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.tx});

  final _CryptoTx tx;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bgColor = tx.highlighted
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.04);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: tx.highlighted
              ? Colors.white.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              tx.symbol.substring(0, 1),
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.name,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tx.symbol,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                tx.amount,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                tx.direction,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
