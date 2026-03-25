import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/shared/providers/app_providers.dart';

import '../../data/life_insurance_api_exceptions.dart';
import '../../data/life_insurance_plan.dart';
import '../providers/life_insurance_provider.dart';

/// Pick two plans and show JSON compare result from the API.
Future<void> showLifePlansCompareDialog(
  BuildContext context,
  WidgetRef ref,
  List<LifeTermPlan> plans,
) async {
  if (plans.length < 2) return;
  final first = await showDialog<String>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: const Text('Pick first plan'),
      children: plans
          .map(
            (p) => SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, p.id),
              child: Text(p.insurerName),
            ),
          )
          .toList(),
    ),
  );
  if (first == null || !context.mounted) return;
  final second = await showDialog<String>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: const Text('Pick second plan'),
      children: plans
          .where((p) => p.id != first)
          .map(
            (p) => SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, p.id),
              child: Text(p.insurerName),
            ),
          )
          .toList(),
    ),
  );
  if (second == null || !context.mounted) return;

  try {
    final api = ref.read(lifeInsuranceApiServiceProvider);
    final auth = ref.read(firebaseAuthServiceProvider);
    final token = await auth.getIdToken();
    final result = await api.comparePlans(
      {'planIds': [first, second]},
      idToken: token,
    );
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Compare'),
        content: SingleChildScrollView(
          child: SelectableText(
            const JsonEncoder.withIndent('  ').convert(result),
            style: Theme.of(ctx).textTheme.bodySmall,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(lifeInsuranceApiUserMessage(e))),
    );
  }
}

/// Load full plan details JSON and show in a dialog.
Future<void> showLifePlanDetailsDialog(
  BuildContext context,
  WidgetRef ref,
  LifeTermPlan plan,
) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
  try {
    final api = ref.read(lifeInsuranceApiServiceProvider);
    final auth = ref.read(firebaseAuthServiceProvider);
    final token = await auth.getIdToken();
    final detail = await api.getPlanDetails(plan.id, idToken: token);
    if (!context.mounted) return;
    Navigator.of(context).pop();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(plan.insurerName),
        content: SingleChildScrollView(
          child: SelectableText(
            const JsonEncoder.withIndent('  ').convert(detail),
            style: Theme.of(ctx).textTheme.bodySmall,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  } catch (e) {
    if (context.mounted) Navigator.of(context).pop();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(lifeInsuranceApiUserMessage(e))),
    );
  }
}
