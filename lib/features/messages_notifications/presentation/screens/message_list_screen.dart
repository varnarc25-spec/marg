import 'package:flutter/material.dart';
import 'message_filter_screen.dart';
import 'message_search_screen.dart';
import 'message_chat_screen.dart';

/// Screen 107: Message - List (Inbox View)
const Color _messagePurple = Color(0xFF6C63FF);

class _MessageThread {
  final String name;
  final String initial;
  final String preview;
  final String timeOrBadge;
  final bool isUnread;
  const _MessageThread({
    required this.name,
    required this.initial,
    required this.preview,
    required this.timeOrBadge,
    this.isUnread = false,
  });
}

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  static const List<_MessageThread> _pinned = [
    _MessageThread(
      name: 'Marielle Wigington',
      initial: 'M',
      preview: 'You sent a gift.',
      timeOrBadge: '3',
      isUnread: true,
    ),
    _MessageThread(
      name: 'Tyra Dhillon',
      initial: 'T',
      preview: 'You sent a gift.',
      timeOrBadge: '12:00 PM',
      isUnread: false,
    ),
  ];

  static const List<_MessageThread> _all = [
    _MessageThread(name: 'Marci Senter', initial: 'M', preview: 'Thanks!', timeOrBadge: '11:30 AM', isUnread: false),
    _MessageThread(name: 'Rachel Foose', initial: 'R', preview: 'See you tomorrow', timeOrBadge: 'Yesterday', isUnread: false),
    _MessageThread(name: 'Rodolfo Goode', initial: 'R', preview: 'Got it', timeOrBadge: 'Oct 28', isUnread: false),
    _MessageThread(name: 'Charlotte Hamlin', initial: 'C', preview: 'Hello', timeOrBadge: 'Oct 27', isUnread: false),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() => _query = _searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(_MessageThread t) {
    if (_query.isEmpty) return true;
    return t.name.toLowerCase().contains(_query.toLowerCase());
  }

  void _openFilter() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const MessageFilterScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinnedFiltered = _pinned.where(_matches).toList();
    final allFiltered = _all.where(_matches).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Message'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: _openFilter,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 80),
                children: [
                  if (pinnedFiltered.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.push_pin_rounded, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(
                          'Pinned message',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...pinnedFiltered.map((t) => _ThreadTile(thread: t)),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    children: [
                      Icon(Icons.public_rounded, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        'All Message',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...allFiltered.map((t) => _ThreadTile(thread: t)),
                ],
              ),
            ),
            _buildBottomNav(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MessageSearchScreen()),
          );
        },
        backgroundColor: _messagePurple,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    const labels = ['Home', 'Market', 'Message', 'Profile'];
    const icons = [
      Icons.home_rounded,
      Icons.show_chart_rounded,
      Icons.chat_bubble_rounded,
      Icons.person_rounded,
    ];
    const selectedIndex = 2;
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (i) {
          final isSelected = i == selectedIndex;
          return InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icons[i],
                    size: 24,
                    color: isSelected ? _messagePurple : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? _messagePurple : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ThreadTile extends StatelessWidget {
  final _MessageThread thread;

  const _ThreadTile({required this.thread});

  @override
  Widget build(BuildContext context) {
    final isBadge = thread.isUnread && int.tryParse(thread.timeOrBadge) != null;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MessageChatScreen(
              name: thread.name,
              initial: thread.initial,
              isOnline: thread.name == 'Marielle Wigington',
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: _messagePurple.withValues(alpha: 0.2),
              child: Text(
                thread.initial,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF6C63FF)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thread.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    thread.preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            if (isBadge)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _messagePurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  thread.timeOrBadge,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              )
            else
              Text(
                thread.timeOrBadge,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
