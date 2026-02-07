import 'package:flutter/material.dart';
import 'notification_verify_email_screen.dart';
import 'notification_sort_screen.dart';

/// Screen 112: Notification (Notification List View)
const Color _notifPurple = Color(0xFF6C63FF);

class _NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String time;
  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.time,
  });
}

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<_NotificationItem> _items = [
    _NotificationItem(
      icon: Icons.mark_email_read_rounded,
      iconColor: Color(0xFF6C63FF),
      title: 'Email verified',
      time: '12:00 PM',
    ),
    _NotificationItem(
      icon: Icons.show_chart_rounded,
      iconColor: Color(0xFF00C853),
      title: 'Price alert! AMD current price is \$24.08',
      time: '10:15 AM',
    ),
    _NotificationItem(
      icon: Icons.attach_money_rounded,
      iconColor: Color(0xFF00C853),
      title: 'Deposit USD Successful',
      time: 'Oct 29',
    ),
    _NotificationItem(
      icon: Icons.trending_up_rounded,
      iconColor: Color(0xFF6C63FF),
      title: 'ADA current price alert',
      time: 'Oct 28',
    ),
    _NotificationItem(
      icon: Icons.shopping_cart_rounded,
      iconColor: Color(0xFF00C853),
      title: 'MAZN purchase completed',
      time: 'Oct 27',
    ),
    _NotificationItem(
      icon: Icons.currency_bitcoin_rounded,
      iconColor: Color(0xFF6C63FF),
      title: 'SOL price alert',
      time: 'Oct 26',
    ),
    _NotificationItem(
      icon: Icons.account_balance_wallet_rounded,
      iconColor: Color(0xFF00C853),
      title: 'AAHB deposit successful',
      time: 'Oct 25',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openSort() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const NotificationSortScreen(),
    );
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
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_vert_rounded),
            onPressed: _openSort,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: _notifPurple,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          indicatorColor: _notifPurple,
          tabs: const [
            Tab(text: 'Information'),
            Tab(text: 'Activity'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _NotificationList(items: _items, onTapEmail: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationVerifyEmailScreen()),
            );
          }),
          _NotificationList(items: _items, onTapEmail: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationVerifyEmailScreen()),
            );
          }),
        ],
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  final List<_NotificationItem> items;
  final VoidCallback onTapEmail;

  const _NotificationList({required this.items, required this.onTapEmail});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isEmail = item.title.toLowerCase().contains('email');
        return InkWell(
          onTap: isEmail ? onTapEmail : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(item.icon, size: 24, color: item.iconColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.time,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
