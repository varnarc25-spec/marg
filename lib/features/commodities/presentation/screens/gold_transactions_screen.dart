import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Gold color for gold transaction icon
const Color _goldColor = Color(0xFFD4AF37);

/// Purple for deposit icon
const Color _depositPurple = Color(0xFFECEBFF);

/// Gold Transactions (Activity) – chronological list of gold and USD transactions grouped by date
class GoldTransactionsScreen extends StatelessWidget {
  const GoldTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <_GoldTxnSection>[
      _GoldTxnSection(
        dateLabel: '20 October 2022',
        items: [
          const _GoldTxn(
            title: 'Buy Gold',
            time: '04:00 PM',
            qtyText: '+ 1,0g',
            amountText: '\$87.65',
            isPositive: true,
            leading: _GoldTxnLeading.gold(),
          ),
          _GoldTxn(
            title: 'Sell Gold',
            time: '10:15 AM',
            qtyText: '- 5,0g',
            amountText: '\$549.00',
            isPositive: false,
            leading: _GoldTxnLeading.gold(),
          ),
          _GoldTxn(
            title: 'Deposit (USD)',
            time: '07:00 AM',
            qtyText: '',
            amountText: '+ \$234.00',
            isPositive: true,
            leading: _GoldTxnLeading.deposit(),
          ),
        ],
      ),
      _GoldTxnSection(
        dateLabel: '10 October 2022',
        items: [
          const _GoldTxn(
            title: 'Deposit (USD)',
            time: '07:00 PM',
            qtyText: '',
            amountText: '+ \$560.00',
            isPositive: true,
            leading: _GoldTxnLeading.deposit(),
          ),
          _GoldTxn(
            title: 'Buy Gold',
            time: '04:00 PM',
            qtyText: '+ 1,0g',
            amountText: '\$87.65',
            isPositive: true,
            leading: _GoldTxnLeading.gold(),
          ),
          _GoldTxn(
            title: 'Sell Gold',
            time: '10:15 AM',
            qtyText: '- 5,0g',
            amountText: '\$549.00',
            isPositive: false,
            leading: _GoldTxnLeading.gold(),
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Activity'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          itemCount: sections.length,
          itemBuilder: (context, sectionIndex) {
            final section = sections[sectionIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sectionIndex == 0) const SizedBox(height: 6),
                Text(
                  section.dateLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 10),
                ...section.items.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _GoldTransactionCard(txn: t),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GoldTxnSection {
  final String dateLabel;
  final List<_GoldTxn> items;

  const _GoldTxnSection({required this.dateLabel, required this.items});
}

class _GoldTxn {
  final String title;
  final String time;
  final String qtyText;
  final String amountText;
  final bool isPositive;
  final _GoldTxnLeading leading;

  const _GoldTxn({
    required this.title,
    required this.time,
    required this.qtyText,
    required this.amountText,
    required this.isPositive,
    required this.leading,
  });
}

class _GoldTxnLeading {
  final Color bg;
  final Widget child;

  const _GoldTxnLeading({required this.bg, required this.child});

  const factory _GoldTxnLeading.gold() = _GoldLeading;
  const factory _GoldTxnLeading.deposit() = _DepositLeading;
}

class _GoldLeading extends _GoldTxnLeading {
  const _GoldLeading()
      : super(
          bg: _goldColor,
          child: const Icon(Icons.diamond_rounded, color: Colors.white, size: 22),
        );
}

class _DepositLeading extends _GoldTxnLeading {
  const _DepositLeading()
      : super(
          bg: _depositPurple,
          child: const Text(
            r'$',
            style: TextStyle(
              color: Color(0xFF6C63FF),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        );
}

class _GoldTransactionCard extends StatelessWidget {
  final _GoldTxn txn;

  const _GoldTransactionCard({required this.txn});

  @override
  Widget build(BuildContext context) {
    final qtyColor = txn.qtyText.isEmpty
        ? null
        : (txn.isPositive ? AppColors.accentGreen : AppColors.accentRed);
    final amountColor = txn.qtyText.isEmpty && txn.isPositive
        ? AppColors.accentGreen
        : Theme.of(context).colorScheme.onSurface;
    final subColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: txn.leading.bg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: txn.leading.child,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  txn.time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: subColor),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (txn.qtyText.isNotEmpty)
                Text(
                  txn.qtyText,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: qtyColor ?? Theme.of(context).colorScheme.onSurface,
                      ),
                )
              else
                const SizedBox(height: 18),
              const SizedBox(height: 4),
              Text(
                txn.amountText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: amountColor,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
