import 'package:flutter/material.dart';

/// Screen 108: Message - Filter (Overlay for Inbox)
const Color _filterPurple = Color(0xFF6C63FF);

enum MessageFilterOption { all, unread, unanswered }

class MessageFilterScreen extends StatefulWidget {
  const MessageFilterScreen({super.key});

  @override
  State<MessageFilterScreen> createState() => _MessageFilterScreenState();
}

class _MessageFilterScreenState extends State<MessageFilterScreen> {
  MessageFilterOption _selected = MessageFilterOption.all;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            _OptionTile(
              label: 'All Message',
              selected: _selected == MessageFilterOption.all,
              onTap: () => setState(() => _selected = MessageFilterOption.all),
            ),
            _OptionTile(
              label: 'Unread Message',
              selected: _selected == MessageFilterOption.unread,
              onTap: () => setState(() => _selected = MessageFilterOption.unread),
            ),
            _OptionTile(
              label: 'Unanswered',
              selected: _selected == MessageFilterOption.unanswered,
              onTap: () => setState(() => _selected = MessageFilterOption.unanswered),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: _filterPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Done'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              size: 24,
              color: selected ? _filterPurple : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
