import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Purple accent for history
const Color _historyPurple = Color(0xFF6C63FF);

/// Screen 91: History Transaction – chronological list grouped by date
class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <_HistorySection>[
      _HistorySection(
        dateLabel: '20 October 2022',
        items: [
          _HistoryItem(title: 'Send (AMZN)', time: '07:00 PM', qty: '-2.00', amount: '\$224.90', iconBg: _historyPurple, iconData: Icons.send_rounded),
          _HistoryItem(title: 'Buy AAPL', time: '04:00 PM', qty: '+7.00', amount: '\$1,016.33', iconBg: Colors.black87, iconData: Icons.apple),
          _HistoryItem(title: 'Sell ADA', time: '04:00 PM', qty: '-250', amount: '\$87.69', iconBg: Colors.blue, iconData: Icons.star_rounded),
        ],
      ),
      _HistorySection(
        dateLabel: '15 October 2022',
        items: [
          _HistoryItem(title: 'Buy AMD', time: '02:15 PM', qty: '+3.00', amount: '\$172.38', iconBg: AppColors.accentGreen, iconData: Icons.trending_up_rounded),
          _HistoryItem(title: 'Sell Gold', time: '10:15 AM', qty: '-5.0g', amount: '\$549.00', iconBg: const Color(0xFFD4AF37), iconData: Icons.diamond_rounded),
        ],
      ),
      _HistorySection(
        dateLabel: '30 September 2022',
        items: [
          _HistoryItem(title: 'BTC/USDT', time: '12:00 PM', qty: '0.500', amount: '9.594', iconBg: const Color(0xFFF7931A), iconData: Icons.currency_bitcoin_rounded),
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
        title: const Text('Transaction History'),
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
                    child: _HistoryCard(item: t),
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

class _HistorySection {
  final String dateLabel;
  final List<_HistoryItem> items;

  _HistorySection({required this.dateLabel, required this.items});
}

class _HistoryItem {
  final String title;
  final String time;
  final String qty;
  final String amount;
  final Color iconBg;
  final IconData iconData;

  _HistoryItem({
    required this.title,
    required this.time,
    required this.qty,
    required this.amount,
    required this.iconBg,
    required this.iconData,
  });
}

class _HistoryCard extends StatelessWidget {
  final _HistoryItem item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12)),
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
              color: item.iconBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(item.iconData, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
                Text(
                  item.time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.qty,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                item.amount,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
