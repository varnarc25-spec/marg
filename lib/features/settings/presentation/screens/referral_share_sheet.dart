import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Screen 132: Referral Code - Share (bottom sheet)
const Color _sharePurple = Color(0xFF6C63FF);

class ReferralShareSheet extends StatelessWidget {
  final String referralCode;

  const ReferralShareSheet({super.key, this.referralCode = '@helena02'});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Invite your friends',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Helena journeys',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black87,
                            height: 1.4,
                          ),
                      children: [
                        const TextSpan(text: 'I earned '),
                        TextSpan(
                          text: '\$5',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _sharePurple,
                          ),
                        ),
                        const TextSpan(text: ' in assets by finishing '),
                        TextSpan(
                          text: '1',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _sharePurple,
                          ),
                        ),
                        const TextSpan(text: ' lesson about '),
                        TextSpan(
                          text: '4',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _sharePurple,
                          ),
                        ),
                        const TextSpan(text: ' investments'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Use referral code and earn commission',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: _sharePurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            referralCode,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _CopyChip(
                        referralCode: referralCode,
                        onCopy: () {
                          Clipboard.setData(ClipboardData(text: referralCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Referral code copied'), duration: Duration(seconds: 2)),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ShareOption(
                        icon: Icons.copy_rounded,
                        label: 'Copy',
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: referralCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied'), duration: Duration(seconds: 2)),
                          );
                        },
                      ),
                      _ShareOption(
                        icon: Icons.chat_rounded,
                        label: 'Whatsapp',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      _ShareOption(
                        icon: Icons.camera_alt_rounded,
                        label: 'Instagram',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      _ShareOption(
                        icon: Icons.more_horiz_rounded,
                        label: 'More',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CopyChip extends StatelessWidget {
  final String referralCode;
  final VoidCallback onCopy;

  const _CopyChip({required this.referralCode, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _sharePurple.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onCopy,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copy_rounded, size: 20, color: _sharePurple),
              const SizedBox(width: 6),
              Text(
                'Copy',
                style: TextStyle(color: _sharePurple, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShareOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _sharePurple.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 26, color: _sharePurple),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
