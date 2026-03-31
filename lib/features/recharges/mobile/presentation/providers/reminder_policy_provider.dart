import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/shared/models/reminder_policy.dart';
import 'package:marg/shared/providers/app_providers.dart';

typedef ReminderPolicyQuery = ({String menuItemSlug, String channel});

/// GET reminder policy + decision payload for the app-side reminder gate.
///
/// Returns `null` when:
/// - user is not logged in
/// - server is unreachable
/// - response parsing fails
final reminderPolicyDecisionProvider = FutureProvider.autoDispose
    .family<ReminderPolicyDecision?, ReminderPolicyQuery>((ref, q) async {
  final auth = ref.watch(firebaseAuthServiceProvider);
  if (!auth.isLoggedIn()) return null;

  final user = auth.getCurrentUser();
  if (user == null) return null;

  try {
    final idToken = await user.getIdToken();
    if (idToken == null || idToken.isEmpty) return null;

    final api = ref.watch(margApiServiceProvider);
    return await api.getReminderPolicyDecision(
      idToken: idToken,
      menuItemSlug: q.menuItemSlug,
      channel: q.channel,
    );
  } catch (_) {
    return null;
  }
});

