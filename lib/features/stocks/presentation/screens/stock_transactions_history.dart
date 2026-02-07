import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Stock Transactions History – grouped list of transactions
class StockTransactionsHistory extends StatelessWidget {
  const StockTransactionsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <_TransactionSection>[
      _TransactionSection(
        dateLabel: '20 October 2022',
        items: [
          const _Txn(
            title: 'Buy AMZN',
            time: '04:00 PM',
            qtyText: '+ 2.00',
            amountText: '\$224.90',
            isPositive: false,
            leading: _TxnLeading.amazon(),
          ),
          const _Txn(
            title: 'Deposit (USD)',
            time: '04:00 PM',
            qtyText: '',
            amountText: '+ \$234.00',
            isPositive: true,
            leading: _TxnLeading.deposit(),
          ),
          const _Txn(
            title: 'Buy AMD',
            time: '02:15 PM',
            qtyText: '+ 3.00',
            amountText: '\$172.38',
            isPositive: false,
            leading: _TxnLeading.amd(),
          ),
        ],
      ),
      _TransactionSection(
        dateLabel: '10 October 2022',
        items: [
          const _Txn(
            title: 'Send (AMZN)',
            time: '07:00 PM',
            qtyText: '- 2.00',
            amountText: '\$224.90',
            isPositive: false,
            leading: _TxnLeading.send(),
          ),
          const _Txn(
            title: 'Buy AAPL',
            time: '04:00 PM',
            qtyText: '+ 7.00',
            amountText: '\$1,016.33',
            isPositive: false,
            leading: _TxnLeading.apple(),
          ),
          const _Txn(
            title: 'Deposit (USD)',
            time: '09:30 AM',
            qtyText: '',
            amountText: '+ \$190.00',
            isPositive: true,
            leading: _TxnLeading.deposit(),
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Transactions History'),
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
                    child: _TransactionCard(txn: t),
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

class _TransactionSection {
  final String dateLabel;
  final List<_Txn> items;

  const _TransactionSection({required this.dateLabel, required this.items});
}

class _Txn {
  final String title;
  final String time;
  final String qtyText;
  final String amountText;
  final bool isPositive;
  final _TxnLeading leading;

  const _Txn({
    required this.title,
    required this.time,
    required this.qtyText,
    required this.amountText,
    required this.isPositive,
    required this.leading,
  });
}

class _TxnLeading {
  final Color bg;
  final Widget child;

  const _TxnLeading({required this.bg, required this.child});

  const factory _TxnLeading.amazon() = _AmazonLeading;
  const factory _TxnLeading.deposit() = _DepositLeading;
  const factory _TxnLeading.amd() = _AmdLeading;
  const factory _TxnLeading.apple() = _AppleLeading;
  const factory _TxnLeading.send() = _SendLeading;
}

class _AmazonLeading extends _TxnLeading {
  const _AmazonLeading()
      : super(
          bg: AppColors.accentOrange,
          child: const Text(
            'a',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        );
}

class _DepositLeading extends _TxnLeading {
  const _DepositLeading()
      : super(
          bg: const Color(0xFFECEBFF),
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

class _AmdLeading extends _TxnLeading {
  const _AmdLeading()
      : super(
          bg: const Color(0xFF27AE60),
          child: const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 20),
        );
}

class _AppleLeading extends _TxnLeading {
  const _AppleLeading()
      : super(
          bg: const Color(0xFF111827),
          child: const Icon(Icons.apple, color: Colors.white, size: 22),
        );
}

class _SendLeading extends _TxnLeading {
  const _SendLeading()
      : super(
          bg: const Color(0xFF10B981),
          child: const Icon(Icons.ios_share_rounded, color: Colors.white, size: 20),
        );
}

class _TransactionCard extends StatelessWidget {
  final _Txn txn;

  const _TransactionCard({required this.txn});

  @override
  Widget build(BuildContext context) {
    final rightAmountColor = txn.isPositive
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
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                )
              else
                const SizedBox(height: 18),
              const SizedBox(height: 4),
              Text(
                txn.amountText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: rightAmountColor,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

