import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:marg/shared/providers/app_providers.dart';
import 'package:marg/shared/models/reminder_policy.dart';
import '../providers/reminder_policy_provider.dart';

/// Permission prompt shown on Mobile Recharge screens.
///
/// Server determines whether we should show the prompt based on
/// `menu_item_slug` + `channel` (MVP uses `local_notifications`).
class ReminderPermissionCard extends ConsumerStatefulWidget {
  const ReminderPermissionCard({
    super.key,
    required this.menuItemSlug,
    this.channel = 'local_notifications',
  });

  final String menuItemSlug;
  final String channel;

  @override
  ConsumerState<ReminderPermissionCard> createState() =>
      _ReminderPermissionCardState();
}

class _ReminderPermissionCardState extends ConsumerState<ReminderPermissionCard> {
  bool _dismissedForSession = false;
  bool _submitting = false;

  Future<void> _handleAllow(ReminderPolicyDecision decision) async {
    setState(() => _submitting = true);
    try {
      final auth = ref.read(firebaseAuthServiceProvider);
      final user = auth.getCurrentUser();
      final idToken = await user?.getIdToken();
      if (idToken == null || idToken.isEmpty) return;

      final granted = await _requestLocalNotificationPermission();

      final api = ref.read(margApiServiceProvider);
      await api.postReminderConsent(
        idToken: idToken,
        menuItemSlug: widget.menuItemSlug,
        channel: widget.channel,
        consent: granted,
        policyVersion: decision.policyVersion,
      );

      ref.invalidate(
        reminderPolicyDecisionProvider(
          (menuItemSlug: widget.menuItemSlug, channel: widget.channel),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit consent: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<bool> _requestLocalNotificationPermission() async {
    if (widget.channel != 'local_notifications') {
      // MVP: only local notifications are supported, treat as "deny".
      return false;
    }
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> _handleDeny(ReminderPolicyDecision decision) async {
    setState(() => _submitting = true);
    try {
      final auth = ref.read(firebaseAuthServiceProvider);
      final user = auth.getCurrentUser();
      final idToken = await user?.getIdToken();
      if (idToken == null || idToken.isEmpty) return;

      final api = ref.read(margApiServiceProvider);
      await api.postReminderConsent(
        idToken: idToken,
        menuItemSlug: widget.menuItemSlug,
        channel: widget.channel,
        consent: false,
        policyVersion: decision.policyVersion,
      );

      ref.invalidate(
        reminderPolicyDecisionProvider(
          (menuItemSlug: widget.menuItemSlug, channel: widget.channel),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit denial: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissedForSession) return const SizedBox.shrink();

    final q = (menuItemSlug: widget.menuItemSlug, channel: widget.channel);
    final decisionAsync = ref.watch(reminderPolicyDecisionProvider(q));

    return decisionAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => _FallbackReminderCard(
        submitting: _submitting,
        onAllow: () async {
          // Best-effort local permission request (no server cooldown without policy decision).
          setState(() => _submitting = true);
          try {
            await _requestLocalNotificationPermission();
          } finally {
            if (mounted) setState(() => _submitting = false);
          }
        },
        onDeny: () {
          setState(() => _dismissedForSession = true);
        },
      ),
      data: (ReminderPolicyDecision? decision) {
        if (decision == null) return const SizedBox.shrink();
        if (!decision.shouldPrompt) return const SizedBox.shrink();

        final policy = decision.policy;
        if (policy == null) {
          return _FallbackReminderCard(
            submitting: _submitting,
            onAllow: () async {
              setState(() => _submitting = true);
              try {
                await _requestLocalNotificationPermission();
              } finally {
                if (mounted) setState(() => _submitting = false);
              }
            },
            onDeny: () {
              setState(() => _dismissedForSession = true);
            },
          );
        }

        return _PolicyReminderCard(
          submitting: _submitting,
          title: policy.title ?? 'Enable plan validity reminders',
          message: policy.message,
          allowButtonText: policy.allowButtonText,
          denyButtonText: policy.denyButtonText,
          onAllow: () => _handleAllow(decision),
          onDeny: () => _handleDeny(decision),
        );
      },
    );
  }
}

class _FallbackReminderCard extends StatelessWidget {
  const _FallbackReminderCard({
    required this.submitting,
    required this.onAllow,
    required this.onDeny,
  });

  final bool submitting;
  final VoidCallback onDeny;
  final Future<void> Function() onAllow;

  @override
  Widget build(BuildContext context) {
    const mobileRechargePurple = Color(0xFF6B2D91);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Be reminded before your plan validity expires',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Allow access to notifications to fetch your bills and remind on time',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: mobileRechargePurple,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: submitting ? null : onAllow,
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Center(
                              child: Text(
                                'Allow',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: submitting ? null : onDeny,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFDDDDDD)),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Not now',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111111),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.phone_android_rounded,
            size: 56,
            color: mobileRechargePurple.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}

class _PolicyReminderCard extends StatelessWidget {
  const _PolicyReminderCard({
    required this.submitting,
    required this.title,
    required this.message,
    required this.allowButtonText,
    required this.denyButtonText,
    required this.onAllow,
    required this.onDeny,
  });

  final bool submitting;
  final String title;
  final String message;
  final String allowButtonText;
  final String denyButtonText;
  final Future<void> Function() onAllow;
  final Future<void> Function() onDeny;

  @override
  Widget build(BuildContext context) {
    const mobileRechargePurple = Color(0xFF6B2D91);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: mobileRechargePurple,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: submitting ? null : onAllow,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Center(
                              child: Text(
                                allowButtonText,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: submitting ? null : () => onDeny(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFDDDDDD)),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          denyButtonText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111111),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.phone_android_rounded,
            size: 56,
            color: mobileRechargePurple.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}

