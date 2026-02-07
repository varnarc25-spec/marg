import 'package:flutter/material.dart';

/// Screen 125: Push Notifications – notification categories with toggles
const Color _notifPurple = Color(0xFF6C63FF);

class _NotificationOption {
  final String title;
  final String description;
  final IconData icon;
  final bool enabled;
  const _NotificationOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.enabled,
  });
}

class PushNotificationsScreen extends StatefulWidget {
  const PushNotificationsScreen({super.key});

  @override
  State<PushNotificationsScreen> createState() => _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends State<PushNotificationsScreen> {
  late List<_NotificationOption> _options;

  @override
  void initState() {
    super.initState();
    _options = [
      const _NotificationOption(
        title: 'News',
        description: 'Receive notification for news',
        icon: Icons.article_outlined,
        enabled: true,
      ),
      const _NotificationOption(
        title: 'Promotion',
        description: 'Receive notification for promotion',
        icon: Icons.local_offer_outlined,
        enabled: false,
      ),
      const _NotificationOption(
        title: 'Community',
        description: 'Receive notification for community',
        icon: Icons.people_outline_rounded,
        enabled: false,
      ),
      const _NotificationOption(
        title: 'Telegram',
        description: 'Get notified from Telegram chat',
        icon: Icons.send_rounded,
        enabled: true,
      ),
      const _NotificationOption(
        title: 'Email',
        description: 'Get notified from Email',
        icon: Icons.mail_outline_rounded,
        enabled: true,
      ),
      const _NotificationOption(
        title: 'Whatsapp',
        description: 'Get notified from Whatsapp',
        icon: Icons.chat_bubble_outline_rounded,
        enabled: true,
      ),
    ];
  }

  void _onToggle(int index, bool value) {
    setState(() {
      _options = List.from(_options);
      _options[index] = _NotificationOption(
        title: _options[index].title,
        description: _options[index].description,
        icon: _options[index].icon,
        enabled: value,
      );
    });
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
        title: const Text('Notification'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          itemCount: _options.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final option = _options[index];
            return _NotificationCard(
              option: option,
              onChanged: (value) => _onToggle(index, value),
            );
          },
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final _NotificationOption option;
  final ValueChanged<bool> onChanged;

  const _NotificationCard({required this.option, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12)),
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
              color: _notifPurple.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(option.icon, size: 26, color: _notifPurple),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  option.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: option.enabled,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: _notifPurple,
          ),
        ],
      ),
    );
  }
}
