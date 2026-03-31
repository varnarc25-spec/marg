/// Reminder policy returned by the server to control when we should prompt the
/// user to enable OS-level reminders (e.g. notifications).
///
/// This is driven by (`menu_item_slug`, `channel`) and versioned via `policyVersion`
/// so admins can "re-prompt all users" by incrementing the policy version.
class ReminderPolicy {
  const ReminderPolicy({
    required this.menuItemSlug,
    required this.channel,
    required this.policyVersion,
    this.title,
    required this.message,
    this.allowButtonText = 'Allow',
    this.denyButtonText = 'Not now',
    this.deniedCooldownDays,
  });

  final String menuItemSlug;
  final String channel;
  final int policyVersion;

  final String? title;
  final String message;

  final String allowButtonText;
  final String denyButtonText;

  /// How many days we should hide the prompt after denial (server-side).
  final int? deniedCooldownDays;

  factory ReminderPolicy.fromJson(Map<String, dynamic> json) {
    final menuItemSlug = (json['menuItemSlug'] ?? json['menu_item_slug'] ?? '')
        .toString()
        .trim();
    final channel = (json['channel'] ?? '').toString().trim();
    final policyVersion = (json['policyVersion'] ?? json['policy_version'] ?? 0) as num?;
    return ReminderPolicy(
      menuItemSlug: menuItemSlug,
      channel: channel,
      policyVersion: policyVersion?.toInt() ?? 0,
      title: (json['title'] ?? json['messageTitle'] ?? json['message_title'])
          ?.toString()
          .trim(),
      message: (json['message'] ?? json['body'] ?? json['message_body'] ?? '')
          .toString(),
      allowButtonText:
          (json['allowButtonText'] ?? json['allow_button_text'] ?? 'Allow').toString(),
      denyButtonText:
          (json['denyButtonText'] ?? json['deny_button_text'] ?? 'Not now').toString(),
      deniedCooldownDays: ((json['deniedCooldownDays'] ??
                  json['denied_cooldown_days'] ??
                  json['cooldown_days']) as num?)
          ?.toInt(),
    );
  }
}

class ReminderPolicyDecision {
  const ReminderPolicyDecision({
    required this.shouldPrompt,
    this.policyVersion,
    this.deniedUntil,
    this.policy,
  });

  final bool shouldPrompt;

  /// Current policy version from the server.
  final int? policyVersion;

  final DateTime? deniedUntil;

  final ReminderPolicy? policy;

  factory ReminderPolicyDecision.fromJson(Map<String, dynamic> json) {
    final deniedUntilRaw = json['deniedUntil'] ?? json['denied_until'];
    final deniedUntil = deniedUntilRaw is String
        ? DateTime.tryParse(deniedUntilRaw)
        : deniedUntilRaw is DateTime
            ? deniedUntilRaw
            : null;

    final policy = json['policy'];
    final parsedPolicy =
        policy is Map<String, dynamic> ? ReminderPolicy.fromJson(policy) : null;

    final policyVersion =
        (json['policyVersion'] ?? json['policy_version'] ?? parsedPolicy?.policyVersion) as num?;

    return ReminderPolicyDecision(
      shouldPrompt: json['shouldPrompt'] == true,
      policyVersion: policyVersion?.toInt(),
      deniedUntil: deniedUntil,
      policy: parsedPolicy,
    );
  }
}

