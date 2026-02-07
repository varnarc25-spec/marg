import 'package:flutter/material.dart';

/// Screen 122: Social Media - Link Account
const Color _linkPurple = Color(0xFF6C63FF);

class _LinkOption {
  final String name;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool isConnected;
  const _LinkOption({
    required this.name,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.isConnected,
  });
}

class LinkAccountScreen extends StatefulWidget {
  const LinkAccountScreen({super.key});

  @override
  State<LinkAccountScreen> createState() => _LinkAccountScreenState();
}

class _LinkAccountScreenState extends State<LinkAccountScreen> {
  late List<_LinkOption> _options;

  @override
  void initState() {
    super.initState();
    _options = [
      const _LinkOption(
        name: 'Facebook',
        description: 'Connect facebook account',
        icon: Icons.facebook_rounded,
        iconColor: Color(0xFF1877F2),
        isConnected: true,
      ),
      const _LinkOption(
        name: 'Instagram',
        description: 'Connect instagram account',
        icon: Icons.camera_alt_rounded,
        iconColor: Color(0xFFE4405F),
        isConnected: false,
      ),
      const _LinkOption(
        name: 'Twitter',
        description: 'Connect twitter account',
        icon: Icons.tag_rounded,
        iconColor: Color(0xFF1DA1F2),
        isConnected: false,
      ),
      const _LinkOption(
        name: 'Google',
        description: 'Connect google account',
        icon: Icons.g_mobiledata_rounded,
        iconColor: Color(0xFF4285F4),
        isConnected: true,
      ),
      const _LinkOption(
        name: 'Apple',
        description: 'Connect apple account',
        icon: Icons.apple_rounded,
        iconColor: Color(0xFF000000),
        isConnected: false,
      ),
    ];
  }

  void _onConnectTap(int index) {
    setState(() {
      _options = List.from(_options);
      _options[index] = _LinkOption(
        name: _options[index].name,
        description: _options[index].description,
        icon: _options[index].icon,
        iconColor: _options[index].iconColor,
        isConnected: !_options[index].isConnected,
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
        title: const Text('Link Account'),
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
            return _LinkCard(
              option: option,
              onTap: () => _onConnectTap(index),
            );
          },
        ),
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final _LinkOption option;
  final VoidCallback onTap;

  const _LinkCard({required this.option, required this.onTap});

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
              color: option.iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(option.icon, size: 26, color: option.iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.name,
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
          Material(
            color: option.isConnected
                ? _linkPurple.withValues(alpha: 0.12)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  option.isConnected ? 'Connected' : 'Connect',
                  style: TextStyle(
                    color: option.isConnected ? _linkPurple : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
