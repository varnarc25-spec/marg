import 'package:flutter/material.dart';
import 'message_chat_screen.dart';

/// Screen 109: Message - Search (Recipient Selection / New Message)
const Color _searchPurple = Color(0xFF6C63FF);

class _SearchContact {
  final String name;
  final String initial;
  const _SearchContact({required this.name, required this.initial});
}

class MessageSearchScreen extends StatefulWidget {
  const MessageSearchScreen({super.key});

  @override
  State<MessageSearchScreen> createState() => _MessageSearchScreenState();
}

class _MessageSearchScreenState extends State<MessageSearchScreen> {
  final _searchController = TextEditingController();

  static const List<_SearchContact> _contacts = [
    _SearchContact(name: 'Marielle Wigington', initial: 'M'),
    _SearchContact(name: 'Tyra Dhillon', initial: 'T'),
    _SearchContact(name: 'Marci Senter', initial: 'M'),
    _SearchContact(name: 'Rachel Foose', initial: 'R'),
    _SearchContact(name: 'Rodolfo Goode', initial: 'R'),
  ];

  List<_SearchContact> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return _contacts;
    return _contacts.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 22,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final c = filtered[index];
          return _ContactTile(
            name: c.name,
            initial: c.initial,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MessageChatScreen(
                    name: c.name,
                    initial: c.initial,
                    isOnline: c.name == 'Marielle Wigington',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final String name;
  final String initial;
  final VoidCallback onTap;

  const _ContactTile({required this.name, required this.initial, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _searchPurple.withValues(alpha: 0.2),
              child: Text(
                initial,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF6C63FF)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
